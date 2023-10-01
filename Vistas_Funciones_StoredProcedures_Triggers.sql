-- VISTAS --
Create View Procedencia_Clientes as
(Select provincias.Nombre, count(provincias.IdProvincia) as Cant_Clientes_Prov
From Clientes
join provincias on clientes.IdProvincia = provincias.IdProvincia
group by provincias.Nombre);

Select * From Procedencia_Clientes;


Create View Cant_Empl_Puesto as 
(Select Puesto,count(Puesto) as Cant_Empleados_Puesto
From empleados
group by Puesto);

Select * From Cant_Empl_Puesto;


Create View Proveedores_Locales as
(Select *
From proveedores
Where IdProvincia = (
	Select IdProvincia
    From empresa));

Select * From proveedores_Locales;


Create View Minima_Cant_Stock as 
(Select *
From Stock
Where Cantidad <= 5);

Select * From Minima_Cant_Stock;


Create View Top_Five_Clientes as 
(Select Clientes.IdCliente,clientes.Nombre,count(ventas.IdCliente) as Cantidad_Compras
From Ventas
join clientes on Ventas.idCliente = clientes.IdCliente
Group by clientes.Nombre,Clientes.IdCliente
Order by Cantidad_Compras desc
Limit 5);

Select * From Top_Five_Clientes


-- FUNCIONES -- 
 
 DELIMITER //
 
 CREATE FUNCTION `Calcular_Antiguedad`(id int) RETURNS int
    DETERMINISTIC
BEGIN
	declare Antiguedad int;
    Select round((datediff(curdate(),FechaIngreso) / 365)) into Antiguedad
    from empleados
	Where idEmpleado = id;
    
RETURN Antiguedad;
END;

// 

DELIMITER ;
 
select Calcular_Antiguedad(1);


DELIMITER //

CREATE FUNCTION `Nombre_ClientesByCuit`(clave varchar(15)) RETURNS varchar(255)
    READS SQL DATA
BEGIN
	 declare Nombre_Completo varchar(255);
     Select nombre Into Nombre_Completo
     From clientes 
     Where Cuit = clave; 
RETURN Nombre_Completo;
END;

// 

DELIMITER ;

select Nombre_ClientesByCuit('27-59776590-6');

-- STORED PROCEDURES --

DELIMITER //

CREATE PROCEDURE `Info_Empleados`(IN campo VARCHAR(50), IN orden VARCHAR(4))
BEGIN
	IF campo <> '' AND orden <> '' THEN
		SET @data_orden = concat(' ORDER BY ', campo, ' ', orden);
	ELSE
		SET @data_orden = '';
	END IF;
    
	SET @clausula = concat('SELECT * FROM Empleados', @data_orden);
	PREPARE runSQL FROM @clausula;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END;

CALL Info_Empleados('Nombre', 'DESC')

DELIMITER //

CREATE PROCEDURE `Ingresar_Nva_Loc`(IN idLoc int, IN idProv int, IN nombre varchar(30), IN CP varchar(10))
BEGIN
	IF nombre = '' THEN
		SELECT 'ERROR: No se puede ingresar una nueva localidad sin su correspondiente Nombre';
	ELSE
		INSERT INTO localidades VALUES (idLoc, idProv, nombre, CP);
        
        SELECT * FROM localidades ORDER BY IdLocalidad DESC;
	END IF;
END;
 
 CALL Ingresar_Nva_Loc (101, 17, 'San Pëdro', '1234');
 
 
 -- TRIGGERS --
 
-- Creamos la tabla de back-Up que se llenará cuando el trigger se active LUEGO 
-- de una inserción en la tabla Ventas
CREATE TABLE Ventas_BK (
NumeroFactura varchar(20) primary key, 
idCliente int, 
FechaVenta date
);

-- Trigger que se disparará LUEGO de una inserción en la tabla Ventas
CREATE TRIGGER insert_Vtas_BK
AFTER INSERT ON Ventas
FOR EACH ROW
	INSERT INTO ventas_bk (NumeroFactura,idCliente,FechaVenta) 
	VALUES (NEW.NumeroFactura, NEW.idCliente, NEW.FechaVenta);

-- Insert destinado a disparar el trigger "insert_Vtas_BK"
insert into Ventas
values ('A-005-0023098', 'Resp. Inscripto', 42 , 55 , '2012-12-13', 18 , 1500); 
    
-- Consultas creadas para verificar el correcto funcionamiento del trigger    
select * from ventas_bk;
select * from ventas where NumeroFactura = 'A-005-0023098';



-- Creamos la tabla de logs que se llenará cuando el trigger se active LUEGO 
-- de una modificación en la tabla Ventas. 
CREATE TABLE Auditoria_Ventas(
	usuario VARCHAR(50),
	fecha varchar(15),
	hora varchar(15)
);

-- Trigger que se dispara LUEGO de una modificación en la tabla Ventas
CREATE TRIGGER update_Tabla_Ventas
AFTER UPDATE ON ventas
FOR EACH ROW
	INSERT INTO Auditoria_Ventas (usuario, fecha, hora)
    VALUES (USER(), LEFT(CURRENT_TIMESTAMP(),10), RIGHT(CURRENT_TIMESTAMP(),8));

-- Update destinado a disparar el trigger "update_Tabla_Ventas"
UPDATE Ventas
SET MontoTotal = '1000' 
WHERE NumeroFactura = 'A-013-3698857';

-- Consultas creadas para verificar el correcto funcionamiento del trigger  
SELECT * FROM Auditoria_Ventas;
SELECT * FROM Ventas Where MontoTotal = '1000';

----------------------------------------------------------------------------------

-- Creamos la tabla de back-Up que se llenará cuando el trigger se active ANTES 
-- de una eliminación en la tabla Clientes
CREATE TABLE Clientes_BK ( 
IdCliente int primary key,
Cuit varchar(15) not null,
Nombre varchar(30) not null,
Domicilio varchar(50) not null,
IdLocalidad int,
IdProvincia int,
Telefono varchar(20) not null,
Cumpleaños date not null
);

-- Trigger que se dispara ANTES de una eliminación en la tabla Clientes
CREATE TRIGGER Save_Clientes_BK
BEFORE DELETE ON clientes
FOR EACH ROW
	INSERT INTO Clientes_BK 
	VALUES (OLD.idCliente, OLD.Cuit, OLD.Nombre, OLD.Domicilio,
			OLD.idLocalidad, OLD.idProvincia, OLD.Telefono, OLD.Cumpleaños);

-- insert hecho para luego poder borrar de forma más fácil el registro por 
-- tema restrcciones
INSERT INTO clientes
VALUES (1001, '20-19863981-7', 'Henry Gerran','65 Vidon Alley', 47, 24, '(662) 4090569', '1998-11-13');

-- Delete destinado a disparar el trigger "Save_Clientes_BK"
DELETE FROM Clientes
WHERE idCliente = 1001; 
    
-- Consultas creadas para verificar el correcto funcionamiento del trigger    
select * from Clientes_BK;
select * from Clientes WHERE idCliente = 1001;



-- Creamos la tabla de logs que se llenará cuando el trigger se active ANTES 
-- de una modificación en la tabla Clientes. 
CREATE TABLE Auditoria_Clientes(
	usuario VARCHAR(50),
	fecha varchar(15),
	hora varchar(15)
);

-- Trigger que se dispara ANTES de una modificación en la tabla Clientes
CREATE TRIGGER update_Tabla_Clientes
BEFORE UPDATE ON Clientes
FOR EACH ROW
	INSERT INTO Auditoria_clientes (usuario, fecha, hora)
    VALUES (USER(), LEFT(CURRENT_TIMESTAMP(),10), RIGHT(CURRENT_TIMESTAMP(),8));

-- Update destinado a disparar el trigger "update_Tabla_Clientes"
UPDATE Clientes
SET Domicilio = '498 Glacier Hill Road'
Where idCliente = 1; 

-- Consultas creadas para verificar el correcto funcionamiento del trigger  
SELECT * FROM Auditoria_Clientes;
select * from Clientes WHERE idCliente = 1;
 
