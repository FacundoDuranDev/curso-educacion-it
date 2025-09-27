# 📚 SQL QUERIES - EJERCICIOS PRÁCTICOS

> **🎯 Domina SQL desde básico hasta nivel profesional con ejercicios hands-on**

## 🚀 **INICIO RÁPIDO**

### **⚡ Para empezar ahora:**
1. **Conectar a PostgreSQL** → `../../02-HOW-TO-GUIDES/postgresql/conexion-dbeaver.md`
2. **Abrir tutorial principal** → `tutorial-sql.md`
3. **Empezar con nivel básico** → Sección 1 del tutorial

### **🗄️ Datos para Practicar:**
```sql
-- Todas las tablas del curso disponibles:
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- Resultado:
clientes, productos, ventas, empleados, sucursales, 
proveedores, gastos, tiposdegasto, canaldeventa, compras
```

---

## 📊 **CONTENIDO DISPONIBLE**

### **📖 [TUTORIAL SQL COMPLETO](tutorial-sql.md)**
**🎯 Tu guía principal para dominar SQL**

#### **📋 Lo Que Incluye:**
- ✅ **5 niveles progresivos** - Desde SELECT básico hasta CTEs complejas
- ✅ **Ejercicios prácticos** - Con datos reales del curso
- ✅ **Casos de uso reales** - Análisis de negocio con SQL
- ✅ **Mejores prácticas** - Tips de optimización y rendimiento

#### **🎯 Estructura del Tutorial:**
```
NIVEL 1: Comandos Básicos
├── SELECT, WHERE, ORDER BY
├── Filtros y condiciones
└── Ejercicios prácticos

NIVEL 2: Funciones Agregadas  
├── COUNT, SUM, AVG, MIN, MAX
├── GROUP BY y HAVING
└── Análisis estadístico

NIVEL 3: JOINs (Uniones)
├── INNER JOIN, LEFT JOIN
├── Múltiples tablas
└── Consultas complejas

NIVEL 4: Consultas Avanzadas
├── Subconsultas
├── Window Functions
└── CTEs (Common Table Expressions)

NIVEL 5: Modificación de Datos
├── INSERT, UPDATE, DELETE
├── Transacciones
└── Mejores prácticas
```

**⏱️ Tiempo estimado:** 4-6 horas  
**🎯 Resultado:** Dominio completo de SQL

---

## 🎯 **RUTAS DE APRENDIZAJE**

### **🟢 PRINCIPIANTE (0-2 horas SQL)**
```
📚 Empezar aquí:
1. tutorial-sql.md → Secciones 1-2
2. Practicar consultas básicas
3. Familiarizarse con las tablas del curso

🎯 Objetivo: Hacer consultas SELECT simples
⏱️ Tiempo: 2-3 horas
```

### **🟡 INTERMEDIO (2-20 horas SQL)**
```
📚 Continuar con:
1. tutorial-sql.md → Secciones 2-3
2. Dominar GROUP BY y JOINs
3. Crear análisis de negocio

🎯 Objetivo: Consultas multi-tabla con agregaciones
⏱️ Tiempo: 3-4 horas
```

### **🔴 AVANZADO (20+ horas SQL)**
```
📚 Perfeccionar con:
1. tutorial-sql.md → Secciones 4-5
2. Window Functions y CTEs
3. Optimización de consultas

🎯 Objetivo: Consultas de nivel profesional
⏱️ Tiempo: 2-3 horas
```

---

## 🧪 **EJERCICIOS POR CATEGORÍA**

### **📊 ANÁLISIS DE VENTAS**
```sql
-- Ejemplo de lo que aprenderás:
SELECT 
    DATE_TRUNC('month', v.fecha_venta) as mes,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.precio * v.cantidad) as ingresos,
    AVG(v.precio * v.cantidad) as ticket_promedio
FROM ventas v
WHERE v.fecha_venta >= '2024-01-01'
GROUP BY DATE_TRUNC('month', v.fecha_venta)
ORDER BY mes;
```

**🎯 Skills que desarrollas:**
- Funciones de fecha
- Agregaciones complejas
- Análisis temporal
- KPIs de negocio

### **👥 ANÁLISIS DE CLIENTES**
```sql
-- Segmentación RFM (Recency, Frequency, Monetary)
WITH cliente_metricas AS (
    SELECT 
        c.id_cliente,
        c.nombre_completo,
        MAX(v.fecha_venta) as ultima_compra,
        COUNT(v.id_venta) as frecuencia,
        SUM(v.precio * v.cantidad) as valor_total
    FROM clientes c
    LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
    GROUP BY c.id_cliente, c.nombre_completo
)
SELECT 
    nombre_completo,
    ultima_compra,
    frecuencia,
    valor_total,
    CASE 
        WHEN valor_total > 1000 THEN 'VIP'
        WHEN valor_total > 500 THEN 'Premium'
        ELSE 'Regular'
    END as categoria
FROM cliente_metricas
ORDER BY valor_total DESC;
```

**🎯 Skills que desarrollas:**
- CTEs (Common Table Expressions)
- CASE statements
- Segmentación de clientes
- Análisis de valor de cliente

### **📈 ANÁLISIS DE PRODUCTOS**
```sql
-- Top productos con análisis de rentabilidad
SELECT 
    p.nombre_producto,
    p.precio as precio_actual,
    COUNT(v.id_venta) as veces_vendido,
    SUM(v.cantidad) as unidades_vendidas,
    SUM(v.precio * v.cantidad) as ingresos_totales,
    AVG(v.precio) as precio_promedio_venta,
    RANK() OVER (ORDER BY SUM(v.precio * v.cantidad) DESC) as ranking_ingresos
FROM productos p
INNER JOIN ventas v ON p.id_producto = v.id_producto
GROUP BY p.id_producto, p.nombre_producto, p.precio
HAVING COUNT(v.id_venta) >= 5  -- Solo productos con al menos 5 ventas
ORDER BY ingresos_totales DESC
LIMIT 10;
```

**🎯 Skills que desarrollas:**
- Window Functions (RANK)
- HAVING clause
- Análisis de rentabilidad
- Métricas de producto

---

## 🏆 **DESAFÍOS ESPECIALES**

### **🥉 Desafío Bronce: Dashboard Básico**
**Objetivo:** Crear reporte de ventas mensual
**Tiempo:** 30-45 minutos
**Skills:** GROUP BY, funciones de fecha, agregaciones

```sql
-- Tu misión: Crear un reporte que muestre por mes:
-- - Total de ventas
-- - Ingresos totales  
-- - Ticket promedio
-- - Número de clientes únicos
```

### **🥈 Desafío Plata: Análisis de Tendencias**
**Objetivo:** Identificar tendencias de crecimiento
**Tiempo:** 60-90 minutos  
**Skills:** Window Functions, LAG/LEAD, cálculo de porcentajes

```sql
-- Tu misión: Mostrar crecimiento mes a mes:
-- - Ventas del mes actual vs anterior
-- - Porcentaje de crecimiento
-- - Tendencia (creciente/decreciente)
```

### **🥇 Desafío Oro: Segmentación Avanzada**
**Objetivo:** Implementar análisis RFM completo
**Tiempo:** 2-3 horas
**Skills:** CTEs complejas, NTILE, CASE avanzado

```sql
-- Tu misión: Crear segmentación RFM profesional:
-- - Calcular Recency, Frequency, Monetary
-- - Asignar scores del 1-5 para cada dimensión
-- - Crear segmentos de clientes automáticamente
```

---

## 📊 **CASOS DE USO REALES**

### **🏢 Para Analistas de Negocio:**
```sql
-- Análisis de performance de sucursales
SELECT 
    s.nombre_sucursal,
    COUNT(DISTINCT v.id_cliente) as clientes_unicos,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.precio * v.cantidad) as ingresos,
    AVG(v.precio * v.cantidad) as ticket_promedio,
    PERCENT_RANK() OVER (ORDER BY SUM(v.precio * v.cantidad)) as percentil_ingresos
FROM sucursales s
INNER JOIN ventas v ON s.id_sucursal = v.id_sucursal
WHERE v.fecha_venta >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY s.id_sucursal, s.nombre_sucursal
ORDER BY ingresos DESC;
```

### **💰 Para Directores Financieros:**
```sql
-- Análisis de márgenes y rentabilidad
WITH analisis_costos AS (
    SELECT 
        p.nombre_producto,
        p.precio as precio_venta,
        c.precio_unitario as costo_compra,
        p.precio - c.precio_unitario as margen_unitario,
        (p.precio - c.precio_unitario) / p.precio * 100 as margen_porcentaje
    FROM productos p
    LEFT JOIN compras c ON p.id_producto = c.id_producto
),
ventas_con_margen AS (
    SELECT 
        v.*,
        ac.margen_unitario,
        v.cantidad * ac.margen_unitario as margen_total
    FROM ventas v
    JOIN analisis_costos ac ON v.id_producto = ac.id_producto
    WHERE ac.margen_unitario IS NOT NULL
)
SELECT 
    DATE_TRUNC('month', fecha_venta) as mes,
    SUM(precio * cantidad) as ingresos,
    SUM(margen_total) as beneficio_bruto,
    SUM(margen_total) / SUM(precio * cantidad) * 100 as margen_porcentaje
FROM ventas_con_margen
GROUP BY DATE_TRUNC('month', fecha_venta)
ORDER BY mes;
```

### **👥 Para Gerentes de Marketing:**
```sql
-- Análisis de retención y churn de clientes
WITH actividad_mensual AS (
    SELECT 
        id_cliente,
        DATE_TRUNC('month', fecha_venta) as mes,
        SUM(precio * cantidad) as gasto_mes
    FROM ventas
    GROUP BY id_cliente, DATE_TRUNC('month', fecha_venta)
),
clientes_por_mes AS (
    SELECT 
        mes,
        COUNT(DISTINCT id_cliente) as clientes_activos,
        AVG(gasto_mes) as gasto_promedio
    FROM actividad_mensual
    GROUP BY mes
),
nuevos_clientes AS (
    SELECT 
        DATE_TRUNC('month', MIN(fecha_venta)) as mes_primera_compra,
        COUNT(DISTINCT id_cliente) as nuevos_clientes
    FROM ventas
    GROUP BY DATE_TRUNC('month', MIN(fecha_venta))
)
SELECT 
    cpm.mes,
    cpm.clientes_activos,
    nc.nuevos_clientes,
    cpm.clientes_activos - nc.nuevos_clientes as clientes_retenidos,
    cpm.gasto_promedio
FROM clientes_por_mes cpm
LEFT JOIN nuevos_clientes nc ON cpm.mes = nc.mes_primera_compra
ORDER BY cpm.mes;
```

---

## 💡 **TIPS DE OPTIMIZACIÓN**

### **⚡ Consultas Más Rápidas:**
```sql
-- ❌ Lento: Función en WHERE
SELECT * FROM ventas WHERE YEAR(fecha_venta) = 2024;

-- ✅ Rápido: Rango de fechas
SELECT * FROM ventas 
WHERE fecha_venta >= '2024-01-01' 
  AND fecha_venta < '2025-01-01';

-- ❌ Lento: SELECT * innecesario
SELECT * FROM clientes c
JOIN ventas v ON c.id_cliente = v.id_cliente;

-- ✅ Rápido: Solo columnas necesarias
SELECT c.nombre_completo, v.fecha_venta, v.precio
FROM clientes c
JOIN ventas v ON c.id_cliente = v.id_cliente;
```

### **📊 Análisis de Rendimiento:**
```sql
-- Ver plan de ejecución
EXPLAIN ANALYZE 
SELECT c.nombre_completo, COUNT(v.id_venta)
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre_completo;

-- Crear índices estratégicos
CREATE INDEX idx_ventas_cliente_fecha ON ventas(id_cliente, fecha_venta);
CREATE INDEX idx_ventas_producto_fecha ON ventas(id_producto, fecha_venta);
```

---

## 🔗 **RECURSOS COMPLEMENTARIOS**

### **📚 Guías Relacionadas:**
- **Conexión DB:** `../../02-HOW-TO-GUIDES/postgresql/conexion-dbeaver.md`
- **Calidad de datos:** `../data-quality/ejercicios-calidad.md`
- **Conceptos avanzados:** `../../03-CONCEPTS/sql-avanzado/`

### **🛠️ Herramientas Recomendadas:**
- **DBeaver:** Cliente visual con autocompletado
- **PostgreSQL:** Base de datos principal
- **pgAdmin:** Para administración avanzada

### **📖 Referencias Rápidas:**
```sql
-- Funciones de fecha útiles
CURRENT_DATE, CURRENT_TIMESTAMP
DATE_TRUNC('month', fecha)
EXTRACT(YEAR FROM fecha)
AGE(fecha1, fecha2)

-- Funciones de ventana comunes
ROW_NUMBER() OVER (ORDER BY columna)
RANK() OVER (ORDER BY columna)
LAG(columna) OVER (ORDER BY fecha)
SUM(columna) OVER (PARTITION BY grupo)

-- Operadores de texto
LIKE '%patron%'
ILIKE '%patron%' (case insensitive)
~ 'regex'
||  (concatenación)
```

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Errores Comunes:**
```sql
-- ❌ Error: Columna no en GROUP BY
SELECT ciudad, nombre_completo, COUNT(*)
FROM clientes GROUP BY ciudad;

-- ✅ Correcto: Todas las columnas en GROUP BY
SELECT ciudad, COUNT(*)
FROM clientes GROUP BY ciudad;

-- ❌ Error: WHERE con funciones agregadas
SELECT ciudad, COUNT(*) FROM clientes 
WHERE COUNT(*) > 10 GROUP BY ciudad;

-- ✅ Correcto: HAVING para filtrar grupos
SELECT ciudad, COUNT(*) FROM clientes 
GROUP BY ciudad HAVING COUNT(*) > 10;
```

### **📞 Soporte:**
- **Instructor:** Consultas específicas sobre sintaxis
- **Documentación:** PostgreSQL SQL reference
- **Comunidad:** Stack Overflow SQL tag

### **💡 Estrategia de Práctica:**
1. **Empezar simple** - SELECT básico
2. **Aumentar complejidad** gradualmente
3. **Usar datos reales** del curso
4. **Explicar en voz alta** lo que hace cada query
5. **Crear ejercicios propios** basados en tu experiencia

**🎯 ¡La práctica constante es la clave para dominar SQL! Dedica 30 minutos diarios y verás resultados rápidos.**
