# 🔑 CREDENCIALES DEL SISTEMA

## 🎯 **GUÍA RÁPIDA**

**¿Qué credenciales necesito usar?**
- **Para instalar**: No necesitas credenciales, solo `make`
- **Para PostgreSQL básico**: `postgres` / `jupyter`
- **Para la base del curso**: `admin` / `admin123`
- **Para Jupyter**: Sin credenciales (acceso directo)

---

## 🗄️ **POSTGRESQL**

### **👤 Superusuario (Para administración):**
```
Host: localhost
Puerto: 5432
Usuario: postgres
Contraseña: jupyter
Base de datos: postgres (por defecto)
```

**¿Cuándo usar?**
- Crear bases de datos
- Crear usuarios
- Administración del sistema
- Troubleshooting

**Ejemplo de conexión:**
```bash
docker exec -it educacionit-metastore-1 psql -U postgres
```

### **🎓 Usuario del Curso (Para ejercicios):**
```
Host: localhost
Puerto: 5432
Usuario: admin
Contraseña: admin123
Base de datos: educacionit
```

**¿Cuándo usar?**
- Ejercicios del curso
- Consultas SQL
- Análisis de datos
- Proyectos prácticos

**Ejemplo de conexión:**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit
```

---

## 📓 **JUPYTER**

### **🌐 Acceso Web:**
```
Jupyter Notebook: http://localhost:8888
JupyterLab: http://localhost:8890
Token: No requerido
Contraseña: No requerida
```

**¿Cómo acceder?**
1. Abre el navegador
2. Ve a http://localhost:8888 o http://localhost:8890
3. ¡Listo! Sin autenticación necesaria

---

## 🐝 **HIVE**

### **📊 Metastore (Interno):**
```
Host: metastore (interno)
Puerto: 5432
Usuario: jupyter
Contraseña: jupyter
Base de datos: metastore
```

**Nota:** Este usuario se crea automáticamente para que Hive funcione.

### **🔌 HiveServer2 (Para consultas):**
```
Host: localhost
Puerto: 10000
Protocolo: JDBC
URL: jdbc:hive2://localhost:10000
```

**Ejemplo de conexión:**
```bash
docker exec -it educacionit-master-1 /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
```

---

## 🔥 **BASES DE DATOS NoSQL**

### **🏛️ HBase:**
```
Web UI: http://localhost:16010
Puerto Master: 16000
Puerto RegionServer: 16020
```

### **💎 Cassandra:**
```
Puerto CQL: 9042
Puerto JMX: 7199
Puerto Thrift: 9160
```

---

## 🌐 **SERVICIOS WEB - ACCESO DIRECTO**

### **📊 Interfaces de Monitoreo:**
```
🗄️ PostgreSQL: localhost:5432 (DBeaver/pgAdmin)
📓 Jupyter Notebook: http://localhost:8888
📊 JupyterLab: http://localhost:8890
⚡ Spark Master: http://localhost:8080
🔧 Spark Worker 1: http://localhost:8081
🔧 Spark Worker 2: http://localhost:8082
📁 HDFS Web UI: http://localhost:9870
🧮 YARN ResourceManager: http://localhost:8088
📈 Spark History: http://localhost:18080
🏛️ HBase Master: http://localhost:16010
```

---

## 🔧 **CONFIGURACIÓN DBEAVER**

### **🎯 Conexión Rápida PostgreSQL:**
1. **Nueva Conexión** → **PostgreSQL**
2. **Configuración:**
   ```
   Servidor: localhost
   Puerto: 5432
   Base de datos: educacionit
   Usuario: admin
   Contraseña: admin123
   ```
3. **Test Connection** → **OK** → **Finish**

### **⚙️ Opciones Avanzadas:**
- **Auto-commit:** Sí
- **Read-only:** No (Habilitado para escritura)
- **Isolation level:** Read Committed
- **SSL:** No (desarrollo local)

---

## 🚨 **TROUBLESHOOTING CREDENCIALES**

### **❌ "Access denied" en PostgreSQL:**
```bash
# Verificar que el contenedor esté corriendo
docker ps | grep metastore

# Verificar logs
docker logs educacionit-metastore-1

# Recrear usuario admin si es necesario
docker exec -it educacionit-metastore-1 psql -U postgres -c "DROP USER IF EXISTS admin;"
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE USER admin WITH PASSWORD 'admin123';"
docker exec -it educacionit-metastore-1 psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;"
```

### **❌ "Database does not exist":**
```bash
# Crear base de datos educacionit
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;"

# Verificar que existe
docker exec -it educacionit-metastore-1 psql -U postgres -c "\l"
```

### **❌ Jupyter no carga:**
```bash
# Verificar estado del servicio
docker-compose logs jupyter

# Reiniciar si es necesario
docker-compose restart jupyter
```

---

## 📋 **COMANDOS DE VERIFICACIÓN**

### **🔍 Verificar Todo Funciona:**
```bash
# 1. PostgreSQL
docker exec -it educacionit-metastore-1 psql -U postgres -c "SELECT version();"

# 2. Usuario admin
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "SELECT 'Conexión exitosa!' as mensaje;"

# 3. Jupyter
curl -s http://localhost:8888 > /dev/null && echo "✅ Jupyter OK" || echo "❌ Jupyter Error"

# 4. Spark
curl -s http://localhost:8080 > /dev/null && echo "✅ Spark OK" || echo "❌ Spark Error"

# 5. HDFS
curl -s http://localhost:9870 > /dev/null && echo "✅ HDFS OK" || echo "❌ HDFS Error"
```

---

## 💡 **CONSEJOS IMPORTANTES**

### **✅ BUENAS PRÁCTICAS:**
- **Desarrollo**: Usa las credenciales tal como están documentadas
- **Producción**: SIEMPRE cambia las credenciales por defecto
- **Seguridad**: Este entorno es solo para aprendizaje
- **Backup**: Haz backup de tus datos antes de limpiar contenedores

### **⚠️ ADVERTENCIAS:**
- **No usar en producción** con estas credenciales
- **Cambiar contraseñas** en entornos reales
- **Firewall recomendado** si expones puertos públicamente

---

## 🆘 **¿NECESITAS AYUDA?**

### **📞 SOPORTE RÁPIDO:**
- **Errores de conexión**: → `../02-HOW-TO-GUIDES/troubleshooting/`
- **Configuración DBeaver**: → `../02-HOW-TO-GUIDES/postgresql/conexion-dbeaver.md`
- **Instalación desde cero**: → `../01-GETTING-STARTED/instalacion-rapida.md`

**🎯 ¡Con estas credenciales tendrás acceso completo a todo el sistema!**
