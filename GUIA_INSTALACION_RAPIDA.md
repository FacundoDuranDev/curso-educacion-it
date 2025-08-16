# 🚀 Guía Rápida de Instalación - Curso Data Engineering

## 📋 **Requisitos Previos**

### **Software necesario:**
- ✅ **Docker Desktop** instalado y ejecutándose
- ✅ **Git** instalado
- ✅ **Terminal** (Git Bash en Windows, Terminal en Mac/Linux)

---

## 🔧 **Paso 1: Clonar el Repositorio**

### **Opción A: HTTPS (Recomendada para principiantes)**
```bash
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it
```

### **Opción B: SSH (Si tienes configurado)**
```bash
git clone git@github.com:FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it
```

---

## 🐳 **Paso 2: Verificar Docker**

### **Verificar que Docker esté ejecutándose:**
```bash
docker --version
docker-compose --version
```

**Si no tienes Docker:**
1. Descarga desde [docker.com](https://docker.com)
2. Instala y reinicia tu computadora
3. Abre Docker Desktop y espera a que esté listo

---

## 🚀 **Paso 3: Levantar el Entorno**

### **Opción Simple (Solo PostgreSQL):**
```bash
# Dar permisos a los scripts
chmod +x scripts/*.sh

# Levantar solo PostgreSQL
docker-compose -f docker-compose.yml up -d postgres

# Verificar que esté funcionando
docker ps | grep postgres
```

### **Opción Completa (PostgreSQL + Hadoop + Spark):**
```bash
# Dar permisos a los scripts
chmod +x scripts/*.sh

# Levantar todo el entorno
docker-compose -f docker-compose.yml up -d

# Verificar estado
docker-compose ps
```

---

## 🔍 **Paso 4: Verificar la Instalación**

### **Verificar PostgreSQL:**
```bash
# Conectar a PostgreSQL
docker exec -it postgres psql -U admin -d educacionit -c "SELECT version();"
```

**Deberías ver:**
```
PostgreSQL 15.13 (Debian 15.13-1.pgdg120+1) on x86_64-pc-linux-gnu
```

### **Verificar que las tablas estén creadas:**
```bash
docker exec -it postgres psql -U admin -d educacionit -c "\dt"
```

**Deberías ver las tablas:**
- clientes
- productos
- ventas
- empleados
- etc.

---

## 📊 **Paso 5: Conectar desde DBeaver**

### **Configuración de conexión:**
- **Host:** `localhost`
- **Port:** `5432`
- **Database:** `educacionit`
- **Username:** `admin`
- **Password:** `admin123`

### **Pasos en DBeaver:**
1. Click en **"Nueva Conexión"**
2. Selecciona **PostgreSQL**
3. Llena los datos de conexión
4. Click en **"Test Connection"**
5. Si funciona, click en **"Finish"**

---

## 🎯 **Comandos Útiles**

### **Ver estado de los servicios:**
```bash
docker-compose ps
```

### **Ver logs de un servicio:**
```bash
docker logs postgres
docker logs hadoop-namenode
```

### **Detener el entorno:**
```bash
docker-compose down
```

### **Reiniciar un servicio:**
```bash
docker-compose restart postgres
```

---

## ⚠️ **Solución de Problemas Comunes**

### **Error: "Port already in use"**
```bash
# Ver qué está usando el puerto 5432
sudo netstat -tlnp | grep 5432

# Detener PostgreSQL local si está instalado
sudo systemctl stop postgresql
```

### **Error: "Permission denied"**
```bash
# Dar permisos a los scripts
chmod +x scripts/*.sh

# O ejecutar con sudo
sudo ./scripts/setup_database.sh
```

### **Error: "Docker not running"**
1. Abre Docker Desktop
2. Espera a que el ícono esté verde
3. Intenta nuevamente

### **Error: "Container health check failed"**
```bash
# Ver logs del contenedor
docker logs postgres

# Reiniciar el contenedor
docker-compose restart postgres
```

---

## 🔄 **Flujo de Trabajo Diario**

### **Al iniciar el día:**
```bash
cd curso-educacion-it
docker-compose up -d postgres
```

### **Al terminar el día:**
```bash
docker-compose down
```

### **Si algo no funciona:**
```bash
docker-compose down
docker-compose up -d postgres
```

---

## 📱 **Acceso a los Servicios**

| Servicio | URL | Usuario | Contraseña |
|----------|-----|---------|------------|
| **PostgreSQL** | localhost:5432 | admin | admin123 |
| **HDFS Web UI** | http://localhost:9870 | - | - |
| **Spark Master** | http://localhost:8080 | - | - |
| **Jupyter Lab** | http://localhost:8888 | - | - |

---

## 🎓 **Primeros Pasos con la Base de Datos**

### **1. Conectar desde terminal:**
```bash
docker exec -it postgres psql -U admin -d educacionit
```

### **2. Ver las tablas disponibles:**
```sql
\dt
```

### **3. Ver estructura de una tabla:**
```sql
\d clientes
```

### **4. Hacer una consulta simple:**
```sql
SELECT COUNT(*) FROM clientes;
```

### **5. Salir de psql:**
```sql
\q
```

---

## 📚 **Recursos Adicionales**

- **Guía SQL:** `GUIA_SQL.md` - Sintaxis básica de SQL
- **Ejercicios:** `EJERCICIOS_CALIDAD_DATOS.md` - Ejercicios prácticos
- **Normalización:** `EJEMPLOS_NORMALIZACION.md` - Teoría de normalización

---

## 🆘 **¿Necesitas Ayuda?**

### **Verificar estado del sistema:**
```bash
# Estado de Docker
docker info

# Estado de los contenedores
docker-compose ps

# Estado de la red
docker network ls

# Estado de los volúmenes
docker volume ls
```

### **Reiniciar todo desde cero:**
```bash
# Detener y eliminar todo
docker-compose down -v
docker system prune -f

# Volver a empezar
docker-compose up -d postgres
```

---

## 🎉 **¡Listo para Empezar!**

Una vez que tengas PostgreSQL funcionando, podrás:
- ✅ Conectarte desde DBeaver
- ✅ Ejecutar consultas SQL
- ✅ Trabajar con los datos del curso
- ✅ Practicar normalización
- ✅ Realizar análisis de datos

---

*¡Si tienes problemas, revisa los logs y no dudes en pedir ayuda!* 🚀💪
