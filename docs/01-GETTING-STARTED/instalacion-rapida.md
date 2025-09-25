# 🚀 Instalación Rápida - Tu Primer Entorno Funcionando

## 🎯 **OBJETIVO**
En **15 minutos** tendrás PostgreSQL funcionando y podrás conectarte desde DBeaver.

## ⏱️ **TIEMPO ESTIMADO:** 15 minutos

---

## 📋 **REQUISITOS PREVIOS**

### **Software necesario:**
- ✅ **Docker Desktop** instalado y ejecutándose
- ✅ **Git** instalado  
- ✅ **Terminal** (Git Bash en Windows, Terminal en Mac/Linux)

### **Verificación rápida:**
```bash
docker --version
git --version
```

**Si no tienes Docker:** [Descargar aquí](https://docker.com)

---

## 🔧 **PASO 1: Clonar el Repositorio**

### **Opción A: HTTPS (Recomendada)**
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

## 🐳 **PASO 2: Levantar PostgreSQL**

### **Comando único:**
```bash
# Levantar solo PostgreSQL
docker-compose up -d metastore

# Verificar que esté funcionando
docker ps | grep metastore
```

### **✅ Resultado esperado:**
```
educacionit-metastore-1  postgres:11  "docker-entrypoint.s…"  metastore  Up  0.0.0.0:5432->5432/tcp
```

---

## 🔍 **PASO 3: Verificar Funcionamiento**

### **Verificar estado:**
```bash
# Ver logs del contenedor
docker logs educacionit-metastore-1

# Verificar que PostgreSQL responde
docker exec -it educacionit-metastore-1 pg_isready -U postgres
```

### **✅ Resultado esperado:**
```
/var/lib/postgresql/data:5432 - accepting connections
```

---

## 🗄️ **PASO 4: Conectar desde DBeaver**

### **🔑 Credenciales de Conexión:**
```
Host: localhost
Puerto: 5432
Base de datos: postgres
Usuario: postgres
Contraseña: jupyter
```

### **📝 Pasos en DBeaver:**
1. Click en **"Nueva Conexión"**
2. Selecciona **PostgreSQL**
3. Llena los datos de conexión
4. Click en **"Test Connection"**
5. Si funciona, click en **"Finish"**

---

## ✅ **VERIFICACIÓN FINAL**

### **Comando de prueba:**
```bash
# Conectar y ejecutar consulta de prueba
docker exec -it educacionit-metastore-1 psql -U postgres -c "SELECT version();"
```

### **✅ Resultado esperado:**
```
PostgreSQL 11.x (Debian 11.x-1.pgdg120+1) on x86_64-pc-linux-gnu
```

---

## 🎉 **¡ÉXITO!**

### **✅ LO QUE HAS LOGRADO:**
- 🐳 Docker funcionando correctamente
- 🗄️ PostgreSQL corriendo en contenedor
- 🔌 Conexión exitosa desde DBeaver
- 📊 Primera consulta SQL ejecutada

### **🌐 SERVICIOS DISPONIBLES:**
- **PostgreSQL**: http://localhost:5432
- **Logs**: `docker logs educacionit-metastore-1`

---

## 🚀 **PRÓXIMOS PASOS**

### **📍 AHORA PUEDES:**
1. **Cargar datos**: → `primer-uso.md`
2. **Explorar DBeaver**: → `../02-HOW-TO-GUIDES/postgresql/conexion-dbeaver.md`
3. **Aprender SQL**: → `../03-CONCEPTS/sql-basico.md`

### **🛠️ SI QUIERES MÁS:**
- **Entorno completo**: → `configuracion-completa.md`
- **Solucionar problemas**: → `../02-HOW-TO-GUIDES/troubleshooting/`

---

## 🆘 **¿PROBLEMAS?**

### **🔴 Error común: Puerto ocupado**
```bash
# Ver qué usa el puerto 5432
sudo netstat -tlnp | grep 5432

# Detener servicio que use el puerto
sudo systemctl stop postgresql  # Si tienes PostgreSQL local
```

### **🔴 Error común: Docker no responde**
```bash
# Reiniciar Docker
sudo systemctl restart docker  # Linux
# O reinicia Docker Desktop en Windows/Mac
```

### **📞 MÁS AYUDA:**
- 🐛 **Errores específicos**: → `../02-HOW-TO-GUIDES/troubleshooting/errores-docker.md`
- 🔧 **Configuración avanzada**: → `../02-HOW-TO-GUIDES/postgresql/instalacion.md`

---

**🎉 ¡Felicitaciones! Has completado tu primera instalación exitosa.** 

**⏭️ Siguiente: [primer-uso.md](./primer-uso.md)**
