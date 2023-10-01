-- SUBLENGUAJE DCL -- 

-- De esta forma consultamos los usuarios activos y los permisos que tienen cada uno 
Use Mysql;
select * from mysql.user;

-- A continuación voy a crear el primer usuario y definirle en la misma sentencia
-- su contraseña, la misma esta visible ahora pero luego se encriptará por seguridad. 
Create user Mauro@localhost identified by 'Lola2023';

-- La palabra reservada "Show Grant" nos permite conocer los permisos asociados al 
-- usuario que le detallemos en la sentencia.
Show Grants For Mauro@localhost;

-- Otorgamos solamente permisos de lectura para la base de datos que creamos
-- al usuario detallado en la sentencia
Grant Select On distribuidor_mayorista.* To Mauro@localhost; 


-- A continuación voy a crear el segundo usuario, esta vez no le asignamos contraseña. 
Create user MauroAdvance@localhost;

-- Otorgamos permisos de lectura, inserción y actualización para la base de datos que 
-- creamos al usuario detallado en la sentencia
Grant Select,Insert, Update On distribuidor_mayorista.* To MauroAdvance@localhost; 

-- La palabra reservada "Show Grant" nos permite conocer los permisos asociados al 
-- usuario que le detallemos en la sentencia.
Show Grants For MauroAdvance@localhost;

-- -----------------------------------------------------------------------------------

-- SUBLENGUAJE TCL --

-- Esta sentencia desactiva el autocommit para poder tener control sobre
-- las transanciones DML, por defecto en MYSQL viene activado
Set @@autocommit = 0;

-- Comienza el limite de control de transacciones
Start transaction;

-- Sentencia DML que elimina esas 4 rows declaradas
delete from distribuidor_mayorista.localidades
Where IdLocalidad between 102 and 105;

-- El roolback lo utilizamos para deshacer una sentencia ejecutada por error 
-- dentro del limite declarado
rollback;

-- El commit lo utilizamos para confirmar la sentencia DML que ejecutamos dentro
-- del limite declarado
commit;

-- Valores insertados para luego ser eliminados dentro de la transacción
/*insert into distribuidor_mayorista.localidades
values
(102,12,'Marcos Juarez','123456'),
(103,12,'General Roca', '123457'),
(104,12,'Bell Ville','123458'),
(105,12,'Morrison','123459')*/

-- Consulta para corroborar si hubo cambios 
select * from distribuidor_mayorista.localidades;
-----------------------------------------------------------------------------------
-- Consultamos el estado del autocommit 0:Desactivado 1:Activado
select @@autocommit;

-- Comienza el limite de control de transacciones
Start transaction;

insert into distribuidor_mayorista.stock values (51,50,'Absolut Orange',80,'A-10');
insert into distribuidor_mayorista.stock values (52,50,'Absolut Blue',80,'A-10');
insert into distribuidor_mayorista.stock values (53,50,'Absolut Green',80,'A-10');
insert into distribuidor_mayorista.stock values (54,50,'Absolut Red',80,'A-10');
savepoint Absoluts;
insert into distribuidor_mayorista.stock values(55,50,'Gin Marte',80,'A-1');
insert into distribuidor_mayorista.stock values(56,50,'Gin Saturno',80,'A-1');
insert into distribuidor_mayorista.stock values(57,50,'Gin Neptuno',80,'A-1');
insert into distribuidor_mayorista.stock values(58,50,'Gin Venus',80,'A-1');
savepoint Gins;

-- A través de esta sentencia liberamos el savepoint puesto en la linea 48
release savepoint Absoluts;

-- Debemos luego de las inserciones confirmar o deshacer las sentencias

-- El roolback lo utilizamos para deshacer una sentencia ejecutada por error 
-- dentro del limite declarado. También agregándole la clausula "TO" y el nombre
-- de un savepoint hasta el cual queremos deshacer o ejecutarlo para toda la acción
rollback;

-- El commit lo utilizamos para confirmar la sentencia DML que ejecutamos dentro
-- del limite declarado
commit;

-- consulta para corroborar si hubo cambios
select * from distribuidor_mayorista.stock