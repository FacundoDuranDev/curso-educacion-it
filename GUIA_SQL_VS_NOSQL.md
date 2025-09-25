# 📚 GUÍA COMPLETA: SQL vs NoSQL

## 🔍 1. DIFERENCIAS ENTRE SQL Y NoSQL

### 📊 **BASES DE DATOS SQL (RELACIONALES)**

#### **Características Principales:**
- **Estructura**: Tablas con filas y columnas
- **Esquema**: Fijo y predefinido (Schema-on-Write)
- **Lenguaje**: SQL estándar
- **ACID**: Cumple propiedades ACID completas
- **Escalabilidad**: Vertical (más potencia al servidor)
- **Consistencia**: Fuerte por defecto

#### **Ventajas:**
- ✅ **Consistencia garantizada**: Transacciones ACID
- ✅ **Lenguaje estándar**: SQL conocido por muchos desarrolladores
- ✅ **Integridad referencial**: Relaciones entre tablas
- ✅ **Consultas complejas**: JOINs, subconsultas, agregaciones
- ✅ **Madurez**: Décadas de desarrollo y optimización

#### **Desventajas:**
- ❌ **Escalabilidad limitada**: Difícil escalar horizontalmente
- ❌ **Esquema rígido**: Cambios de estructura complejos
- ❌ **Rendimiento**: Puede degradarse con grandes volúmenes
- ❌ **Costo**: Licencias costosas (Oracle, SQL Server)

#### **Ejemplos:**
- PostgreSQL, MySQL, Oracle, SQL Server, SQLite

---

### 🚀 **BASES DE DATOS NoSQL (NO RELACIONALES)**

#### **Características Principales:**
- **Estructura**: Flexible (documentos, grafos, columnas, clave-valor)
- **Esquema**: Dinámico (Schema-on-Read)
- **Lenguaje**: APIs específicas, algunos soportan SQL-like
- **BASE**: Eventually Consistent (BASE vs ACID)
- **Escalabilidad**: Horizontal (agregar más servidores)
- **Consistencia**: Eventual por defecto

#### **Ventajas:**
- ✅ **Escalabilidad horizontal**: Fácil agregar nodos
- ✅ **Flexibilidad**: Esquema dinámico
- ✅ **Rendimiento**: Optimizado para operaciones específicas
- ✅ **Big Data**: Manejo eficiente de grandes volúmenes
- ✅ **Disponibilidad**: Alta disponibilidad distribuida

#### **Desventajas:**
- ❌ **Consistencia eventual**: No siempre inmediata
- ❌ **Falta de estándares**: Cada BD tiene su API
- ❌ **Consultas limitadas**: Sin JOINs complejos nativos
- ❌ **Curva de aprendizaje**: Paradigmas diferentes

#### **Ejemplos:**
- MongoDB, Cassandra, HBase, Redis, Neo4j

---

## 📂 2. CATEGORÍAS DE BASES DE DATOS NoSQL

### 🗂️ **1. BASES DE DATOS CLAVE-VALOR (Key-Value)**

#### **Características:**
- **Modelo**: Pares clave-valor simples
- **Estructura**: `{clave: valor}`
- **Consultas**: Solo por clave primaria
- **Casos de uso**: Cache, sesiones, configuraciones

#### **Ejemplos:**
- **Redis**: Cache en memoria, pub/sub
- **Amazon DynamoDB**: Servicio gestionado de AWS
- **Riak**: Distribuido, alta disponibilidad

#### **Ventajas:**
- ⚡ **Muy rápido**: Acceso directo por clave
- 🔄 **Simple**: Modelo de datos básico
- 📈 **Escalable**: Distribución horizontal fácil

#### **Limitaciones:**
- 🔍 **Consultas limitadas**: Solo por clave
- 📊 **Sin agregaciones**: No soporta SUM, COUNT, etc.

---

### 📄 **2. BASES DE DATOS ORIENTADAS A DOCUMENTOS**

#### **Características:**
- **Modelo**: Documentos JSON/BSON/XML
- **Estructura**: Documentos anidados con campos
- **Consultas**: Por cualquier campo del documento
- **Casos de uso**: CMS, catálogos, perfiles de usuario

#### **Ejemplos:**
- **MongoDB**: Líder en documentos, GridFS
- **CouchDB**: Sincronización offline
- **Amazon DocumentDB**: Compatible con MongoDB

#### **Ventajas:**
- 🎯 **Flexibilidad**: Esquema dinámico
- 🔍 **Consultas ricas**: Índices en cualquier campo
- 📱 **Natural para apps**: Mapea bien con objetos

#### **Limitaciones:**
- 🔗 **Sin JOINs nativos**: Relaciones complejas difíciles
- 💾 **Redundancia**: Datos duplicados

---

### 🏛️ **3. BASES DE DATOS COLUMNARES (Wide-Column)**

#### **Características:**
- **Modelo**: Familias de columnas
- **Estructura**: Filas con columnas dinámicas
- **Consultas**: Por fila y columna
- **Casos de uso**: Analytics, time-series, IoT

#### **Ejemplos:**
- **Apache Cassandra**: Distribuida, sin punto único de falla
- **HBase**: Sobre HDFS, integración Hadoop
- **Amazon Redshift**: Data warehouse

#### **Ventajas:**
- 📊 **Analytics**: Optimizado para consultas columnares
- 🔄 **Escalabilidad**: Distribución automática
- ⚡ **Compresión**: Datos columnares se comprimen mejor

#### **Limitaciones:**
- 🔍 **Consultas específicas**: Optimizado para patrones conocidos
- 📝 **Complejidad**: Modelado de datos más complejo

---

### 🕸️ **4. BASES DE DATOS DE GRAFOS**

#### **Características:**
- **Modelo**: Nodos y relaciones (edges)
- **Estructura**: Grafo dirigido con propiedades
- **Consultas**: Traversal de grafos
- **Casos de uso**: Redes sociales, recomendaciones, fraude

#### **Ejemplos:**
- **Neo4j**: Líder en grafos, Cypher query language
- **Amazon Neptune**: Servicio gestionado
- **ArangoDB**: Multi-modelo (documentos + grafos)

#### **Ventajas:**
- 🔗 **Relaciones**: Navegación eficiente entre nodos
- 🎯 **Patrones**: Detecta patrones complejos
- 🧠 **Intuitivo**: Modela relaciones naturalmente

#### **Limitaciones:**
- 📈 **Escalabilidad**: Difícil distribuir grafos
- 💾 **Memoria**: Requiere mucha RAM para rendimiento

---

## ⚖️ 3. CONSISTENCIA vs DISPONIBILIDAD (Teorema CAP)

### 📐 **TEOREMA CAP**

**Solo puedes garantizar 2 de 3 propiedades simultáneamente:**

#### **🎯 C - CONSISTENCIA (Consistency)**
- **Definición**: Todos los nodos ven los mismos datos al mismo tiempo
- **Características**: 
  - Lecturas devuelven el valor más reciente
  - Todas las réplicas están sincronizadas
  - Transacciones ACID

#### **🔄 A - DISPONIBILIDAD (Availability)**  
- **Definición**: El sistema sigue respondiendo aunque fallen algunos nodos
- **Características**:
  - Sin tiempo de inactividad
  - Respuestas rápidas
  - Tolerancia a fallos

#### **🌐 P - TOLERANCIA A PARTICIONES (Partition Tolerance)**
- **Definición**: El sistema funciona aunque se pierda comunicación entre nodos
- **Características**:
  - Red puede fallar
  - Nodos aislados siguen funcionando
  - Sistema distribuido real

---

### 🔄 **TIPOS DE CONSISTENCIA**

#### **1. CONSISTENCIA FUERTE (Strong Consistency)**
- **Características**: Todos ven los mismos datos inmediatamente
- **Ejemplos**: Sistemas bancarios, SQL tradicionales
- **Trade-off**: Menor disponibilidad y rendimiento

#### **2. CONSISTENCIA EVENTUAL (Eventual Consistency)**
- **Características**: Los datos se sincronizan "eventualmente"
- **Ejemplos**: DNS, redes sociales, Cassandra
- **Trade-off**: Mayor disponibilidad y rendimiento

#### **3. CONSISTENCIA DÉBIL (Weak Consistency)**
- **Características**: No garantiza cuándo se sincronizarán
- **Ejemplos**: Cache, sistemas en tiempo real
- **Trade-off**: Máximo rendimiento

---

### 📊 **COMPARACIÓN PRÁCTICA**

| Aspecto | **Consistencia Fuerte** | **Consistencia Eventual** |
|---------|-------------------------|---------------------------|
| **Latencia** | Alta (espera sincronización) | Baja (respuesta inmediata) |
| **Disponibilidad** | Menor (falla si no sincroniza) | Mayor (siempre responde) |
| **Casos de uso** | Bancos, inventarios críticos | Redes sociales, analytics |
| **Ejemplos** | PostgreSQL, Oracle | Cassandra, DynamoDB |

---

## 🏛️ 4. HBASE: TIPO DE BASE DE DATOS NoSQL

### 📋 **CLASIFICACIÓN DE HBASE**

**HBase es una base de datos NoSQL de tipo COLUMNAR (Wide-Column)**

#### **Características Técnicas:**
- **Modelo**: Familias de columnas (Column Families)
- **Arquitectura**: Distribuida sobre HDFS
- **Inspiración**: Google BigTable
- **Ecosistema**: Integrado con Hadoop

#### **Estructura de Datos:**
```
Tabla
├── Row Key (clave de fila)
├── Column Family 1
│   ├── Column 1:Qualifier → Value + Timestamp
│   └── Column 2:Qualifier → Value + Timestamp  
└── Column Family 2
    ├── Column 3:Qualifier → Value + Timestamp
    └── Column 4:Qualifier → Value + Timestamp
```

#### **Ventajas de HBase:**
- ✅ **Escalabilidad**: Petabytes de datos
- ✅ **Integración Hadoop**: Funciona con MapReduce, Spark
- ✅ **Consistencia fuerte**: A nivel de fila
- ✅ **Compresión**: Datos columnares se comprimen bien
- ✅ **Versionado**: Múltiples versiones por celda

#### **Limitaciones de HBase:**
- ❌ **Solo por Row Key**: Consultas limitadas
- ❌ **Sin SQL**: API Java/REST principalmente  
- ❌ **Complejidad**: Requiere conocimiento de Hadoop
- ❌ **Latencia**: No optimizado para consultas en tiempo real

#### **Casos de Uso de HBase:**
- 📊 **Analytics**: Análisis de grandes datasets
- 📱 **IoT**: Series temporales de sensores
- 🔍 **Logging**: Almacenamiento de logs masivos
- 🌐 **Web Crawling**: Índices de páginas web

---

## 🏗️ 5. ARQUITECTURA DE CASSANDRA

### 🔄 **TIPO DE ARQUITECTURA: PEER-TO-PEER DISTRIBUIDA**

#### **Características Principales:**
- **Sin Master**: Todos los nodos son iguales
- **Ring Topology**: Nodos organizados en anillo
- **Consistent Hashing**: Distribución automática de datos
- **Gossip Protocol**: Comunicación entre nodos

---

### 🎯 **COMPONENTES DE LA ARQUITECTURA**

#### **1. RING DE NODOS**
```
       Nodo A (Token: 0-25)
           ↗     ↖
    Nodo D          Nodo B  
  (Token: 75-0)   (Token: 25-50)
           ↖     ↗
       Nodo C (Token: 50-75)
```

#### **2. PARTICIONADOR (Partitioner)**
- **Función**: Determina en qué nodo va cada dato
- **Tipos**:
  - **Murmur3Partitioner**: Hash MD5 (por defecto)
  - **RandomPartitioner**: Distribución aleatoria
  - **ByteOrderedPartitioner**: Orden lexicográfico

#### **3. FACTOR DE REPLICACIÓN**
- **RF=1**: Sin redundancia (no recomendado)
- **RF=3**: Datos en 3 nodos (recomendado)
- **RF=5**: Alta disponibilidad (para datos críticos)

#### **4. ESTRATEGIA DE REPLICACIÓN**
- **SimpleStrategy**: Un solo datacenter
- **NetworkTopologyStrategy**: Múltiples datacenters

---

### ⚖️ **NIVELES DE CONSISTENCIA**

#### **PARA ESCRITURAS:**
- **ALL**: Todos los nodos deben confirmar
- **QUORUM**: Mayoría de nodos (RF/2 + 1)
- **ONE**: Solo un nodo confirma
- **LOCAL_QUORUM**: Mayoría en datacenter local

#### **PARA LECTURAS:**
- **ALL**: Lee de todos los nodos
- **QUORUM**: Lee de mayoría de nodos  
- **ONE**: Lee de un solo nodo
- **LOCAL_ONE**: Lee de nodo local

#### **FÓRMULA DE CONSISTENCIA:**
```
R + W > RF = Consistencia fuerte
Donde:
R = Nodos de lectura
W = Nodos de escritura  
RF = Factor de replicación
```

---

### 🔄 **PROCESO DE ESCRITURA**

1. **Cliente envía escritura** → Cualquier nodo (Coordinator)
2. **Coordinator determina réplicas** → Usando partitioner
3. **Escritura en commit log** → Persistencia inmediata
4. **Escritura en memtable** → Memoria para velocidad
5. **Confirmación al cliente** → Según nivel de consistencia
6. **Flush a SSTable** → Cuando memtable se llena

---

### 🔍 **PROCESO DE LECTURA**

1. **Cliente solicita lectura** → Cualquier nodo
2. **Coordinator identifica réplicas** → Nodos con los datos
3. **Lectura según consistencia** → De uno o varios nodos
4. **Read Repair** → Sincroniza diferencias encontradas
5. **Respuesta al cliente** → Datos más recientes

---

### 💪 **VENTAJAS DE LA ARQUITECTURA**

#### **🎯 Sin Punto Único de Falla**
- Cualquier nodo puede fallar sin afectar el sistema
- Autorecuperación automática

#### **📈 Escalabilidad Lineal**
- Agregar nodos aumenta capacidad proporcionalmente
- Redistribución automática de datos

#### **🌐 Multi-Datacenter**
- Replicación geográfica nativa
- Tolerancia a fallos de datacenter completo

#### **⚡ Alto Rendimiento**
- Escrituras optimizadas (append-only)
- Lecturas distribuidas en paralelo

---

### 📊 **COMPARACIÓN ARQUITECTURAL**

| Aspecto | **Cassandra** | **HBase** | **MongoDB** |
|---------|---------------|-----------|-------------|
| **Arquitectura** | Peer-to-peer | Master-Slave | Replica Set |
| **Punto de falla** | No | Sí (HMaster) | Sí (Primary) |
| **Escalabilidad** | Lineal | Buena | Limitada |
| **Consistencia** | Configurable | Fuerte | Configurable |
| **Casos de uso** | Write-heavy | Analytics | General purpose |

---

## 🎯 RESUMEN EJECUTIVO

### **SQL vs NoSQL:**
- **SQL**: Consistencia, relaciones, ACID → Aplicaciones transaccionales
- **NoSQL**: Escalabilidad, flexibilidad, BASE → Big Data, web scale

### **Categorías NoSQL:**
1. **Clave-Valor**: Redis, DynamoDB → Cache, sesiones
2. **Documentos**: MongoDB, CouchDB → Apps web, CMS
3. **Columnares**: Cassandra, HBase → Analytics, IoT
4. **Grafos**: Neo4j, Neptune → Redes sociales, recomendaciones

### **Consistencia vs Disponibilidad:**
- **Consistencia fuerte**: Datos siempre actualizados → Bancos
- **Consistencia eventual**: Alta disponibilidad → Redes sociales

### **HBase:**
- Tipo: **Base de datos columnar** (Wide-Column)
- Fortaleza: Analytics masivos sobre Hadoop

### **Cassandra:**
- Arquitectura: **Peer-to-peer distribuida**
- Fortaleza: Escrituras masivas sin punto único de falla

---

**¡Esta guía te ayudará a elegir la base de datos correcta para cada caso de uso!** 🚀


