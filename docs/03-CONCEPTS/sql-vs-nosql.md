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
- **Estructura**: Flexible, sin esquema fijo
- **Esquema**: Dinámico (Schema-on-Read)
- **Lenguaje**: APIs específicas o lenguajes propios
- **ACID**: BASE (Basically Available, Soft state, Eventual consistency)
- **Escalabilidad**: Horizontal (distribuir en múltiples servidores)
- **Consistencia**: Eventual o débil

#### **Ventajas:**
- ✅ **Escalabilidad horizontal**: Fácil agregar más servidores
- ✅ **Flexibilidad**: Estructura adaptable
- ✅ **Rendimiento**: Optimizado para casos específicos
- ✅ **Costo**: Generalmente open source
- ✅ **Big Data**: Manejo eficiente de grandes volúmenes

#### **Desventajas:**
- ❌ **Consistencia eventual**: No garantiza consistencia inmediata
- ❌ **Curva de aprendizaje**: APIs y conceptos diferentes
- ❌ **Menos madurez**: Tecnologías más nuevas
- ❌ **Consultas limitadas**: Menos capacidades de consulta compleja

---

## 🗂️ 2. CATEGORÍAS DE BASES DE DATOS NoSQL

### 📄 **DOCUMENTALES (Document Stores)**
**Almacenan documentos JSON/BSON**

#### **Ejemplos:**
- **MongoDB**: Documentos JSON flexibles
- **CouchDB**: Documentos con replicación
- **DynamoDB**: AWS, documentos con índices

#### **Características:**
```json
{
  "id": "123",
  "nombre": "Juan",
  "edad": 30,
  "direcciones": [
    {"tipo": "casa", "calle": "Av. Principal 123"},
    {"tipo": "trabajo", "calle": "Oficina 456"}
  ]
}
```

#### **Casos de Uso:**
- ✅ Contenido web dinámico
- ✅ Perfiles de usuario
- ✅ Catálogos de productos
- ✅ Sistemas de CMS

---

### 🗃️ **CLAVE-VALOR (Key-Value)**
**Almacenan pares clave-valor simples**

#### **Ejemplos:**
- **Redis**: En memoria, muy rápido
- **DynamoDB**: AWS, escalable
- **Riak**: Distribuido y tolerante a fallos

#### **Características:**
```
clave: "usuario:123"
valor: "Juan Pérez, juan@email.com, activo"
```

#### **Casos de Uso:**
- ✅ Caché de aplicaciones
- ✅ Sesiones de usuario
- ✅ Contadores y métricas
- ✅ Configuraciones

---

### 📊 **COLUMNAS (Column Family)**
**Almacenan datos en familias de columnas**

#### **Ejemplos:**
- **HBase**: Sobre Hadoop, Big Data
- **Cassandra**: Distribuido, alta disponibilidad
- **ScyllaDB**: C++ reescrito de Cassandra

#### **Características:**
```
Fila: "usuario_123"
Familia: "personal" → nombre: Juan, edad: 30
Familia: "contacto" → email: juan@email.com, tel: 123456
```

#### **Casos de Uso:**
- ✅ Big Data y analytics
- ✅ IoT y time series
- ✅ Sistemas distribuidos
- ✅ Aplicaciones de alta escritura

---

### 🔗 **GRAFOS (Graph Databases)**
**Almacenan nodos y relaciones**

#### **Ejemplos:**
- **Neo4j**: Grafos nativos, ACID
- **Amazon Neptune**: AWS, grafos escalables
- **ArangoDB**: Multi-modelo (documentos + grafos)

#### **Características:**
```
Nodos: Persona, Ciudad, Empresa
Relaciones: VIVE_EN, TRABAJA_EN, CONOCE_A
```

#### **Casos de Uso:**
- ✅ Redes sociales
- ✅ Sistemas de recomendación
- ✅ Análisis de fraudes
- ✅ Sistemas de conocimiento

---

## ⚖️ 3. CONSISTENCIA vs DISPONIBILIDAD

### 🔒 **CONSISTENCIA**
**Todos los nodos ven los mismos datos al mismo tiempo**

#### **Consistencia Fuerte (ACID):**
- ✅ **Atomicidad**: Todo o nada
- ✅ **Consistencia**: Datos válidos siempre
- ✅ **Aislamiento**: Transacciones independientes
- ✅ **Durabilidad**: Cambios persistentes

#### **Ejemplo SQL:**
```sql
BEGIN TRANSACTION;
UPDATE cuenta SET saldo = saldo - 100 WHERE id = 1;
UPDATE cuenta SET saldo = saldo + 100 WHERE id = 2;
COMMIT; -- Todo se confirma o nada
```

---

### 🌐 **DISPONIBILIDAD**
**El sistema siempre responde, incluso con fallos**

#### **Características:**
- ✅ **Tolerancia a fallos**: Sistema sigue funcionando
- ✅ **Redundancia**: Múltiples copias de datos
- ✅ **Distribución**: Datos en múltiples ubicaciones
- ✅ **Recuperación rápida**: Menos tiempo de inactividad

#### **Ejemplo NoSQL:**
```javascript
// Cassandra: Escribe en múltiples nodos
INSERT INTO usuarios (id, nombre) VALUES ('123', 'Juan');
// Se replica automáticamente en 3 nodos
```

---

### 🎯 **EL TEOREMA CAP**
**Solo puedes tener 2 de 3 propiedades:**

#### **C - Consistency (Consistencia)**
- Todos los nodos ven los mismos datos

#### **A - Availability (Disponibilidad)**  
- El sistema siempre responde

#### **P - Partition Tolerance (Tolerancia a Particiones)**
- El sistema funciona aunque haya fallos de red

#### **Combinaciones Comunes:**
- **CA**: PostgreSQL (Consistencia + Disponibilidad)
- **CP**: MongoDB (Consistencia + Tolerancia a Particiones)
- **AP**: Cassandra (Disponibilidad + Tolerancia a Particiones)

---

## 🗄️ 4. QUÉ TIPO DE BASE DE DATOS NoSQL ES HBase

### 🔥 **HBASE: BASE DE DATOS COLUMN FAMILY**

#### **Características:**
- **Tipo**: Column Family (Columnar)
- **Base**: Apache Hadoop
- **Escalabilidad**: Horizontal masiva
- **Consistencia**: Fuerte (ACID limitado)
- **Disponibilidad**: Alta (replicación automática)

#### **Arquitectura:**
```
HBase Master (1)
├── HBase Region Servers (múltiples)
├── HDFS (almacenamiento distribuido)
└── ZooKeeper (coordinación)
```

#### **Modelo de Datos:**
```
Tabla: usuarios
Fila: usuario_123
Familia: personal → nombre: Juan, edad: 30
Familia: contacto → email: juan@email.com
Familia: preferencias → tema: oscuro, idioma: es
```

#### **Ventajas de HBase:**
- ✅ **Big Data**: Maneja petabytes de datos
- ✅ **Escrituras masivas**: Optimizado para alta escritura
- ✅ **Escalabilidad**: Miles de nodos
- ✅ **Integración Hadoop**: Ecosistema completo
- ✅ **Time Series**: Ideal para datos temporales

#### **Casos de Uso:**
- 📊 **Analytics**: Procesamiento de grandes volúmenes
- 📱 **IoT**: Datos de sensores y dispositivos
- 💬 **Logs**: Almacenamiento de logs masivos
- 🎯 **Personalización**: Datos de usuarios masivos

---

## 🏗️ 5. ARQUITECTURA DE CASSANDRA

### 💎 **CASSANDRA: ARQUITECTURA DISTRIBUIDA P2P**

#### **Características Principales:**
- **Tipo**: Column Family distribuida
- **Arquitectura**: Peer-to-Peer (P2P)
- **Sin punto único de fallo**: No hay maestro
- **Escalabilidad**: Lineal (agregar nodos = más capacidad)
- **Consistencia**: Configurable (tunable consistency)

#### **Arquitectura P2P:**
```
Nodo 1 ←→ Nodo 2 ←→ Nodo 3
  ↕        ↕        ↕
Nodo 4 ←→ Nodo 5 ←→ Nodo 6
  ↕        ↕        ↕
Nodo 7 ←→ Nodo 8 ←→ Nodo 9
```

#### **Componentes:**

##### **🔧 Nodos (Nodes):**
- **Función**: Almacenan y sirven datos
- **Independencia**: Cada nodo es igual
- **Comunicación**: Todos hablan con todos

##### **🌐 Anillo (Ring):**
- **Distribución**: Datos distribuidos por hash
- **Balanceo**: Carga equilibrada
- **Tolerancia**: Fallos no afectan el sistema

##### **📊 Replicación:**
- **Factor**: Número de copias (ej: 3)
- **Estrategia**: SimpleStrategy, NetworkTopologyStrategy
- **Consistencia**: Configurable por operación

#### **Flujo de Datos:**
```
1. Cliente → Nodo Coordinador
2. Coordinador → Nodos Replicas
3. Replicas → Confirmación
4. Coordinador → Cliente
```

#### **Ventajas de la Arquitectura P2P:**
- ✅ **Sin SPOF**: No hay punto único de fallo
- ✅ **Escalabilidad lineal**: Agregar nodos = más capacidad
- ✅ **Alta disponibilidad**: Sistema siempre disponible
- ✅ **Distribución geográfica**: Datos cerca de usuarios
- ✅ **Tolerancia a particiones**: Funciona con fallos de red

#### **Casos de Uso de Cassandra:**
- 🌐 **Web scale**: Aplicaciones masivas
- 📱 **IoT**: Datos de dispositivos
- 💬 **Mensajería**: Sistemas de chat
- 📊 **Analytics**: Procesamiento distribuido
- 🎮 **Gaming**: Datos de jugadores masivos

---

## 🎯 **CUÁNDO USAR CADA TIPO**

### 📊 **USAR SQL CUANDO:**
- ✅ Necesitas transacciones ACID
- ✅ Tienes datos estructurados
- ✅ Requieres consultas complejas
- ✅ El volumen es manejable
- ✅ La consistencia es crítica

### 🚀 **USAR NoSQL CUANDO:**
- ✅ Necesitas escalar horizontalmente
- ✅ Tienes Big Data (terabytes/petabytes)
- ✅ La estructura es flexible
- ✅ Necesitas alta disponibilidad
- ✅ El rendimiento es crítico

### 🎯 **DECISIÓN POR CATEGORÍA:**

#### **Documentales:**
- ✅ Contenido web dinámico
- ✅ Perfiles de usuario
- ✅ Catálogos de productos

#### **Clave-Valor:**
- ✅ Caché de aplicaciones
- ✅ Sesiones de usuario
- ✅ Contadores y métricas

#### **Column Family:**
- ✅ Big Data y analytics
- ✅ IoT y time series
- ✅ Sistemas distribuidos

#### **Grafos:**
- ✅ Redes sociales
- ✅ Sistemas de recomendación
- ✅ Análisis de fraudes

---

## 🏆 **CONCLUSIONES**

### **SQL vs NoSQL: No es competencia, es complemento**
- **SQL**: Ideal para aplicaciones transaccionales
- **NoSQL**: Ideal para aplicaciones de Big Data
- **Híbrido**: Muchos sistemas usan ambos

### **HBase**: La columna para Big Data
- **Fortaleza**: Escalabilidad masiva
- **Uso**: Analytics y procesamiento de datos
- **Ecosistema**: Integrado con Hadoop

### **Cassandra**: La distribución para alta disponibilidad
- **Fortaleza**: Sin punto único de fallo
- **Uso**: Aplicaciones web masivas
- **Escalabilidad**: Lineal y geográfica

### **🎯 Para el Curso:**
- **PostgreSQL**: Aprendizaje y desarrollo
- **HBase**: Big Data y analytics
- **Cassandra**: Sistemas distribuidos
- **Combinación**: Ecosistema completo de datos

---

**🚀 ¡Ahora entiendes el panorama completo de bases de datos modernas!**
