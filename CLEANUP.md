# 🧹 Limpieza Completa de Docker - Eliminar Todo Residuo

## ⚠️ ADVERTENCIA IMPORTANTE
**Este proceso eliminará TODOS los datos, contenedores, imágenes, volúmenes y redes de Docker. Solo usar cuando quieras limpiar completamente el sistema Docker y empezar desde cero.**

---

## 🎯 **¿Cuándo usar esta limpieza completa?**

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

## 🔧 **LIMPIEZA PASO A PASO (Más Segura)**

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

# Ver uso de espacio
docker system df
```

### **Paso 2: Detener todos los contenedores**
```bash
# Detener todos los contenedores corriendo
docker stop $(docker ps -q)

# O si prefieres ser más específico
docker ps -q | xargs -r docker stop
```

### **Paso 3: Eliminar contenedores**
```bash
# Eliminar todos los contenedores
docker rm $(docker ps -aq)

# O si prefieres ser más específico
docker ps -aq | xargs -r docker rm
```

### **Paso 4: Eliminar imágenes**
```bash
# Eliminar todas las imágenes
docker rmi $(docker images -aq)

# O si prefieres ser más específico
docker images -aq | xargs -r docker rmi
```

### **Paso 5: Eliminar volúmenes**
```bash
# Eliminar todos los volúmenes
docker volume rm $(docker volume ls -q)

# O si prefieres ser más específico
docker volume ls -q | xargs -r docker volume rm
```

### **Paso 6: Eliminar redes**
```bash
# Eliminar redes personalizadas (no las del sistema)
docker network ls --filter type=custom -q | xargs -r docker network rm

# O eliminar todas las redes (¡CUIDADO!)
docker network ls -q | xargs -r docker network rm
```

### **Paso 7: Limpieza general del sistema**
```bash
# Limpiar todo el sistema Docker
docker system prune -a --volumes --force
```

---

## 🧽 **LIMPIEZA ESPECÍFICA POR TIPO**

### **Limpiar solo contenedores**
```bash
# Eliminar contenedores detenidos
docker container prune -f

# Eliminar contenedores huérfanos
docker container prune -f --filter "until=24h"
```

### **Limpiar solo imágenes**
```bash
# Eliminar imágenes no utilizadas
docker image prune -a -f

# Eliminar imágenes más antiguas de 24 horas
docker image prune -a -f --filter "until=24h"
```

### **Limpiar solo volúmenes**
```bash
# Eliminar volúmenes no utilizados
docker volume prune -f

# Eliminar volúmenes huérfanos
docker volume prune -f --filter "label=com.docker.compose.project"
```

### **Limpiar solo redes**
```bash
# Eliminar redes no utilizadas
docker network prune -f

# Eliminar redes personalizadas
docker network prune -f --filter "type=custom"
```

### **Limpiar cache de construcción**
```bash
# Limpiar cache de construcción
docker builder prune -a -f

# Limpiar cache más antiguo de 24 horas
docker builder prune -a -f --filter "until=24h"
```

---

## 🔄 **REINICIO COMPLETO DEL SISTEMA DOCKER**

### **Paso 1: Reiniciar el servicio Docker**
```bash
# Linux (systemd)
sudo systemctl restart docker

# Linux (init.d)
sudo service docker restart

# macOS
osascript -e 'quit app "Docker"'
open -a Docker

# Windows (PowerShell como administrador)
Restart-Service docker

# O reiniciar la máquina completa
sudo reboot
```

### **Paso 2: Verificar que Docker esté funcionando**
```bash
# Verificar estado de Docker
docker version
docker info

# Verificar que no hay residuos
docker ps -a
docker images
docker volume ls
docker network ls
```

---

## 🎯 **LIMPIEZA POR PROYECTO ESPECÍFICO**

### **Si quieres limpiar solo un proyecto específico**
```bash
# Ir al directorio del proyecto
cd /ruta/al/proyecto

# Detener y eliminar solo ese proyecto
docker-compose down -v --remove-orphans

# Eliminar imágenes específicas del proyecto
docker images | grep "nombre-del-proyecto" | awk '{print $3}' | xargs -r docker rmi
```

### **Limpiar por etiquetas**
```bash
# Eliminar contenedores con etiquetas específicas
docker ps -a --filter "label=com.docker.compose.project=nombre-proyecto" -q | xargs -r docker rm

# Eliminar imágenes con etiquetas específicas
docker images --filter "label=com.docker.compose.project=nombre-proyecto" -q | xargs -r docker rmi
```

---

## 📋 **SCRIPT DE LIMPIEZA UNIVERSAL**

### **Crear archivo: `cleanup-docker-universal.sh`**
```bash
#!/bin/bash

echo "🧹 INICIANDO LIMPIEZA COMPLETA UNIVERSAL DE DOCKER..."
echo "⚠️  ESTO ELIMINARÁ TODOS LOS DATOS DE DOCKER EN EL SISTEMA!"

read -p "¿Estás seguro de que quieres continuar? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Limpieza cancelada"
    exit 1
fi

echo "🔍 Analizando estado actual de Docker..."
echo "Contenedores: $(docker ps -aq | wc -l)"
echo "Imágenes: $(docker images -aq | wc -l)"
echo "Volúmenes: $(docker volume ls -q | wc -l)"
echo "Redes: $(docker network ls -q | wc -l)"

echo "🛑 Deteniendo todos los contenedores..."
docker stop $(docker ps -q) 2>/dev/null || true

echo "🗑️  Eliminando contenedores..."
docker rm $(docker ps -aq) 2>/dev/null || true

echo "🖼️  Eliminando imágenes..."
docker rmi $(docker images -aq) 2>/dev/null || true

echo "💾 Eliminando volúmenes..."
docker volume rm $(docker volume ls -q) 2>/dev/null || true

echo "🌐 Eliminando redes personalizadas..."
docker network ls --filter type=custom -q | xargs -r docker network rm 2>/dev/null || true

echo "🧽 Limpieza final del sistema..."
docker system prune -a --volumes --force

echo "✅ ¡LIMPIEZA COMPLETA UNIVERSAL FINALIZADA!"
echo "🚀 Tu sistema Docker está completamente limpio y listo para empezar desde cero"
```

### **Dar permisos y ejecutar**
```bash
# Dar permisos de ejecución
chmod +x cleanup-docker-universal.sh

# Ejecutar el script
./cleanup-docker-universal.sh
```

---

## 🎯 **COMANDOS RÁPIDOS UNIVERSALES**

### **Limpieza rápida completa**
```bash
# Todo en una línea - ¡NUCLEAR!
docker stop $(docker ps -q) 2>/dev/null; docker rm $(docker ps -aq) 2>/dev/null; docker rmi $(docker images -aq) 2>/dev/null; docker volume rm $(docker volume ls -q) 2>/dev/null; docker system prune -a --volumes --force
```

### **Limpieza solo de contenedores e imágenes**
```bash
# Solo contenedores e imágenes (mantiene volúmenes)
docker stop $(docker ps -q) 2>/dev/null; docker rm $(docker ps -aq) 2>/dev/null; docker rmi $(docker images -aq) 2>/dev/null
```

### **Limpieza solo de volúmenes**
```bash
# Solo volúmenes (mantiene contenedores e imágenes)
docker volume rm $(docker volume ls -q) 2>/dev/null
```

---

## 📝 **NOTAS IMPORTANTES**

### **¿Qué se pierde con la limpieza?**
- 🗑️ **Todos los contenedores** de cualquier proyecto
- 🗑️ **Todas las imágenes** personalizadas
- 🗑️ **Todos los volúmenes** de datos
- 🗑️ **Todas las redes** personalizadas
- 🗑️ **Todo el cache** de construcción
- 🗑️ **Toda la configuración** personalizada

### **¿Qué se mantiene?**
- ✅ **Docker Engine** instalado
- ✅ **Configuración base** de Docker
- ✅ **Código fuente** de tus proyectos
- ✅ **Archivos de configuración** (docker-compose.yml, Dockerfiles)

### **Tiempo estimado de reconstrucción**
- ⏱️ **Depende del proyecto**: 5 minutos a 1 hora
- ⏱️ **Primera descarga**: Puede tomar más tiempo
- ⏱️ **Configuración**: Varía según complejidad

---

## 🆘 **SI ALGO SALE MAL**

### **Problema: Docker no responde**
```bash
# Reiniciar Docker completamente
sudo systemctl restart docker

# O reiniciar la máquina si es necesario
sudo reboot
```

### **Problema: Permisos denegados**
```bash
# Ejecutar con sudo
sudo docker system prune -a --volumes --force

# O agregar usuario al grupo docker
sudo usermod -aG docker $USER
# Luego cerrar sesión y volver a entrar
```

### **Problema: Volúmenes no se eliminan**
```bash
# Forzar eliminación de volúmenes
sudo rm -rf /var/lib/docker/volumes/*

# O reiniciar Docker después de eliminar
sudo systemctl restart docker
```

### **Problema: Espacio en disco no se libera**
```bash
# Verificar espacio liberado
df -h

# Limpiar cache del sistema
sudo apt clean  # Ubuntu/Debian
sudo yum clean all  # CentOS/RHEL
```

---

## 🎉 **¡LISTO PARA EMPEZAR DESDE CERO!**

Después de la limpieza completa universal, tu sistema Docker estará completamente limpio y podrás:

1. **Instalar cualquier proyecto** sin conflictos
2. **Empezar desde cero** con cualquier configuración
3. **Resolver problemas** de versiones o dependencias
4. **Liberar espacio** en disco
5. **Tener un sistema Docker** como recién instalado

**¡Recuerda: La limpieza universal es tu amiga cuando quieres un Docker completamente limpio!**

---

## 🔍 **VERIFICACIÓN POST-LIMPIEZA**

### **Comandos para verificar que todo esté limpio**
```bash
# Verificar contenedores (debería estar vacío)
docker ps -a

# Verificar imágenes (solo las del sistema)
docker images

# Verificar volúmenes (debería estar vacío)
docker volume ls

# Verificar redes (solo las del sistema)
docker network ls

# Verificar uso de espacio
docker system df
```

**Resultado esperado**: Solo deberías ver contenedores, imágenes y redes del sistema Docker base, nada personalizado.
