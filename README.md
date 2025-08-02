# 🚀 Data Engineering Course - EducaciónIT

Repositorio completo para el curso de **Ingeniería de Datos** con PostgreSQL, Docker y Big Data.

## 📋 Descripción

Este proyecto contiene todo el material necesario para el curso de Data Engineering, incluyendo:
- Base de datos PostgreSQL con datos reales
- Scripts de configuración y carga de datos
- Ejercicios prácticos de SQL
- Configuración de Docker para Big Data
- Datasets de ejemplo para análisis

## 🏗️ Arquitectura del Proyecto

```
educacionit/
├── docker-compose.yaml          # Configuración de servicios Docker
├── Etapa 1/                     # Datasets CSV originales
│   ├── Clientes.csv
│   ├── Sucursales.csv
│   ├── Gastos.csv
│   ├── Compras.csv
│   ├── Productos.csv
│   ├── Proveedores.csv
│   ├── Empleados.csv
│   ├── CanalDeVenta.csv
│   └── Venta.csv
├── scripts/                      # Scripts de configuración
│   ├── create_tables.sql        # Creación de tablas
│   ├── load_data.sql            # Carga de datos
│   └── ejercicios_clase.sql     # Ejercicios prácticos
└── README.md                    # Este archivo
```

## 🛠️ Tecnologías Utilizadas

- **PostgreSQL 15** - Base de datos relacional
- **Docker & Docker Compose** - Containerización
- **Hadoop** - Procesamiento distribuido
- **Apache Spark** - Procesamiento de datos
- **Apache Hive** - Data warehouse
- **SQL** - Consultas y análisis de datos

## 📊 Datasets Incluidos

| Tabla | Registros | Descripción |
|-------|-----------|-------------|
| Clientes | 3,407 | Información de clientes |
| Sucursales | 31 | Ubicaciones de sucursales |
| Gastos | 8,640 | Gastos por sucursal |
| Compras | 11,539 | Compras a proveedores |
| Productos | 291 | Catálogo de productos |
| Proveedores | 14 | Información de proveedores |
| Empleados | 249 | Datos de empleados |
| Canal de Venta | 3 | Canales de venta |
| Ventas | 46,645 | Transacciones de venta |

**Total: 70,823 registros**

## 🚀 Instalación y Configuración

### Prerrequisitos
- Docker y Docker Compose instalados
- Git

### Pasos de Instalación

1. **Clonar el repositorio:**
```bash
git clone <URL_DEL_REPO>
cd educacionit
```

2. **Levantar los servicios Docker:**
```bash
docker-compose up -d postgres
```

3. **Crear y cargar la base de datos:**
```bash
chmod +x scripts/setup_database.sh
./scripts/setup_database.sh
```

4. **Conectar a PostgreSQL:**
```bash
psql -h localhost -p 5432 -U admin -d educacionit
```

## 📚 Ejercicios y Prácticas

### Ejercicios Incluidos
- Exploración de datos
- Análisis de calidad de datos
- Consultas SQL complejas
- Normalización de datos
- Análisis de relaciones entre tablas
- ETL y transformaciones

### Ejecutar Ejercicios
```bash
psql -h localhost -p 5432 -U admin -d educacionit -f scripts/ejercicios_clase.sql
```

## 🐳 Servicios Docker Disponibles

- **PostgreSQL** (puerto 5432) - Base de datos principal
- **Hadoop Namenode** (puerto 9870) - Sistema de archivos distribuido
- **Hadoop Datanode** - Almacenamiento de datos
- **Spark Master** (puerto 8080) - Procesamiento de datos
- **Spark Worker** (puerto 8081) - Nodos de procesamiento
- **Hive Server** - Data warehouse

## 📖 Estructura del Curso

### Módulo 1: Fundamentos de Data Engineering
- Concepto de ingeniería de datos
- Data Governance
- Ciclo de vida del dato
- Preparación e integración de datos

### Módulo 2: Modelado de Datos
- Modelo ERD
- Formas normales (1FN-5FN)
- ETL: extracción, transformación y carga
- Optimización de consultas SQL

### Módulo 3: Big Data
- Casos de uso
- Data lake
- Arquitectura Hadoop
- Ecosistema Hadoop

### Módulo 4: Procesamiento de Datos
- Apache Spark
- Apache Hive
- Formatos de almacenamiento
- Streaming de datos

## 🤝 Contribuciones

Este repositorio está diseñado para el curso de Data Engineering. Las contribuciones son bienvenidas para mejorar el material educativo.

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Contacto

Para preguntas sobre el curso o el material, contactar al instructor.

---

**Desarrollado para EducaciónIT** 🎓 