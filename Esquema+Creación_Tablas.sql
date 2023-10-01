Create schema Distribuidor_Mayorista;

Create table Provincias (
IdProvincia int,
Nombre varchar (30),
primary key (IdProvincia)
);

Create table Localidades (
IdLocalidad int,
IdProvincia int,
Nombre varchar (30) not null,
CodigoPostal varchar (10) not null,
primary key (IdLocalidad),
foreign key (IdProvincia) references Provincias(IdProvincia)
);

Create table Empresa (
Nombre varchar(30) not null,
Cuit varchar(15),
Domicilio varchar(50) not null,
IdLocalidad int,
IdProvincia int,
Telefono varchar(20) not null,
primary key (Cuit),
foreign key (IdLocalidad) references Localidades(IdLocalidad),
foreign key (IdProvincia) references Provincias(IdProvincia)  
);

Create table Proveedores (
IdProveedor int,
Nombre varchar(30) not null,
Cuit varchar(15) not null,
Domicilio varchar(50) not null,
IdLocalidad int,
IdProvincia int,
Telefono varchar(20) not null,
Productos varchar(30) not null,
primary key (IdProveedor),
foreign key (IdLocalidad) references Localidades(IdLocalidad),
foreign key (IdProvincia) references Provincias(IdProvincia)  
);

Create table Stock (
IdProducto int,
IdProveedor int,
Nombre varchar(30) not null,
Cantidad int not null,
Sector varchar(5) not null,
primary key (IdProducto),
foreign key (IdProveedor) references Proveedores(IdProveedor) 
);

Create table Empleados (
IdEmpleado int,
Nombre varchar(30) not null,
Domicilio varchar(50) not null,
IdLocalidad int,
IdProvincia int,
Telefono varchar(20) not null,
Puesto varchar (30) not null,
Cumpleaños date not null,
FechaIngreso date not null,
primary key (IdEmpleado),
foreign key (IdLocalidad) references Localidades(IdLocalidad),
foreign key (IdProvincia) references Provincias(IdProvincia)
);

Create table Clientes (
IdCliente int,
Cuit varchar(15) not null,
Nombre varchar(30) not null,
Domicilio varchar(50) not null,
IdLocalidad int,
IdProvincia int,
Telefono varchar(20) not null,
Cumpleaños date not null,
primary key (IdCliente),
foreign key (IdLocalidad) references Localidades(IdLocalidad),
foreign key (IdProvincia) references Provincias(IdProvincia)  
);

Create table Ventas (
NumeroFactura varchar (20),
CondicionFiscal varchar (20) not null,
IdProducto int,
IdCliente int,
FechaVenta date not null,
Cantidad int not null,
MontoTotal int not null, 
primary key (NumeroFactura),
foreign key (IdProducto) references stock(IdProducto),
foreign key (IdCliente) references Clientes(IdCliente) 
);