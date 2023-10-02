-- Gráfico N° 1 --

Select provincias.Nombre, count(provincias.IdProvincia) as Cantidad
From distribuidor_mayorista.clientes
join distribuidor_mayorista.provincias 
on clientes.IdProvincia = provincias.IdProvincia
group by provincias.Nombre
order by Cantidad DESC;

-- Gráfico N° 2 --

Select Puesto, count(Puesto) as Cantidad
From distribuidor_mayorista.empleados
group by Puesto
order by Puesto ASC;

-- Gráfico N° 3 --

Select provincias.Nombre, count(proveedores.IdProvincia) as Cantidad
From distribuidor_mayorista.proveedores
join distribuidor_mayorista.provincias
on provincias.IdProvincia = proveedores.IdProvincia
group by provincias.Nombre
order by Cantidad DESC;

-- Gráfico N° 4 --

Select year(ventas.FechaVenta) as Año, sum(ventas.MontoTotal) as Total
From distribuidor_mayorista.ventas
group by Año
order by Año ASC;

-- Gráfico N° 5 --

Select Nombre,Cantidad
From distribuidor_mayorista.stock
Where Cantidad < 50
order by Cantidad DESC;


