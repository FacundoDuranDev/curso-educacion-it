# 🐧 COMANDOS BÁSICOS DE LINUX

## 📁 **NAVEGACIÓN POR DIRECTORIOS**

### **Comandos de Navegación:**
```bash
# Ver el directorio actual
pwd

# Cambiar de directorio
cd nombre_directorio
cd ..          # Subir un nivel
cd ~           # Ir al directorio home del usuario
cd /           # Ir al directorio raíz
cd -           # Volver al directorio anterior

# Listar archivos y directorios
ls              # Lista básica
ls -la          # Lista detallada con archivos ocultos
ls -lh          # Lista con tamaños legibles
ls -lt          # Lista ordenada por fecha
ls -R           # Lista recursiva (incluye subdirectorios)
```

### **Navegación Rápida:**
```bash
# Atajos útiles
cd ~/Desktop    # Ir al escritorio
cd ~/Documents  # Ir a documentos
cd ~/Downloads  # Ir a descargas
```

---

## 📄 **GESTIÓN DE ARCHIVOS**

### **Ver Contenido de Archivos:**
```bash
cat archivo.txt           # Mostrar contenido completo
head archivo.txt          # Mostrar primeras 10 líneas
head -n 20 archivo.txt    # Mostrar primeras 20 líneas
tail archivo.txt          # Mostrar últimas 10 líneas
tail -f archivo.log       # Seguir archivo en tiempo real
less archivo.txt          # Navegar por archivo (q para salir)
```

### **Buscar en Archivos:**
```bash
grep "texto" archivo.txt              # Buscar texto en archivo
grep -i "texto" archivo.txt           # Búsqueda sin distinción de mayúsculas
grep -r "texto" directorio/           # Buscar recursivamente
grep -n "texto" archivo.txt           # Mostrar número de línea
```

---

## 🔧 **GESTIÓN DE PROCESOS**

### **Ver Procesos:**
```bash
ps                    # Procesos actuales
ps aux                # Todos los procesos del sistema
top                   # Monitor de procesos en tiempo real
htop                  # Versión mejorada de top (si está instalado)
```

### **Gestionar Procesos:**
```bash
kill PID              # Terminar proceso por ID
kill -9 PID           # Forzar terminación
killall nombre        # Terminar todos los procesos con ese nombre
```

---

## 💾 **GESTIÓN DE DISCO**

### **Espacio en Disco:**
```bash
df -h                 # Espacio disponible en discos
du -h directorio/     # Tamaño de directorio
du -sh *              # Tamaño de archivos/directorios en ubicación actual
```

### **Buscar Archivos:**
```bash
find /ruta -name "archivo.txt"        # Buscar por nombre
find /ruta -type f -name "*.txt"      # Buscar solo archivos
find /ruta -size +100M                # Buscar archivos >100MB
find /ruta -mtime -7                  # Archivos modificados en últimos 7 días
```

---

## 📦 **GESTIÓN DE PAQUETES**

### **Ubuntu/Debian (apt):**
```bash
sudo apt update                       # Actualizar lista de paquetes
sudo apt upgrade                      # Actualizar paquetes instalados
sudo apt install paquete             # Instalar paquete
sudo apt remove paquete              # Desinstalar paquete
sudo apt search "texto"              # Buscar paquetes
```

### **CentOS/RHEL (yum/dnf):**
```bash
sudo yum update                       # Actualizar paquetes
sudo yum install paquete             # Instalar paquete
sudo yum remove paquete              # Desinstalar paquete
sudo yum search "texto"              # Buscar paquetes
```

---

## 🌐 **RED Y CONECTIVIDAD**

### **Conectividad:**
```bash
ping google.com                       # Probar conectividad
curl -I https://google.com           # Ver headers HTTP
wget https://ejemplo.com/archivo.zip # Descargar archivo
```

### **Puertos y Conexiones:**
```bash
netstat -tulpn                       # Ver puertos abiertos
ss -tulpn                            # Versión moderna de netstat
lsof -i :8080                        # Ver qué usa el puerto 8080
```

---

## 🗜️ **COMPRESIÓN Y ARCHIVOS**

### **Comprimir/Descomprimir:**
```bash
# ZIP
zip -r archivo.zip directorio/       # Comprimir directorio
unzip archivo.zip                    # Descomprimir

# TAR
tar -czf archivo.tar.gz directorio/  # Comprimir con gzip
tar -xzf archivo.tar.gz             # Descomprimir

# TAR con bzip2
tar -cjf archivo.tar.bz2 directorio/ # Comprimir con bzip2
tar -xjf archivo.tar.bz2            # Descomprimir
```

---

## 👤 **PERMISOS Y USUARIOS**

### **Cambiar Permisos:**
```bash
chmod 755 archivo                    # Permisos: rwxr-xr-x
chmod +x script.sh                   # Hacer ejecutable
chmod -x archivo                     # Quitar ejecución
chown usuario:grupo archivo          # Cambiar propietario
```

### **Hacer Archivos Modificables (Especialmente Jupyter Notebooks):**
```bash
# Hacer un archivo específico modificable
chmod 777 archivo.ipynb

# Hacer todos los notebooks modificables en un directorio
chmod 777 *.ipynb

# Hacer todos los archivos de un directorio modificables recursivamente
chmod -R 777 directorio/

# Ejemplo específico para nuestros tutoriales de Spark
chmod 777 jupyter/notebook/spark-tutorials/*/*.ipynb
chmod 777 spark-tutorials/*/*.ipynb
```

### **Problema Común: Archivos de Solo Lectura**
```bash
# Verificar permisos actuales
ls -la archivo.ipynb

# Si muestra: -r--r--r-- (solo lectura)
# Solucionarlo con:
chmod 644 archivo.ipynb    # Lectura y escritura para propietario
# O más permisivo:
chmod 777 archivo.ipynb    # Lectura, escritura y ejecución para todos
```

### **Script para Hacer Todos los Notebooks Modificables:**
```bash
#!/bin/bash
# Script para hacer todos los notebooks modificables
echo "🔧 Haciendo notebooks modificables..."

# Hacer notebooks modificables en Jupyter
find jupyter/notebook/spark-tutorials/ -name "*.ipynb" -exec chmod 777 {} \;

# Hacer notebooks modificables en spark-tutorials
find spark-tutorials/ -name "*.ipynb" -exec chmod 777 {} \;

# Hacer scripts Python ejecutables
find . -name "*.py" -exec chmod +x {} \;

echo "✅ Todos los archivos ahora son modificables"
```

### **Información del Sistema:**
```bash
whoami                               # Usuario actual
id                                   # ID del usuario y grupos
groups                               # Grupos del usuario
uname -a                             # Información del sistema
```

---

## 🔍 **COMANDOS ÚTILES PARA EL CURSO**

### **Para Docker:**
```bash
docker ps                           # Ver contenedores corriendo
docker ps -a                        # Ver todos los contenedores
docker images                       # Ver imágenes
docker logs contenedor              # Ver logs de contenedor
```

### **Para Git:**
```bash
git status                          # Estado del repositorio
git log --oneline                   # Historial compacto
git diff                            # Ver cambios
git branch                          # Ver ramas
```

---

## 💡 **TIPS Y TRUCOS**

### **Atajos de Teclado:**
- `Ctrl + C`: Interrumpir comando actual
- `Ctrl + D`: Cerrar terminal
- `Ctrl + L`: Limpiar pantalla
- `Ctrl + R`: Buscar en historial
- `Tab`: Autocompletar
- `↑/↓`: Navegar historial

### **Comandos Útiles:**
```bash
history                             # Ver historial de comandos
!!                                  # Repetir último comando
!n                                  # Ejecutar comando número n del historial
alias ll='ls -la'                   # Crear alias
```

---

**🎯 ¡Estos comandos te ayudarán a navegar y gestionar el sistema durante el curso!**
