# 🧹 LIMPIEZA COMPLETA DE DOCKER

## ⚠️ **ADVERTENCIA IMPORTANTE**
**Este proceso eliminará TODOS los datos, contenedores, imágenes, volúmenes y redes de Docker. Solo usar cuando quieras limpiar completamente el sistema Docker y empezar desde cero.**

---

## 🎯 **¿CUÁNDO USAR ESTA LIMPIEZA COMPLETA?**

- ✅ **Primera vez** configurando Docker en el sistema
- ✅ **Conflictos** entre diferentes proyectos Docker
- ✅ **Problemas** que no se resuelven con limpieza normal
- ✅ **Cambios importantes** en la versión de Docker
- ✅ **Limpieza** del sistema Docker después de pruebas
- ✅ **Eliminar residuos** de proyectos anteriores
- ✅ **Liberar espacio** en disco
- ✅ **Resolver problemas** de permisos o configuración

---

## 🚀 **LIMPIEZA COMPLETA EN UN SOLO COMANDO**

### **Opción Nuclear: Eliminar TODO de Docker**
```bash
# ¡ATENCIÓN! Esto elimina ABSOLUTAMENTE TODO de Docker
docker system prune -a --volumes --force
```

**¿Qué elimina este comando?**
- 🗑️ **Contenedores**: Todos los contenedores (corriendo y detenidos)
- 🗑️ **Imágenes**: Todas las imágenes Docker (incluyendo las del sistema)
- 🗑️ **Volúmenes**: Todos los volúmenes de datos
- 🗑️ **Redes**: Todas las redes personalizadas
- 🗑️ **Build cache**: Todo el cache de construcción
- 🗑️ **Containers**: Todos los contenedores huérfanos

---

## 🔧 **LIMPIEZA PASO A PASO (MÁS SEGURA)**

### **Paso 1: Ver qué hay en el sistema**
```bash
# Ver todos los contenedores
docker ps -a

# Ver todas las imágenes
docker images -a

# Ver todos los volúmenes
docker volume ls

# Ver todas las redes
docker network ls

# Ver espacio usado
docker system df
```

### **Paso 2: Detener contenedores del curso**
```bash
# Detener servicios del curso
docker-compose down

# O detener todos los contenedores
docker stop $(docker ps -q)
```

### **Paso 3: Eliminar contenedores**
```bash
# Eliminar todos los contenedores
docker rm $(docker ps -aq)

# O eliminar contenedores específicos
docker rm educacionit-metastore-1
docker rm educacionit-master-1
```

### **Paso 4: Eliminar imágenes**
```bash
# Eliminar todas las imágenes
docker rmi $(docker images -q)

# O eliminar imágenes específicas
docker rmi hadoop-hive-spark-base
docker rmi hadoop-hive-spark-master
```

### **Paso 5: Eliminar volúmenes**
```bash
# Eliminar todos los volúmenes
docker volume rm $(docker volume ls -q)

# O eliminar volúmenes específicos
docker volume rm curso-educacion-it_postgres_data
```

### **Paso 6: Eliminar redes**
```bash
# Eliminar redes personalizadas
docker network rm $(docker network ls -q --filter type=custom)
```

### **Paso 7: Limpiar cache de construcción**
```bash
# Eliminar cache de construcción
docker builder prune -a --force
```

---

## 🎯 **LIMPIEZA SELECTIVA (RECOMENDADA)**

### **Solo contenedores del curso:**
```bash
# Detener y eliminar contenedores del curso
docker-compose down -v

# Eliminar imágenes del curso
docker rmi hadoop-hive-spark-base
docker rmi hadoop-hive-spark-master
docker rmi hadoop-hive-spark-worker
docker rmi hadoop-hive-spark-jupyter
docker rmi hadoop-hive-spark-jupyterlab
```

### **Solo contenedores detenidos:**
```bash
# Eliminar solo contenedores detenidos
docker container prune

# Eliminar solo imágenes no utilizadas
docker image prune

# Eliminar solo volúmenes no utilizados
docker volume prune

# Eliminar solo redes no utilizadas
docker network prune
```

---

## 📊 **VERIFICAR LIMPIEZA**

### **Después de la limpieza:**
```bash
# Verificar que todo esté limpio
docker ps -a          # Debería estar vacío
docker images         # Debería estar vacío
docker volume ls      # Debería estar vacío
docker network ls     # Solo redes por defecto

# Ver espacio liberado
docker system df
```

### **Verificar espacio en disco:**
```bash
# Ver espacio total
df -h

# Ver espacio de Docker específicamente
sudo du -sh /var/lib/docker/
```

---

## 🔄 **RECONSTRUIR DESPUÉS DE LIMPIEZA**

### **Reconstruir el entorno del curso:**
```bash
# Volver al directorio del proyecto
cd /ruta/a/curso-educacion-it

# Construir todo desde cero
make build

# Levantar servicios
make up

# Verificar que todo funcione
make status
```

---

## 💡 **COMANDOS ÚTILES**

### **Alias para limpieza rápida:**
```bash
# Agregar a ~/.bashrc o ~/.zshrc
alias docker-clean-all='docker system prune -a --volumes --force'
alias docker-clean-containers='docker container prune -f'
alias docker-clean-images='docker image prune -a -f'
alias docker-clean-volumes='docker volume prune -f'
alias docker-clean-networks='docker network prune -f'
```

### **Script de limpieza personalizado:**
```bash
#!/bin/bash
echo "🧹 Limpiando Docker..."
docker-compose down -v
docker system prune -a --volumes --force
echo "✅ Limpieza completada"
echo "🔨 Reconstruyendo entorno..."
make
echo "✅ Entorno reconstruido"
```

---

## ⚠️ **CONSIDERACIONES IMPORTANTES**

### **Antes de limpiar:**
- ✅ **Hacer backup** de datos importantes
- ✅ **Documentar** configuraciones personalizadas
- ✅ **Verificar** que no hay otros proyectos usando Docker
- ✅ **Notificar** a otros usuarios del sistema

### **Después de limpiar:**
- ✅ **Reconstruir** el entorno del curso
- ✅ **Verificar** que todo funcione correctamente
- ✅ **Actualizar** documentación si es necesario

---

**🎯 ¡Usa esta guía cuando necesites empezar completamente desde cero!**
