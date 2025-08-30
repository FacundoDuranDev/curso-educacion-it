-- Script para crear triggers en PostgreSQL
-- Base de datos: educacionit

-- 1.1 Crear Tabla de Auditoría General
CREATE TABLE IF NOT EXISTS auditoria_general (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(100),
    operacion VARCHAR(10),
    id_registro INTEGER,
    fecha_operacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50) DEFAULT CURRENT_USER,
    datos_anteriores JSONB,
    datos_nuevos JSONB,
    ip_cliente INET DEFAULT inet_client_addr()
);

CREATE INDEX IF NOT EXISTS idx_auditoria_tabla_fecha ON auditoria_general(tabla, fecha_operacion);
CREATE INDEX IF NOT EXISTS idx_auditoria_operacion ON auditoria_general(operacion);

-- 1.2 Crear Tabla de Métricas de Clientes
CREATE TABLE IF NOT EXISTS metricas_clientes (
    id_cliente INTEGER PRIMARY KEY,
    total_ventas DECIMAL(15,2) DEFAULT 0,
    cantidad_ventas INTEGER DEFAULT 0,
    ticket_promedio DECIMAL(10,2) DEFAULT 0,
    ultima_compra DATE,
    primera_compra DATE,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_metricas_total_ventas ON metricas_clientes(total_ventas);
CREATE INDEX IF NOT EXISTS idx_metricas_fecha_actualizacion ON metricas_clientes(fecha_actualizacion);

-- 1.3 Crear Tabla de Logs de Validación
CREATE TABLE IF NOT EXISTS logs_validacion (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(100),
    id_registro INTEGER,
    campo VARCHAR(100),
    valor_anterior TEXT,
    valor_nuevo TEXT,
    tipo_validacion VARCHAR(50),
    mensaje TEXT,
    fecha_validacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50) DEFAULT CURRENT_USER,
    severidad VARCHAR(20) DEFAULT 'INFO'
);

CREATE INDEX IF NOT EXISTS idx_logs_validacion_tabla ON logs_validacion(tabla);
CREATE INDEX IF NOT EXISTS idx_logs_validacion_fecha ON logs_validacion(fecha_validacion);
CREATE INDEX IF NOT EXISTS idx_logs_validacion_severidad ON logs_validacion(severidad);

-- 1.4 Crear Tabla de Datos Problemáticos
CREATE TABLE IF NOT EXISTS datos_problematicos (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(100),
    id_registro INTEGER,
    campo VARCHAR(100),
    valor_problematico TEXT,
    tipo_problema VARCHAR(100),
    descripcion TEXT,
    fecha_deteccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resuelto BOOLEAN DEFAULT FALSE,
    fecha_resolucion TIMESTAMP,
    usuario_resolucion VARCHAR(50)
);

CREATE INDEX IF NOT EXISTS idx_datos_problematicos_tabla ON datos_problematicos(tabla);
CREATE INDEX IF NOT EXISTS idx_datos_problematicos_resuelto ON datos_problematicos(resuelto);

-- 2.1 Función de Auditoría General
CREATE OR REPLACE FUNCTION auditar_cambios()
RETURNS TRIGGER AS $$
DECLARE
    datos_anteriores JSONB;
    datos_nuevos JSONB;
    id_registro INTEGER;
BEGIN
    IF TG_OP = 'DELETE' THEN
        IF TG_TABLE_NAME = 'clientes' THEN
            id_registro = OLD.id;
        ELSIF TG_TABLE_NAME = 'productos' THEN
            id_registro = OLD.id_producto;
        ELSIF TG_TABLE_NAME = 'empleados' THEN
            id_registro = OLD.id_empleado;
        ELSIF TG_TABLE_NAME = 'ventas' THEN
            id_registro = OLD.id_venta;
        ELSIF TG_TABLE_NAME = 'compras' THEN
            id_registro = OLD.id_compra;
        ELSIF TG_TABLE_NAME = 'gastos' THEN
            id_registro = OLD.id_gasto;
        ELSIF TG_TABLE_NAME = 'sucursales' THEN
            id_registro = OLD.id;
        ELSIF TG_TABLE_NAME = 'proveedores' THEN
            id_registro = OLD.id_proveedor;
        ELSIF TG_TABLE_NAME = 'tipos_gasto' THEN
            id_registro = OLD.id_tipo_gasto;
        ELSIF TG_TABLE_NAME = 'canal_venta' THEN
            id_registro = OLD.codigo;
        ELSE
            id_registro = OLD.id;
        END IF;
        datos_anteriores = to_jsonb(OLD);
    ELSE
        IF TG_TABLE_NAME = 'clientes' THEN
            id_registro = NEW.id;
        ELSIF TG_TABLE_NAME = 'productos' THEN
            id_registro = NEW.id_producto;
        ELSIF TG_TABLE_NAME = 'empleados' THEN
            id_registro = NEW.id_empleado;
        ELSIF TG_TABLE_NAME = 'ventas' THEN
            id_registro = NEW.id_venta;
        ELSIF TG_TABLE_NAME = 'compras' THEN
            id_registro = NEW.id_compra;
        ELSIF TG_TABLE_NAME = 'gastos' THEN
            id_registro = NEW.id_gasto;
        ELSIF TG_TABLE_NAME = 'sucursales' THEN
            id_registro = NEW.id;
        ELSIF TG_TABLE_NAME = 'proveedores' THEN
            id_registro = NEW.id_proveedor;
        ELSIF TG_TABLE_NAME = 'tipos_gasto' THEN
            id_registro = NEW.id_tipo_gasto;
        ELSIF TG_TABLE_NAME = 'canal_venta' THEN
            id_registro = NEW.codigo;
        ELSE
            id_registro = NEW.id;
        END IF;
        datos_nuevos = to_jsonb(NEW);
    END IF;
    
    IF TG_OP = 'UPDATE' THEN
        datos_anteriores = to_jsonb(OLD);
    END IF;
    
    INSERT INTO auditoria_general (tabla, operacion, id_registro, datos_anteriores, datos_nuevos)
    VALUES (TG_TABLE_NAME, TG_OP, id_registro, datos_anteriores, datos_nuevos);
    
    IF TG_OP = 'DELETE' THEN 
        RETURN OLD; 
    ELSE 
        RETURN NEW; 
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 2.2 Función de Validación y Normalización de Clientes
CREATE OR REPLACE FUNCTION validar_y_normalizar_cliente()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.edad IS NOT NULL AND (NEW.edad < 0 OR NEW.edad > 120) THEN
        INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
        VALUES ('clientes', NEW.id, 'edad', NULL, NEW.edad::TEXT, 'ADVERTENCIA', 'Edad fuera de rango (0-120)', 'ADVERTENCIA');
        
        INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
        VALUES ('clientes', NEW.id, 'edad', NEW.edad::TEXT, 'EDAD_INVALIDA', 'Edad fuera del rango válido (0-120 años)');
    END IF;
    
    IF NEW.telefono IS NOT NULL AND NEW.telefono != '' AND LENGTH(TRIM(NEW.telefono)) < 7 THEN
        INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
        VALUES ('clientes', NEW.id, 'telefono', NULL, NEW.telefono, 'ADVERTENCIA', 'Teléfono muy corto (mínimo 7 caracteres)', 'ADVERTENCIA');
        
        INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
        VALUES ('clientes', NEW.id, 'telefono', NEW.telefono, 'TELEFONO_CORTO', 'Teléfono con menos de 7 caracteres');
    END IF;
    
    IF NEW.nombre_y_apellido IS NOT NULL AND NEW.nombre_y_apellido != '' THEN
        NEW.nombre_y_apellido = INITCAP(LOWER(TRIM(NEW.nombre_y_apellido)));
    END IF;
    
    IF NEW.provincia IS NOT NULL AND NEW.provincia != '' THEN
        NEW.provincia = INITCAP(LOWER(TRIM(NEW.provincia)));
    END IF;
    
    IF NEW.localidad IS NOT NULL AND NEW.localidad != '' THEN
        NEW.localidad = INITCAP(LOWER(TRIM(NEW.localidad)));
    END IF;
    
    IF NEW.fecha_alta IS NULL THEN
        NEW.fecha_alta = CURRENT_DATE;
    END IF;
    
    IF NEW.usuario_alta IS NULL THEN
        NEW.usuario_alta = CURRENT_USER;
    END IF;
    
    NEW.fecha_ultima_modificacion = CURRENT_TIMESTAMP;
    NEW.usuario_ultima_modificacion = CURRENT_USER;
    
    IF NEW.x IS NOT NULL AND NEW.x != '' THEN
        IF NEW.x !~ '^-?[0-9]+[.,][0-9]+$' THEN
            INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
            VALUES ('clientes', NEW.id, 'x', NULL, NEW.x, 'ADVERTENCIA', 'Coordenada X con formato no estándar', 'ADVERTENCIA');
            
            INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
            VALUES ('clientes', NEW.id, 'x', NEW.x, 'COORDENADA_X_INVALIDA', 'Formato de coordenada X no estándar');
        END IF;
    END IF;
    
    IF NEW.y IS NOT NULL AND NEW.y != '' THEN
        IF NEW.y !~ '^-?[0-9]+[.,][0-9]+$' THEN
            INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
            VALUES ('clientes', NEW.id, 'y', NULL, NEW.y, 'ADVERTENCIA', 'Coordenada Y con formato no estándar', 'ADVERTENCIA');
            
            INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
            VALUES ('clientes', NEW.id, 'y', NEW.y, 'COORDENADA_Y_INVALIDA', 'Formato de coordenada Y no estándar');
        END IF;
    END IF;
    
    INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
            VALUES ('clientes', NEW.id, 'VALIDACION_COMPLETA', NULL, 'OK', 'INFO', 'Cliente validado y normalizado correctamente', 'INFO');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.3 Función de Cálculo de Métricas de Clientes
CREATE OR REPLACE FUNCTION calcular_metricas_cliente()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO metricas_clientes (id_cliente, total_ventas, cantidad_ventas, ticket_promedio, ultima_compra, primera_compra, fecha_actualizacion)
    VALUES (
        COALESCE(NEW.id_cliente, OLD.id_cliente),
        (SELECT COALESCE(SUM(precio * cantidad), 0) FROM ventas WHERE id_cliente = COALESCE(NEW.id_cliente, OLD.id_cliente)),
        (SELECT COUNT(*) FROM ventas WHERE id_cliente = COALESCE(NEW.id_cliente, OLD.id_cliente)),
        (SELECT CASE WHEN COUNT(*) > 0 THEN AVG(precio * cantidad) ELSE 0 END FROM ventas WHERE id_cliente = COALESCE(NEW.id_cliente, OLD.id_cliente)),
        (SELECT MAX(fecha) FROM ventas WHERE id_cliente = COALESCE(NEW.id_cliente, OLD.id_cliente)),
        (SELECT MIN(fecha) FROM ventas WHERE id_cliente = COALESCE(NEW.id_cliente, OLD.id_cliente)),
        CURRENT_TIMESTAMP
    ) ON CONFLICT (id_cliente) DO UPDATE SET
        total_ventas = EXCLUDED.total_ventas,
        cantidad_ventas = EXCLUDED.cantidad_ventas,
        ticket_promedio = EXCLUDED.ticket_promedio,
        ultima_compra = EXCLUDED.ultima_compra,
        primera_compra = EXCLUDED.primera_compra,
        fecha_actualizacion = CURRENT_TIMESTAMP;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- 2.4 Función de Validación de Ventas
CREATE OR REPLACE FUNCTION validar_venta()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha_entrega IS NOT NULL AND NEW.fecha_entrega < NEW.fecha THEN
        RAISE EXCEPTION 'La fecha de entrega no puede ser anterior a la fecha de venta';
    END IF;
    
    IF NEW.cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad debe ser mayor a 0';
    END IF;
    
    IF NEW.precio <= 0 THEN
        RAISE EXCEPTION 'El precio debe ser mayor a 0';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM clientes WHERE id = NEW.id_cliente) THEN
        INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
        VALUES ('ventas', NEW.id_venta, 'id_cliente', NULL, NEW.id_cliente::TEXT, 'ADVERTENCIA', 'Cliente inexistente referenciado', 'ADVERTENCIA');
        
        INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
        VALUES ('ventas', NEW.id_venta, 'id_cliente', NEW.id_cliente::TEXT, 'CLIENTE_INEXISTENTE', 'Referencia a cliente que no existe en la base de datos');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = NEW.id_producto) THEN
        INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
        VALUES ('ventas', NEW.id_venta, 'id_producto', NULL, NEW.id_producto::TEXT, 'ADVERTENCIA', 'Producto inexistente referenciado', 'ADVERTENCIA');
        
        INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
        VALUES ('ventas', NEW.id_venta, 'id_producto', NEW.id_producto::TEXT, 'PRODUCTO_INEXISTENTE', 'Referencia a producto que no existe en la base de datos');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM sucursales WHERE id = NEW.id_sucursal) THEN
        INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
        VALUES ('ventas', NEW.id_venta, 'id_sucursal', NULL, NEW.id_sucursal::TEXT, 'ADVERTENCIA', 'Sucursal inexistente referenciada', 'ADVERTENCIA');
        
        INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
        VALUES ('ventas', NEW.id_venta, 'id_sucursal', NEW.id_sucursal::TEXT, 'SUCURSAL_INEXISTENTE', 'Referencia a sucursal que no existe en la base de datos');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM empleados WHERE id_empleado = NEW.id_empleado) THEN
        INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
        VALUES ('ventas', NEW.id_venta, 'id_empleado', NULL, NEW.id_empleado::TEXT, 'ADVERTENCIA', 'Empleado inexistente referenciado', 'ADVERTENCIA');
        
        INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
        VALUES ('ventas', NEW.id_venta, 'id_empleado', NEW.id_empleado::TEXT, 'EMPLEADO_INEXISTENTE', 'Referencia a empleado que no existe en la base de datos');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM canal_venta WHERE codigo = NEW.id_canal) THEN
        INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
        VALUES ('ventas', NEW.id_venta, 'id_canal', NULL, NEW.id_canal::TEXT, 'ADVERTENCIA', 'Canal de venta inexistente referenciado', 'ADVERTENCIA');
        
        INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
        VALUES ('ventas', NEW.id_venta, 'id_canal', NEW.id_canal::TEXT, 'CANAL_INEXISTENTE', 'Referencia a canal de venta que no existe en la base de datos');
    END IF;
    
    IF NEW.fecha IS NULL THEN
        NEW.fecha = CURRENT_DATE;
    END IF;
    
    INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
            VALUES ('ventas', NEW.id_venta, 'VALIDACION_COMPLETA', NULL, 'OK', 'INFO', 'Venta validada correctamente', 'INFO');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.5 Función de Validación de Gastos
CREATE OR REPLACE FUNCTION validar_gasto()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.monto <= 0 THEN
        RAISE EXCEPTION 'El monto del gasto debe ser mayor a 0';
    END IF;
    
    IF NEW.fecha > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha del gasto no puede ser en el futuro';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM sucursales WHERE id = NEW.id_sucursal) THEN
        INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
        VALUES ('gastos', NEW.id_gasto, 'id_sucursal', NULL, NEW.id_sucursal::TEXT, 'ADVERTENCIA', 'Sucursal inexistente referenciada', 'ADVERTENCIA');
        
        INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
        VALUES ('gastos', NEW.id_gasto, 'id_sucursal', NEW.id_sucursal::TEXT, 'SUCURSAL_INEXISTENTE', 'Referencia a sucursal que no existe en la base de datos');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM tipos_gasto WHERE id_tipo_gasto = NEW.id_tipo_gasto) THEN
        INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
        VALUES ('gastos', NEW.id_gasto, 'id_tipo_gasto', NULL, NEW.id_tipo_gasto::TEXT, 'ADVERTENCIA', 'Tipo de gasto inexistente referenciado', 'ADVERTENCIA');
        
        INSERT INTO datos_problematicos (tabla, id_registro, campo, valor_problematico, tipo_problema, descripcion)
        VALUES ('gastos', NEW.id_gasto, 'id_tipo_gasto', NEW.id_tipo_gasto::TEXT, 'TIPO_GASTO_INEXISTENTE', 'Referencia a tipo de gasto que no existe en la base de datos');
    END IF;
    
    IF NEW.fecha IS NULL THEN
        NEW.fecha = CURRENT_DATE;
    END IF;
    
    INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
    VALUES ('gastos', NEW.id_gasto, 'VALIDACION_COMPLETA', NULL, 'OK', 'INFO', 'Gasto validado correctamente', 'INFO');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.6 Función de Validación de Productos
CREATE OR REPLACE FUNCTION validar_producto()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.concepto IS NULL OR TRIM(NEW.concepto) = '' THEN
        RAISE EXCEPTION 'El concepto del producto no puede estar vacío';
    END IF;
    
    IF NEW.precio < 0 THEN
        RAISE EXCEPTION 'El precio del producto no puede ser negativo';
    END IF;
    
    IF NEW.concepto IS NOT NULL THEN
        NEW.concepto = INITCAP(LOWER(TRIM(NEW.concepto)));
    END IF;
    
    IF NEW.tipo IS NOT NULL AND NEW.tipo != '' THEN
        NEW.tipo = INITCAP(LOWER(TRIM(NEW.tipo)));
    END IF;
    
    INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
    VALUES ('productos', NEW.id_producto, 'VALIDACION_COMPLETA', NULL, 'OK', 'INFO', 'Producto validado y normalizado correctamente', 'INFO');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.7 Función de Validación de Empleados
CREATE OR REPLACE FUNCTION validar_empleado()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.apellido IS NULL OR TRIM(NEW.apellido) = '' THEN
        RAISE EXCEPTION 'El apellido del empleado no puede estar vacío';
    END IF;
    
    IF NEW.nombre IS NULL OR TRIM(NEW.nombre) = '' THEN
        RAISE EXCEPTION 'El nombre del empleado no puede estar vacío';
    END IF;
    
    IF NEW.salario <= 0 THEN
        RAISE EXCEPTION 'El salario del empleado debe ser mayor a 0';
    END IF;
    
    IF NEW.apellido IS NOT NULL THEN
        NEW.apellido = INITCAP(LOWER(TRIM(NEW.apellido)));
    END IF;
    
    IF NEW.nombre IS NOT NULL THEN
        NEW.nombre = INITCAP(LOWER(TRIM(NEW.nombre)));
    END IF;
    
    IF NEW.sector IS NOT NULL AND NEW.sector != '' THEN
        NEW.sector = INITCAP(LOWER(TRIM(NEW.sector)));
    END IF;
    
    IF NEW.cargo IS NOT NULL AND NEW.cargo != '' THEN
        NEW.cargo = INITCAP(LOWER(TRIM(NEW.cargo)));
    END IF;
    
    INSERT INTO logs_validacion (tabla, id_registro, campo, valor_anterior, valor_nuevo, tipo_validacion, mensaje, severidad)
    VALUES ('empleados', NEW.id_empleado, 'VALIDACION_COMPLETA', NULL, 'OK', 'INFO', 'Empleado validado y normalizado correctamente', 'INFO');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. CREAR TRIGGERS
CREATE TRIGGER trigger_auditoria_clientes
    AFTER INSERT OR DELETE OR UPDATE ON clientes
    FOR EACH ROW EXECUTE PROCEDURE auditar_cambios();

CREATE TRIGGER trigger_validar_cliente
    BEFORE INSERT OR UPDATE ON clientes
    FOR EACH ROW EXECUTE PROCEDURE validar_y_normalizar_cliente();

CREATE TRIGGER trigger_metricas_ventas
    AFTER INSERT OR DELETE OR UPDATE ON ventas
    FOR EACH ROW EXECUTE PROCEDURE calcular_metricas_cliente();

CREATE TRIGGER trigger_validar_venta
    BEFORE INSERT OR UPDATE ON ventas
    FOR EACH ROW EXECUTE PROCEDURE validar_venta();

CREATE TRIGGER trigger_validar_gasto
    BEFORE INSERT OR UPDATE ON gastos
    FOR EACH ROW EXECUTE PROCEDURE validar_gasto();

CREATE TRIGGER trigger_auditoria_productos
    AFTER INSERT OR DELETE OR UPDATE ON productos
    FOR EACH ROW EXECUTE PROCEDURE auditar_cambios();

CREATE TRIGGER trigger_validar_producto
    BEFORE INSERT OR UPDATE ON productos
    FOR EACH ROW EXECUTE PROCEDURE validar_producto();

CREATE TRIGGER trigger_auditoria_empleados
    AFTER INSERT OR DELETE OR UPDATE ON empleados
    FOR EACH ROW EXECUTE PROCEDURE auditar_cambios();

CREATE TRIGGER trigger_validar_empleado
    BEFORE INSERT OR UPDATE ON empleados
    FOR EACH ROW EXECUTE PROCEDURE validar_empleado();

CREATE TRIGGER trigger_auditoria_ventas
    AFTER INSERT OR DELETE OR UPDATE ON ventas
    FOR EACH ROW EXECUTE PROCEDURE auditar_cambios();

CREATE TRIGGER trigger_auditoria_gastos
    AFTER INSERT OR DELETE OR UPDATE ON gastos
    FOR EACH ROW EXECUTE PROCEDURE auditar_cambios();

CREATE TRIGGER trigger_auditoria_sucursales
    AFTER INSERT OR DELETE OR UPDATE ON sucursales
    FOR EACH ROW EXECUTE PROCEDURE auditar_cambios();

CREATE TRIGGER trigger_auditoria_proveedores
    AFTER INSERT OR DELETE OR UPDATE ON proveedores
    FOR EACH ROW EXECUTE PROCEDURE auditar_cambios();

CREATE TRIGGER trigger_auditoria_tipos_gasto
    AFTER INSERT OR DELETE OR UPDATE ON tipos_gasto
    FOR EACH ROW EXECUTE PROCEDURE auditar_cambios();

CREATE TRIGGER trigger_auditoria_canales_venta
    AFTER INSERT OR DELETE OR UPDATE ON canal_venta
    FOR EACH ROW EXECUTE PROCEDURE auditar_cambios();

-- 4. FUNCIONES UTILITARIAS
CREATE OR REPLACE FUNCTION limpiar_auditoria_antigua(dias INTEGER DEFAULT 90)
RETURNS INTEGER AS $$
DECLARE
    registros_eliminados INTEGER;
BEGIN
    DELETE FROM auditoria_general 
    WHERE fecha_operacion < CURRENT_DATE - INTERVAL '1 day' * dias;
    
    GET DIAGNOSTICS registros_eliminados = ROW_COUNT;
    RETURN registros_eliminados;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION estadisticas_auditoria()
RETURNS TABLE (
    tabla VARCHAR(100),
    operacion VARCHAR(10),
    total_operaciones BIGINT,
    ultima_operacion TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ag.tabla,
        ag.operacion,
        COUNT(*) as total_operaciones,
        MAX(ag.fecha_operacion) as ultima_operacion
    FROM auditoria_general ag
    GROUP BY ag.tabla, ag.operacion
    ORDER BY ag.tabla, ag.operacion;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION reporte_validaciones()
RETURNS TABLE (
    tabla VARCHAR(100),
    total_advertencias BIGINT,
    total_errores BIGINT,
    total_info BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        lv.tabla,
        COUNT(CASE WHEN lv.severidad = 'ADVERTENCIA' THEN 1 END) as total_advertencias,
        COUNT(CASE WHEN lv.severidad = 'ERROR' THEN 1 END) as total_errores,
        COUNT(CASE WHEN lv.severidad = 'INFO' THEN 1 END) as total_info
    FROM logs_validacion lv
    GROUP BY lv.tabla
    ORDER BY lv.tabla;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION reporte_datos_problematicos()
RETURNS TABLE (
    tabla VARCHAR(100),
    total_problemas BIGINT,
    problemas_resueltos BIGINT,
    problemas_pendientes BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        dp.tabla,
        COUNT(*) as total_problemas,
        COUNT(CASE WHEN dp.resuelto THEN 1 END) as problemas_resueltos,
        COUNT(CASE WHEN NOT dp.resuelto THEN 1 END) as problemas_pendientes
    FROM datos_problematicos dp
    GROUP BY dp.tabla
    ORDER BY dp.tabla;
END;
$$ LANGUAGE plpgsql;
