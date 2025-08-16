# Comandos Básicos de Linux para Principiantes 🐧

## 📁 Navegación por Directorios

### Comandos de Navegación
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

### Navegación Rápida
```bash
# Atajos útiles
cd ~/Desktop    # Ir al escritorio
cd ~/Documents  # Ir a documentos
cd ~/Downloads  # Ir a descargas

# Navegación relativa
cd ./subdirectorio    # Entrar en subdirectorio
cd ../otro_directorio # Subir y entrar en otro directorio
```

## 📄 Gestión de Archivos y Directorios

### Crear y Eliminar
```bash
# Crear directorios
mkdir nombre_directorio
mkdir -p ruta/compuesta/directorios  # Crear ruta completa

# Crear archivos vacíos
touch nombre_archivo.txt
touch archivo1.txt archivo2.txt archivo3.txt

# Eliminar archivos y directorios
rm nombre_archivo.txt           # Eliminar archivo
rm -f nombre_archivo.txt        # Forzar eliminación sin confirmar
rm -r nombre_directorio         # Eliminar directorio y contenido
rm -rf nombre_directorio        # Forzar eliminación recursiva
```

### Copiar y Mover
```bash
# Copiar archivos
cp archivo_origen.txt destino.txt
cp archivo.txt /ruta/destino/
cp -r directorio_origen/ directorio_destino/

# Mover/renombrar archivos
mv archivo_antiguo.txt archivo_nuevo.txt
mv archivo.txt /ruta/destino/
mv archivo.txt /ruta/destino/nuevo_nombre.txt
```

## 🔍 Búsqueda y Visualización

### Ver Contenido de Archivos
```bash
# Ver archivo completo
cat archivo.txt

# Ver archivo página por página
less archivo.txt
more archivo.txt

# Ver primeras líneas
head archivo.txt
head -n 20 archivo.txt    # Ver primeras 20 líneas

# Ver últimas líneas
tail archivo.txt
tail -n 20 archivo.txt    # Ver últimas 20 líneas
tail -f archivo.txt       # Seguir archivo en tiempo real
```

### Búsqueda
```bash
# Buscar archivos por nombre
find /ruta -name "nombre_archivo"
find . -name "*.txt"      # Buscar archivos .txt en directorio actual
find /home -type f -name "*.pdf"  # Buscar archivos PDF

# Buscar texto dentro de archivos
grep "texto_buscar" archivo.txt
grep -i "texto" archivo.txt    # Búsqueda sin distinguir mayúsculas
grep -r "texto" directorio/    # Búsqueda recursiva
```

## 👤 Permisos y Propiedad

### Ver y Cambiar Permisos
```bash
# Ver permisos detallados
ls -la

# Cambiar permisos
chmod 755 archivo.txt
chmod +x script.sh          # Hacer ejecutable
chmod -x archivo.txt        # Quitar permisos de ejecución

# Cambiar propietario
chown usuario:grupo archivo.txt
chown usuario archivo.txt
```

### Explicación de Permisos
```
-rw-r--r-- 1 usuario grupo archivo.txt
│ │ │ │ │  │ │      │      └── Nombre del archivo
│ │ │ │ │  │ │      └── Grupo propietario
│ │ │ │ │  │ └── Usuario propietario
│ │ │ │ │  └── Número de enlaces
│ │ │ │ └── Permisos para otros usuarios
│ │ │ └── Permisos para el grupo
│ │ └── Permisos para el propietario
│ └── Tipo de archivo (- = archivo, d = directorio)
```

## 💻 Comandos del Sistema

### Información del Sistema
```bash
# Ver información del sistema
uname -a
cat /etc/os-release

# Ver uso de disco
df -h
du -h archivo_o_directorio

# Ver procesos
ps aux
top
htop          # Si está instalado

# Ver memoria
free -h
```

### Gestión de Paquetes (Ubuntu/Debian)
```bash
# Actualizar lista de paquetes
sudo apt update

# Instalar paquetes
sudo apt install nombre_paquete

# Actualizar sistema
sudo apt upgrade

# Buscar paquetes
apt search nombre_paquete
```

## 🚀 Trucos y Consejos

### Atajos de Teclado
```bash
# En la terminal
Ctrl + C          # Cancelar comando actual
Ctrl + L          # Limpiar pantalla
Ctrl + R          # Buscar en historial
Ctrl + A          # Ir al inicio de la línea
Ctrl + E          # Ir al final de la línea
Ctrl + U          # Borrar desde cursor hasta inicio
Ctrl + K          # Borrar desde cursor hasta final
Tab               # Autocompletar
```

### Variables de Entorno
```bash
# Ver variables de entorno
env
echo $PATH
echo $HOME

# Crear alias personalizados
alias ll='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
```

### Historial y Comandos
```bash
# Ver historial
history
history 10        # Ver últimos 10 comandos

# Ejecutar comando del historial
!n                # Ejecutar comando número n
!!                # Ejecutar último comando
!$                # Usar último argumento del comando anterior
```

## 📚 Comandos Avanzados Básicos

### Redirección
```bash
# Redirigir salida a archivo
ls > archivo_lista.txt
echo "texto" >> archivo.txt    # Agregar al final

# Redirigir entrada
cat < archivo.txt

# Tuberías (pipes)
ls | grep "archivo"
ps aux | grep "proceso"
```

### Trabajo en Segundo Plano
```bash
# Ejecutar comando en segundo plano
comando &

# Ver trabajos en segundo plano
jobs

# Traer trabajo al primer plano
fg %1

# Enviar trabajo al segundo plano
bg %1
```

## 🆘 Ayuda y Documentación

### Obtener Ayuda
```bash
# Ayuda de comandos
comando --help
comando -h

# Manual de comandos
man comando
man -k palabra_clave    # Buscar en manuales

# Información de comandos
info comando
whatis comando
```

## 🎯 Ejercicios Prácticos

### Para Practicar
1. **Navegación**: Crea una estructura de directorios y navega entre ellos
2. **Archivos**: Crea, copia, mueve y elimina archivos
3. **Búsqueda**: Busca archivos específicos en tu sistema
4. **Permisos**: Cambia permisos de archivos y directorios
5. **Redirección**: Guarda la salida de comandos en archivos

### Comandos de Ejemplo
```bash
# Crear estructura de práctica
mkdir -p ~/practica/{documentos,imagenes,scripts}
cd ~/practica
touch documentos/nota.txt
echo "Hola mundo" > documentos/nota.txt
cp documentos/nota.txt imagenes/
ls -la
find . -name "*.txt"
```

---

## 💡 Consejos Finales

- **Siempre verifica** antes de eliminar archivos importantes
- **Usa tab** para autocompletar nombres de archivos y comandos
- **Lee los mensajes de error** - suelen dar pistas útiles
- **Practica en un entorno seguro** antes de usar comandos destructivos
- **Mantén tu terminal organizada** con alias útiles
- **Aprende un comando nuevo cada día**

¡Recuerda que la práctica hace al maestro! 🚀 