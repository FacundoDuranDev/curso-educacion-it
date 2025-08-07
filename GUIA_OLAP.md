# Guía de Análisis OLAP

## ¿Qué es OLAP?

OLAP (Online Analytical Processing - Procesamiento Analítico En Línea) es un tipo de tecnología y metodología que permite analizar grandes cantidades de datos desde múltiples perspectivas. Es como tener un cubo Rubik de datos donde puedes girar y ver la información desde diferentes ángulos.

## Características Principales (FASMI)

1. **Fast (Rápido)**
   - Genera resultados en segundos
   - Permite análisis interactivo

2. **Analysis (Análisis)**
   - Soporta análisis complejos
   - Permite aplicar reglas de negocio

3. **Shared (Compartido)**
   - Múltiples usuarios pueden acceder
   - Control de acceso y seguridad

4. **Multidimensional (Multidimensional)**
   - Vista de datos en múltiples dimensiones
   - Ejemplo: Ventas por Tiempo, Región, Producto

5. **Information (Información)**
   - Acceso a todos los datos necesarios
   - Capacidad de manejar grandes volúmenes

## Ejemplo Práctico: Análisis de Ventas

Imagina una tienda retail con estas dimensiones de análisis:

```
Dimensiones:
- Tiempo (Año, Mes, Día)
- Producto (Categoría, Subcategoría, Producto)
- Ubicación (País, Ciudad, Tienda)
- Cliente (Tipo, Segmento)

Métricas:
- Ventas ($)
- Cantidad vendida
- Margen de ganancia
```

### Tipos de Análisis OLAP

1. **Drill Down (Profundizar)**
   ```sql
   -- De año a mes
   SELECT mes, SUM(ventas)
   FROM ventas
   WHERE año = 2023
   GROUP BY mes;
   ```

2. **Roll Up (Resumir)**
   ```sql
   -- De productos individuales a categorías
   SELECT categoria, SUM(ventas)
   FROM ventas
   GROUP BY categoria;
   ```

3. **Slice (Rebanar)**
   ```sql
   -- Solo ventas de una categoría específica
   SELECT mes, SUM(ventas)
   FROM ventas
   WHERE categoria = 'Electrónicos'
   GROUP BY mes;
   ```

4. **Dice (Cortar)**
   ```sql
   -- Ventas de electrónicos en Buenos Aires en 2023
   SELECT producto, SUM(ventas)
   FROM ventas
   WHERE categoria = 'Electrónicos'
   AND ciudad = 'Buenos Aires'
   AND año = 2023;
   ```

## Diferencias entre OLAP y OLTP

### OLAP (Analítico)
- **Propósito**: Análisis y toma de decisiones
- **Datos**: Históricos, agregados
- **Actualizaciones**: Poco frecuentes, en lotes
- **Consultas**: Complejas, multidimensionales
- **Ejemplo**: "Ventas totales por región en los últimos 3 años"

### OLTP (Transaccional)
- **Propósito**: Operaciones diarias
- **Datos**: Actuales, detallados
- **Actualizaciones**: Frecuentes, en tiempo real
- **Consultas**: Simples, predefinidas
- **Ejemplo**: "Registrar una nueva venta"

## Herramientas OLAP Comunes

1. **Apache Hive**
   - Data Warehouse sobre Hadoop
   - Excelente para grandes volúmenes
   - Usa HQL (similar a SQL)

2. **PostgreSQL con extensiones**
   - CUBE y ROLLUP
   - Funciones de ventana
   - Vistas materializadas

3. **Otras herramientas**
   - Apache Kylin
   - ClickHouse
   - Power BI
   - Tableau

## Ejemplo Real con Nuestros Datos

### En PostgreSQL
```sql
-- Análisis de ventas por categoría y mes
SELECT 
    EXTRACT(YEAR FROM v.fecha_venta) as año,
    EXTRACT(MONTH FROM v.fecha_venta) as mes,
    p.categoria,
    COUNT(*) as cantidad_ventas,
    SUM(v.monto_total) as total_ventas
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY 
    EXTRACT(YEAR FROM v.fecha_venta),
    EXTRACT(MONTH FROM v.fecha_venta),
    p.categoria
WITH ROLLUP;
```

### En Hive
```sql
-- El mismo análisis en Hive
SELECT 
    anio,
    mes,
    p.categoria,
    COUNT(*) as cantidad_ventas,
    SUM(v.monto_total) as total_ventas
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY 
    anio,
    mes,
    p.categoria
WITH ROLLUP;
```

## Buenas Prácticas OLAP

1. **Diseño del Esquema**
   - Usar modelo estrella o copo de nieve
   - Definir bien dimensiones y hechos
   - Planificar las agregaciones

2. **Optimización**
   - Crear índices apropiados
   - Usar particionamiento
   - Materializar vistas comunes

3. **Mantenimiento**
   - Actualizar estadísticas
   - Monitorear rendimiento
   - Limpiar datos históricos

## Conclusión

El análisis OLAP es fundamental para:
- Toma de decisiones basada en datos
- Análisis de tendencias
- Planificación estratégica
- Reportes gerenciales

Es especialmente útil cuando necesitas:
1. Analizar grandes volúmenes de datos históricos
2. Ver datos desde múltiples perspectivas
3. Encontrar patrones y tendencias
4. Generar reportes complejos