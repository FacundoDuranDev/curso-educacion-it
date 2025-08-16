-- Script para crear tablas e insertar datos de Etapa 1
-- Base de datos: educacionit
-- Basado en la estructura real de los archivos CSV

-- 1. Crear tabla Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id INTEGER PRIMARY KEY,
    provincia VARCHAR(100),
    nombre_y_apellido VARCHAR(200),
    domicilio TEXT,
    telefono VARCHAR(50),
    edad INTEGER,
    localidad VARCHAR(100),
    x VARCHAR(20), 
    y VARCHAR(20), 
    fecha_alta DATE,
    usuario_alta VARCHAR(50),
    fecha_ultima_modificacion DATE,
    usuario_ultima_modificacion VARCHAR(50),
    marca_baja INTEGER,
    col10 VARCHAR(50)
);

-- 2. Crear tabla Sucursales
CREATE TABLE IF NOT EXISTS sucursales (
    id INTEGER PRIMARY KEY,
    sucursal VARCHAR(100),
    direccion TEXT,
    localidad VARCHAR(100),
    provincia VARCHAR(100),
    latitud VARCHAR(20),
    longitud VARCHAR(20)
);

-- 3. Crear tabla Tipos de Gasto
CREATE TABLE IF NOT EXISTS tipos_gasto (
    id_tipo_gasto INTEGER PRIMARY KEY,
    descripcion VARCHAR(100),
    monto_aproximado DECIMAL(10,2)
);

-- 4. Crear tabla Gastos
CREATE TABLE IF NOT EXISTS gastos (
    id_gasto INTEGER PRIMARY KEY,
    id_sucursal INTEGER,
    id_tipo_gasto INTEGER,
    fecha DATE,
    monto DECIMAL(10,2),
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id),
    FOREIGN KEY (id_tipo_gasto) REFERENCES tipos_gasto(id_tipo_gasto)
);

-- 5. Crear tabla Compras
CREATE TABLE IF NOT EXISTS compras (
    id_compra INTEGER PRIMARY KEY,
    fecha DATE,
    id_producto INTEGER,
    cantidad INTEGER,
    precio DECIMAL(10,2),
    id_proveedor INTEGER
);

-- 6. Crear tabla Productos
CREATE TABLE IF NOT EXISTS productos (
    id_producto INTEGER PRIMARY KEY,
    concepto VARCHAR(200),
    tipo VARCHAR(100),
    precio DECIMAL(15,2)
);

-- 7. Crear tabla Proveedores
CREATE TABLE IF NOT EXISTS proveedores (
    id_proveedor INTEGER PRIMARY KEY,
    nombre VARCHAR(200),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    departamen VARCHAR(100)
);

-- 8. Crear tabla Empleados
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INTEGER PRIMARY KEY,
    apellido VARCHAR(100),
    nombre VARCHAR(100),
    sucursal VARCHAR(100),
    sector VARCHAR(100),
    cargo VARCHAR(100),
    salario DECIMAL(10,2)
);

-- 9. Crear tabla Canal de Venta
CREATE TABLE IF NOT EXISTS canal_venta (
    codigo INTEGER PRIMARY KEY,
    descripcion VARCHAR(100)
);

-- 10. Crear tabla Ventas
CREATE TABLE IF NOT EXISTS ventas (
    id_venta INTEGER PRIMARY KEY,
    fecha DATE,
    fecha_entrega DATE,
    id_canal INTEGER,
    id_cliente INTEGER,
    id_sucursal INTEGER,
    id_empleado INTEGER,
    id_producto INTEGER,
    precio DECIMAL(10,2),
    cantidad INTEGER,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_clientes_provincia ON clientes(provincia);
CREATE INDEX IF NOT EXISTS idx_clientes_localidad ON clientes(localidad);
CREATE INDEX IF NOT EXISTS idx_gastos_fecha ON gastos(fecha);
CREATE INDEX IF NOT EXISTS idx_gastos_sucursal ON gastos(id_sucursal);
CREATE INDEX IF NOT EXISTS idx_compras_fecha ON compras(fecha);
CREATE INDEX IF NOT EXISTS idx_compras_producto ON compras(id_producto);
CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas(fecha);
CREATE INDEX IF NOT EXISTS idx_ventas_cliente ON ventas(id_cliente);
CREATE INDEX IF NOT EXISTS idx_ventas_sucursal ON ventas(id_sucursal);
CREATE INDEX IF NOT EXISTS idx_ventas_empleado ON ventas(id_empleado);
CREATE INDEX IF NOT EXISTS idx_ventas_producto ON ventas(id_producto);
CREATE INDEX IF NOT EXISTS idx_productos_tipo ON productos(tipo);
CREATE INDEX IF NOT EXISTS idx_empleados_sucursal ON empleados(sucursal);
CREATE INDEX IF NOT EXISTS idx_empleados_sector ON empleados(sector);
