# 🚀 Curso Data Engineering - Hadoop, Hive, Spark & PostgreSQL

## 🎯 **¡BIENVENIDO AL CURSO MÁS COMPLETO DE DATA ENGINEERING!**

Aprende **Big Data** con un entorno profesional que incluye **Hadoop**, **Hive**, **Spark**, **PostgreSQL**, **HBase** y **Cassandra**.

### **✨ LO QUE VAS A DOMINAR:**
- 🗄️ **PostgreSQL** - Base de datos relacional profesional
- ⚡ **Apache Spark** - Procesamiento de datos en memoria  
- 🐝 **Apache Hive** - Data warehouse sobre Hadoop
- 📊 **Hadoop HDFS** - Sistema de archivos distribuido
- 📓 **Jupyter Lab** - Entorno de desarrollo interactivo
- 🔥 **NoSQL** - HBase y Cassandra

---

## 🚀 **INICIO RÁPIDO - ¡En 15 minutos funcionando!**

### **👋 ¿NUEVO EN EL CURSO?**
```bash
# 1. Clonar repositorio
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it

# 2. Instalar entorno básico (solo PostgreSQL)
docker-compose up -d metastore

# 3. ¡Listo! Conecta desde DBeaver
# Host: localhost | Puerto: 5432 | Usuario: postgres | Contraseña: jupyter
```

### **🔧 ¿QUIERES EL ENTORNO COMPLETO?**
```bash
# Construir y levantar TODO (Hadoop + Spark + Hive + Jupyter)
make
```

---

## 📚 **DOCUMENTACIÓN PROFESIONAL**

### **🧭 NAVEGACIÓN INTELIGENTE:**

#### **👶 SOY PRINCIPIANTE:**
```
📖 docs/01-GETTING-STARTED/ → Tutoriales paso a paso
```

#### **🔧 NECESITO RESOLVER ALGO:**
```
🔧 docs/02-HOW-TO-GUIDES/ → Soluciones específicas
```

#### **💡 QUIERO ENTENDER CONCEPTOS:**
```
💡 docs/03-CONCEPTS/ → Explicaciones teóricas
```

#### **📚 BUSCO INFORMACIÓN TÉCNICA:**
```
📚 docs/04-REFERENCE/ → Comandos, credenciales, puertos
```

#### **🎯 QUIERO PRACTICAR:**
```
🎯 docs/05-EXERCISES/ → Ejercicios y proyectos
```

### **🚀 [VER DOCUMENTACIÓN COMPLETA](./docs/)**

---

## 🌐 **SERVICIOS INCLUIDOS**

| **Servicio** | **URL** | **Descripción** |
|--------------|---------|-----------------|
| 🗄️ **PostgreSQL** | `localhost:5432` | Base de datos principal |
| 📓 **Jupyter Lab** | http://localhost:8890 | Entorno de desarrollo |
| 📊 **Jupyter Notebook** | http://localhost:8888 | Notebooks interactivos |
| ⚡ **Spark Master** | http://localhost:8080 | Interfaz del clúster Spark |
| 📁 **HDFS Web UI** | http://localhost:9870 | Sistema de archivos Hadoop |
| 🧮 **YARN ResourceManager** | http://localhost:8088 | Gestor de recursos |
| 🐝 **Hive** | `localhost:10000` | Data warehouse SQL |
| 🔥 **HBase** | http://localhost:16010 | Base NoSQL columnar |
| 💎 **Cassandra** | `localhost:9042` | Base NoSQL distribuida |

---

## 🔑 **CREDENCIALES RÁPIDAS**

### **🗄️ PostgreSQL:**
```
Host: localhost
Puerto: 5432
Usuario: postgres
Contraseña: jupyter
```

### **🎓 Base de datos del curso:**
```
Base de datos: educacionit
Usuario: admin
Contraseña: admin123
```

### **📓 Jupyter:**
- **Sin contraseña** - Acceso directo desde el navegador

---

## ⚡ **COMANDOS ESENCIALES**

### **🚀 GESTIÓN DEL ENTORNO:**
```bash
# Ver estado de servicios
make status

# Levantar todo
make up

# Detener todo  
make down

# Limpiar y reconstruir
make clean && make
```

### **🔍 DIAGNÓSTICO RÁPIDO:**
```bash
# Ver logs
docker-compose logs -f

# Verificar contenedores
docker-compose ps

# Conectar a PostgreSQL
docker exec -it educacionit-metastore-1 psql -U postgres
```

---

## 🎓 **RUTAS DE APRENDIZAJE**

### **📈 NIVEL 1: FUNDAMENTOS**
1. 📖 [Instalación Rápida](./docs/01-GETTING-STARTED/instalacion-rapida.md) (15 min)
2. 📖 [Primer Uso](./docs/01-GETTING-STARTED/primer-uso.md) (30 min)
3. 🔧 [PostgreSQL Básico](./docs/02-HOW-TO-GUIDES/postgresql/) (45 min)

### **📈 NIVEL 2: INTERMEDIO**
1. 📖 [Configuración Completa](./docs/01-GETTING-STARTED/configuracion-completa.md) (60 min)
2. 🔧 [Hadoop y Spark](./docs/02-HOW-TO-GUIDES/hadoop-spark/) (90 min)
3. 💡 [SQL vs NoSQL](./docs/03-CONCEPTS/sql-vs-nosql.md) (30 min)

### **📈 NIVEL 3: AVANZADO**
1. 🎯 [Ejercicios de Calidad de Datos](./docs/05-EXERCISES/calidad-datos/) (120 min)
2. 🎯 [Jobs de Hadoop](./docs/05-EXERCISES/hadoop-jobs/) (180 min)
3. 🤝 [Contribuir al Proyecto](#-contribuir)

---

## 🛠️ **ARQUITECTURA DEL SISTEMA**

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  PostgreSQL │    │   Jupyter   │    │    Spark    │
│ (Metastore) │    │    Lab      │    │   Master    │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                   ┌───────┼───────┐
                   │       │       │
              ┌─────────┐ ┌─────────┐ ┌─────────┐
              │ Hadoop  │ │  Hive   │ │  NoSQL  │
              │  HDFS   │ │ Server  │ │ (HBase/ │
              │         │ │         │ │Cassand.)│
              └─────────┘ └─────────┘ └─────────┘
```

---

## 🆘 **SOLUCIÓN DE PROBLEMAS**

### **🔴 PROBLEMAS COMUNES:**

#### **Docker no funciona:**
```bash
# Verificar Docker
docker --version
docker-compose --version

# Reiniciar Docker
sudo systemctl restart docker
```

#### **Puertos ocupados:**
```bash
# Ver qué usa los puertos
sudo netstat -tlnp | grep -E "(5432|8888|8080)"

# Detener servicios conflictivos
sudo systemctl stop postgresql
```

#### **Contenedores no inician:**
```bash
# Ver logs específicos
docker logs educacionit-metastore-1

# Recrear contenedores
docker-compose down && docker-compose up -d
```

### **📞 MÁS AYUDA:**
- 🛠️ [Guía de Troubleshooting](./docs/02-HOW-TO-GUIDES/troubleshooting/)
- 📚 [Referencia Técnica](./docs/04-REFERENCE/)
- 🔧 [Configuración Avanzada](./docs/02-HOW-TO-GUIDES/)

---

## 📊 **STACK TECNOLÓGICO**

### **🏗️ INFRAESTRUCTURA:**
- **Docker** 20.10+ & **Docker Compose** 2.0+
- **Ubuntu** 22.04 (base containers)
- **Java** OpenJDK 8

### **📊 BIG DATA:**
- **Apache Hadoop** 3.3.6
- **Apache Spark** 3.5.3  
- **Apache Hive** 3.1.3

### **🗄️ BASES DE DATOS:**
- **PostgreSQL** 11
- **Apache HBase** (latest)
- **Apache Cassandra** 4.1

### **🔧 HERRAMIENTAS:**
- **Jupyter Lab** (latest)
- **Python** 3.8+ con PySpark
- **Scala** 2.12

---

## 🤝 **CONTRIBUIR**

### **¿QUIERES MEJORAR EL PROYECTO?**

1. **Fork** el repositorio
2. **Crea una rama**: `git checkout -b feature/mi-mejora`
3. **Haz tus cambios** y commit: `git commit -m "Descripción"`
4. **Push**: `git push origin feature/mi-mejora`
5. **Abre un Pull Request**

### **📝 ÁREAS DE CONTRIBUCIÓN:**
- 📚 Mejorar documentación
- 🐛 Reportar y arreglar bugs
- ✨ Nuevas funcionalidades
- 🎯 Ejercicios adicionales
- 🌐 Traducción a otros idiomas

---

## ⚠️ **ADVERTENCIAS IMPORTANTES**

### **🔐 SEGURIDAD:**
- **Solo para desarrollo/aprendizaje** - NO usar en producción
- **Credenciales por defecto** - Cambiar en entornos reales
- **Puertos expuestos** - Firewall recomendado

### **💻 RECURSOS:**
- **Mínimo 8GB RAM** - 16GB recomendado
- **20GB espacio libre** - Para imágenes y datos
- **CPU multi-core** - Mejor rendimiento

---

## 📞 **SOPORTE Y COMUNIDAD**

### **🆘 ¿NECESITAS AYUDA?**
- 📖 [Documentación](./docs/)
- 🐛 [Issues de GitHub](https://github.com/FacundoDuranDev/curso-educacion-it/issues)
- 💬 [Discusiones](https://github.com/FacundoDuranDev/curso-educacion-it/discussions)

### **📧 CONTACTO:**
- **Instructor**: Facundo Durán
- **GitHub**: [@FacundoDuranDev](https://github.com/FacundoDuranDev)

---

## 📜 **LICENCIA**

Este proyecto está bajo la **Licencia MIT** - ver [LICENSE](./LICENSE) para detalles.

---

## 🎉 **¡COMIENZA AHORA!**

### **🚀 TU PRIMER PASO:**
```bash
# Clona el repositorio
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it

# Lee la documentación
cat docs/README.md

# ¡Empieza a aprender!
cd docs/01-GETTING-STARTED/
```

### **🎯 OBJETIVO:**
**En 2 horas tendrás un entorno profesional de Big Data funcionando y estarás ejecutando tu primer análisis de datos.**

---

**🚀 ¡Bienvenido al futuro del Data Engineering!** 

**📚 [COMENZAR AHORA](./docs/01-GETTING-STARTED/)** | **🔧 [VER GUÍAS](./docs/02-HOW-TO-GUIDES/)** | **💡 [APRENDER CONCEPTOS](./docs/03-CONCEPTS/)**
