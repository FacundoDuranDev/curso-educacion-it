# 🎯 EJERCICIOS PRÁCTICOS

> **🎯 Aprende haciendo - Ejercicios hands-on para dominar cada tecnología**

## 🚀 **INICIO RÁPIDO**

### **⚡ Para empezar:**
1. **Conectar a PostgreSQL** → `../02-HOW-TO-GUIDES/postgresql/conexion-dbeaver.md`
2. **Elegir tu nivel** → Principiante, Intermedio o Avanzado
3. **Practicar con datos reales** → Todas las tablas del curso disponibles

### **🗄️ Datos Disponibles:**
```sql
-- Tablas para practicar:
clientes (1000+ registros), productos, ventas, empleados, 
sucursales, proveedores, gastos, tiposdegasto, canaldeventa, compras
```

---

## 📚 **SECCIONES DISPONIBLES**

### **🔍 [SQL QUERIES](sql-queries/)**
**¿Qué aprenderás?**
- ✅ SQL desde básico hasta avanzado
- ✅ Consultas complejas con JOINs
- ✅ Window functions y CTEs
- ✅ Optimización de queries

**📊 Contenido:**
- `tutorial-sql.md` - Tutorial completo paso a paso
- Ejercicios por nivel de dificultad
- Consultas de análisis de negocio
- Casos de uso reales

**⏱️ Tiempo estimado:** 4-6 horas  
**🎯 Resultado:** Dominio completo de SQL

---

### **🔍 [DATA QUALITY](data-quality/)**
**¿Qué aprenderás?**
- ✅ Evaluar calidad de datos
- ✅ Detectar inconsistencias
- ✅ Crear métricas automáticas
- ✅ Implementar validaciones

**📊 Contenido:**
- `ejercicios-calidad.md` - Ejercicios profesionales
- Análisis de completitud
- Detección de duplicados
- Sistemas de alertas automáticas

**⏱️ Tiempo estimado:** 3-4 horas  
**🎯 Resultado:** Skills de Data Quality Engineer

---

## 🎯 **RUTAS DE APRENDIZAJE**

### **👨‍💼 Para Analistas de Datos:**
```
1. sql-queries/tutorial-sql.md        → Dominar SQL
2. data-quality/ejercicios-calidad.md → Evaluar datos
3. ../03-CONCEPTS/sql-avanzado/       → Técnicas avanzadas
```
**⏱️ Tiempo total:** 6-8 horas

### **👨‍💻 Para Data Engineers:**
```
1. sql-queries/tutorial-sql.md        → Base SQL sólida
2. data-quality/ejercicios-calidad.md → Calidad de datos
3. ../03-CONCEPTS/database-design/    → Diseño de esquemas
4. ../03-CONCEPTS/sql-avanzado/       → Triggers y procedimientos
```
**⏱️ Tiempo total:** 8-12 horas

### **👨‍🔬 Para Data Scientists:**
```
1. sql-queries/tutorial-sql.md        → SQL para análisis
2. data-quality/ejercicios-calidad.md → Limpieza de datos
3. ../02-HOW-TO-GUIDES/postgresql/    → Integración con Python
```
**⏱️ Tiempo total:** 5-7 horas

---

## 📊 **NIVELES DE DIFICULTAD**

### **🟢 PRINCIPIANTE**
**Requisitos:** Conocimientos básicos de bases de datos
```sql
-- Empezar aquí:
SELECT * FROM clientes LIMIT 10;
SELECT nombre_completo, ciudad FROM clientes WHERE edad > 30;
```
**Ejercicios recomendados:**
- SQL Queries: Secciones 1-2
- Consultas básicas con WHERE, ORDER BY
- JOINs simples

### **🟡 INTERMEDIO** 
**Requisitos:** SQL básico, conceptos de normalización
```sql
-- Nivel intermedio:
SELECT c.nombre_completo, COUNT(v.id_venta) as total_compras
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre_completo;
```
**Ejercicios recomendados:**
- SQL Queries: Secciones 3-4
- Data Quality: Ejercicios 1-3
- Análisis de métricas

### **🔴 AVANZADO**
**Requisitos:** SQL intermedio, conceptos de optimización
```sql
-- Nivel avanzado:
WITH cliente_metricas AS (
    SELECT id_cliente, SUM(precio * cantidad) as total
    FROM ventas GROUP BY id_cliente
)
SELECT c.nombre_completo, cm.total,
       RANK() OVER (ORDER BY cm.total DESC) as ranking
FROM clientes c
JOIN cliente_metricas cm ON c.id_cliente = cm.id_cliente;
```
**Ejercicios recomendados:**
- SQL Queries: Secciones 4-5
- Data Quality: Ejercicios 4-5
- Triggers y procedimientos avanzados

---

## 🧪 **LABORATORIOS PRÁCTICOS**

### **🏆 Lab 1: Análisis de Ventas Completo**
**Objetivo:** Crear dashboard de ventas usando solo SQL
**Tiempo:** 2-3 horas
**Habilidades:** JOINs, GROUP BY, Window Functions

```sql
-- Ejemplo de lo que construirás:
SELECT 
    DATE_TRUNC('month', v.fecha_venta) as mes,
    s.nombre_sucursal,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.precio * v.cantidad) as ingresos,
    AVG(v.precio * v.cantidad) as ticket_promedio,
    RANK() OVER (
        PARTITION BY DATE_TRUNC('month', v.fecha_venta)
        ORDER BY SUM(v.precio * v.cantidad) DESC
    ) as ranking_sucursal
FROM ventas v
JOIN sucursales s ON v.id_sucursal = s.id_sucursal
GROUP BY DATE_TRUNC('month', v.fecha_venta), s.id_sucursal, s.nombre_sucursal
ORDER BY mes DESC, ranking_sucursal;
```

### **🏆 Lab 2: Sistema de Calidad de Datos**
**Objetivo:** Implementar monitoreo automático de calidad
**Tiempo:** 3-4 horas  
**Habilidades:** Triggers, Funciones, Validaciones

### **🏆 Lab 3: Segmentación de Clientes RFM**
**Objetivo:** Análisis RFM completo para marketing
**Tiempo:** 2-3 horas
**Habilidades:** CTEs, Window Functions, CASE statements

---

## 📈 **PROYECTOS FINALES**

### **🎯 Proyecto 1: Dashboard Ejecutivo**
**Descripción:** Crear reportes ejecutivos usando solo SQL
**Entregables:**
- Top 10 clientes por valor
- Análisis de productos más rentables
- Tendencias mensuales de ventas
- Métricas de retención de clientes

### **🎯 Proyecto 2: Sistema de Alertas**
**Descripción:** Implementar alertas automáticas de calidad
**Entregables:**
- Triggers de validación
- Funciones de métricas automáticas
- Dashboard de calidad en tiempo real
- Sistema de notificaciones

### **🎯 Proyecto 3: Análisis Predictivo**
**Descripción:** Preparar datos para machine learning
**Entregables:**
- Limpieza y normalización completa
- Feature engineering con SQL
- Detección de outliers
- Datasets listos para ML

---

## 📊 **MÉTRICAS DE PROGRESO**

### **🎯 Seguimiento de Aprendizaje:**
```sql
-- Crea tu tabla de progreso personal
CREATE TABLE mi_progreso (
    fecha DATE DEFAULT CURRENT_DATE,
    ejercicio VARCHAR(100),
    tiempo_invertido INTEGER, -- minutos
    dificultad VARCHAR(20),
    completado BOOLEAN DEFAULT false,
    notas TEXT
);

-- Registra tu progreso
INSERT INTO mi_progreso VALUES 
(CURRENT_DATE, 'SQL Tutorial - Nivel 1', 120, 'Principiante', true, 'Dominé SELECT y WHERE');
```

### **🏆 Badges de Logros:**
- 🥉 **SQL Básico:** Completar secciones 1-2 del tutorial
- 🥈 **SQL Intermedio:** Completar secciones 3-4 + 1 lab
- 🥇 **SQL Avanzado:** Completar todo + 2 labs + 1 proyecto
- 🔍 **Data Quality Expert:** Completar todos los ejercicios de calidad
- 🏛️ **Database Designer:** Dominar normalización + triggers

---

## 🔗 **RECURSOS DE APOYO**

### **📚 Documentación:**
- **Conexión DB:** `../02-HOW-TO-GUIDES/postgresql/`
- **Conceptos:** `../03-CONCEPTS/`
- **Referencia:** `../04-REFERENCE/`

### **🛠️ Herramientas:**
- **DBeaver:** Cliente visual recomendado
- **PostgreSQL:** Base de datos principal
- **Jupyter:** Para análisis con Python (opcional)

### **🎯 Tips de Estudio:**
- ✅ **Practica diariamente** - 30-60 minutos constantes
- ✅ **Usa datos reales** - Más motivador que ejemplos abstractos
- ✅ **Explica en voz alta** - Ayuda a consolidar conocimiento
- ✅ **Crea tus propios ejercicios** - Basados en casos reales
- ✅ **Documenta tu progreso** - Usa la tabla de seguimiento

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **No puedo conectar:** `../02-HOW-TO-GUIDES/troubleshooting/problemas-comunes.md`
- **Query muy lenta:** `../03-CONCEPTS/sql-avanzado/` (optimización)
- **Error de sintaxis:** `sql-queries/tutorial-sql.md` (referencia)

### **📞 Soporte:**
- **Instructor:** Consultas específicas en clase
- **Comunidad:** Foros de PostgreSQL y SQL
- **Documentación:** Links a recursos oficiales en cada sección

### **💡 Metodología de Estudio:**
1. **Leer teoría** (20% del tiempo)
2. **Practicar ejercicios** (60% del tiempo)  
3. **Crear proyectos propios** (20% del tiempo)

**🎯 ¡La práctica hace al maestro! Empieza con ejercicios básicos y avanza gradualmente hacia proyectos complejos.**
