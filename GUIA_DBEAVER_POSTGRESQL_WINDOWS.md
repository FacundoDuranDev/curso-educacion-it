# 🔌 Guía de Conexión DBeaver a PostgreSQL desde Windows

## 📋 **Resumen**
Esta guía te ayudará a conectar DBeaver a tu base de datos PostgreSQL que está corriendo en Docker, desde un sistema Windows. Incluye soluciones a los problemas más comunes.

---

## 🎯 **Objetivo**
- ✅ Instalar DBeaver en Windows
- ✅ Configurar conexión a PostgreSQL
- ✅ Resolver problemas comunes de conexión
- ✅ Conectar a la base de datos `educacionit`

---

## 🔧 **Prerrequisitos**
- ✅ PostgreSQL corriendo en Docker (puerto 5432)
- ✅ Windows 10/11
- ✅ Conexión a internet para descargar DBeaver

---

## 📥 **Paso 1: Descargar e Instalar DBeaver**

### **1.1 Descargar DBeaver**
- Ve a: [https://dbeaver.io/download/](https://dbeaver.io/download/)
- Selecciona **Windows x64 Installer**
- Descarga el archivo `.exe`

### **1.2 Instalar DBeaver**
- Ejecuta el archivo `.exe` descargado
- Sigue el asistente de instalación
- **Recomendación:** Instalar para todos los usuarios
- **Recomendación:** Crear acceso directo en escritorio

---

## 🗄️ **Paso 2: Configurar Conexión a PostgreSQL**

### **2.1 Abrir DBeaver**
- Ejecuta DBeaver desde el menú inicio o escritorio
- Cierra el asistente de bienvenida si aparece

### **2.2 Crear Nueva Conexión**
- Haz clic en **"Nueva Conexión"** (icono de enchufe +)
- O ve a **Archivo → Nueva → Conexión**

### **2.3 Seleccionar Base de Datos**
- En la lista de bases de datos, selecciona **PostgreSQL**
- Haz clic en **"Siguiente"**

### **2.4 Configurar Parámetros de Conexión**

#### **Configuración Básica:**
```
Servidor: localhost
Puerto: 5432
Base de datos: educacionit
Usuario: admin
Contraseña: admin123
```

#### **Configuración Avanzada (opcional):**
- **Nombre de conexión:** `EducacionIT - PostgreSQL`
- **Descripción:** `Base de datos del curso Data Engineering`

### **2.5 Probar Conexión**
- Haz clic en **"Probar Conexión"**
- Deberías ver: ✅ **"Conectado"**
- Si hay error, revisa la sección de problemas

### **2.6 Finalizar**
- Haz clic en **"Finalizar"**
- La conexión aparecerá en el panel izquierdo

---

## 🚨 **Problemas Comunes y Soluciones**

### **Problema 1: "Connection refused" o "Connection timed out"**

#### **Síntomas:**
```
Error: Connection refused
Error: Connection timed out
Error: No route to host
```

#### **Causas posibles:**
1. **PostgreSQL no está corriendo**
2. **Puerto bloqueado por firewall**
3. **Docker no está funcionando**
4. **Puerto incorrecto**

#### **Soluciones:**

**Verificar que PostgreSQL esté corriendo:**
```bash
# En tu terminal (Git Bash, WSL, o PowerShell)
docker ps | grep metastore
```

**Verificar puerto:**
```bash
# Verificar que el puerto 5432 esté abierto
netstat -an | findstr 5432
```

**Reiniciar PostgreSQL:**
```bash
docker-compose restart metastore
```

**Verificar firewall de Windows:**
1. Busca "Firewall de Windows Defender" en inicio
2. Ve a "Configuración avanzada"
3. Verifica que el puerto 5432 esté permitido

---

### **Problema 2: "Authentication failed" o "Invalid password"**

#### **Síntomas:**
```
Error: FATAL: password authentication failed for user "admin"
Error: Invalid username/password
```

#### **Causas posibles:**
1. **Contraseña incorrecta**
2. **Usuario no existe**
3. **Permisos insuficientes**

#### **Soluciones:**

**Verificar credenciales:**
```bash
# Conectarse como postgres y verificar usuario admin
docker exec -it educacionit-metastore-1 psql -U postgres -c "\du"
```

**Recrear usuario admin:**
```bash
# Eliminar y recrear usuario
docker exec -it educacionit-metastore-1 psql -U postgres -c "DROP USER IF EXISTS admin;"
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE USER admin WITH PASSWORD 'admin123';"
docker exec -it educacionit-metastore-1 psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;"
```

**Verificar base de datos:**
```bash
# Verificar que educacionit existe
docker exec -it educacionit-metastore-1 psql -U postgres -c "\l"
```

---

### **Problema 3: "Database does not exist"**

#### **Síntomas:**
```
Error: FATAL: database "educacionit" does not exist
```

#### **Causas posibles:**
1. **Base de datos no creada**
2. **Nombre incorrecto**
3. **PostgreSQL recién iniciado sin datos**

#### **Soluciones:**

**Crear base de datos:**
```bash
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;"
```

**Verificar bases de datos existentes:**
```bash
docker exec -it educacionit-metastore-1 psql -U postgres -c "\l"
```

**Recrear todo desde cero:**
```bash
# Seguir la guía de instalación completa
./scripts/setup_database.sh
```

---

### **Problema 4: "Driver not found" o "PostgreSQL driver missing"**

#### **Síntomas:**
```
Error: Driver not found
Error: PostgreSQL driver missing
```

#### **Causas posibles:**
1. **DBeaver no descargó el driver**
2. **Driver corrupto**
3. **Versión incompatible**

#### **Soluciones:**

**Descargar driver manualmente:**
1. En DBeaver, ve a **Herramientas → Administrador de Drivers**
2. Selecciona **PostgreSQL**
3. Haz clic en **"Descargar"**
4. Reinicia DBeaver

**Verificar versión del driver:**
- **Recomendado:** PostgreSQL 42.x.x
- **Mínimo:** PostgreSQL 42.2.0

**Reinstalar DBeaver:**
1. Desinstala DBeaver desde Panel de Control
2. Elimina carpeta: `C:\Users\[Usuario]\AppData\Roaming\DBeaverData`
3. Descarga e instala la última versión

---

### **Problema 5: "SSL connection required"**

#### **Síntomas:**
```
Error: SSL connection required
Error: SSL is required
```

#### **Causas posibles:**
1. **PostgreSQL configurado para requerir SSL**
2. **Configuración de seguridad**

#### **Soluciones:**

**Configurar SSL en DBeaver:**
1. En la configuración de conexión, ve a **SSL**
2. Marca **"Use SSL"**
3. Selecciona **"Require"** o **"Allow"**

**O deshabilitar SSL en PostgreSQL (menos seguro):**
```bash
# Editar postgresql.conf
docker exec -it educacionit-metastore-1 bash
echo "ssl = off" >> /var/lib/postgresql/data/postgresql.conf
```

---

### **Problema 6: "Connection pool exhausted"**

#### **Síntomas:**
```
Error: Connection pool exhausted
Error: Too many connections
```

#### **Causas posibles:**
1. **Demasiadas conexiones simultáneas**
2. **Conexiones no cerradas**
3. **Límite de conexiones alcanzado**

#### **Soluciones:**

**Cerrar conexiones no utilizadas:**
1. En DBeaver, haz clic derecho en la conexión
2. Selecciona **"Desconectar"**
3. Vuelve a conectar

**Verificar conexiones activas:**
```bash
docker exec -it educacionit-metastore-1 psql -U postgres -c "SELECT * FROM pg_stat_activity;"
```

**Reiniciar PostgreSQL:**
```bash
docker-compose restart metastore
```

---

## 🔧 **Configuración Avanzada de DBeaver**

### **Configuración de Conexión:**

#### **General:**
- **Nombre:** `EducacionIT - PostgreSQL`
- **Comentarios:** `Base de datos del curso Data Engineering`

#### **Driver:**
- **Driver:** `PostgreSQL`
- **URL:** `jdbc:postgresql://localhost:5432/educacionit`

#### **Conexión:**
- **Servidor:** `localhost`
- **Puerto:** `5432`
- **Base de datos:** `educacionit`
- **Usuario:** `admin`
- **Contraseña:** `admin123`

#### **SSH (si usas WSL o máquina remota):**
- **Usar SSH:** `No` (para conexión local)

#### **SSL:**
- **Usar SSL:** `No` (para desarrollo local)

#### **Opciones:**
- **Auto-commit:** `Sí`
- **Read-only:** `No`
- **Isolation level:** `Read Committed`

---

## 📊 **Verificar Conexión Exitosa**

### **Paso 1: Conectar**
- Haz clic en **"Probar Conexión"**
- Deberías ver: ✅ **"Conectado"**

### **Paso 2: Explorar Base de Datos**
- Expande tu conexión en el panel izquierdo
- Expande **"educacionit"**
- Expande **"Esquemas" → "public"**
- Deberías ver **"Tablas"** con 10 tablas

### **Paso 3: Ejecutar Consulta de Prueba**
```sql
-- Consulta de prueba
SELECT 
    'clientes' as tabla, COUNT(*) as registros FROM clientes
UNION ALL
SELECT 'sucursales', COUNT(*) FROM sucursales
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
ORDER BY tabla;
```

**Resultado esperado:**
```
   tabla    | registros 
------------+-----------
 clientes   |      3407
 productos  |       292
 sucursales |        31
```

---

## 🎨 **Personalización de DBeaver**

### **Tema y Colores:**
1. **Herramientas → Preferencias**
2. **Apariencia → Colores y Fuentes**
3. **Selecciona tema:** `Dark` o `Light`

### **Editor SQL:**
1. **Herramientas → Preferencias**
2. **Editors → SQL Editor**
3. **Configura:**
   - **Auto-completion:** `Sí`
   - **Auto-save:** `Sí`
   - **Syntax highlighting:** `Sí`

### **Resultados de Consulta:**
1. **Herramientas → Preferencias**
2. **Editors → Data Editor**
3. **Configura:**
   - **Max rows:** `1000`
   - **Auto-refresh:** `No`

---

## 🆘 **Comandos de Emergencia**

### **Si DBeaver no responde:**
1. **Cerrar DBeaver** (Ctrl+Alt+Del si es necesario)
2. **Eliminar archivos temporales:**
   ```
   C:\Users\[Usuario]\AppData\Local\Temp\dbeaver*
   ```
3. **Reiniciar DBeaver**

### **Si PostgreSQL no responde:**
```bash
# Reiniciar PostgreSQL
docker-compose restart metastore

# Verificar estado
docker ps | grep metastore

# Ver logs
docker logs educacionit-metastore-1
```

### **Si la conexión se pierde:**
1. **Desconectar** la conexión en DBeaver
2. **Esperar 10 segundos**
3. **Reconectar**

---

## 📚 **Comandos Útiles en DBeaver**

### **Navegación:**
- **F5:** Ejecutar consulta
- **Ctrl+Shift+F5:** Ejecutar script completo
- **Ctrl+Shift+E:** Exportar resultados
- **Ctrl+D:** Duplicar línea

### **Editor:**
- **Ctrl+Space:** Auto-completar
- **Ctrl+/:** Comentar/descomentar
- **Ctrl+Shift+Up/Down:** Mover línea

### **Base de Datos:**
- **F4:** Editar objeto
- **Ctrl+Shift+Delete:** Eliminar objeto
- **F7:** Ver datos de tabla

---

## 🎯 **Checklist de Verificación**

### **✅ Instalación:**
- [ ] DBeaver descargado e instalado
- [ ] PostgreSQL corriendo en Docker
- [ ] Puerto 5432 accesible

### **✅ Conexión:**
- [ ] Conexión creada en DBeaver
- [ ] Prueba de conexión exitosa
- [ ] Base de datos `educacionit` visible

### **✅ Datos:**
- [ ] 10 tablas visibles
- [ ] Consulta de prueba funciona
- [ ] Datos accesibles

### **✅ Configuración:**
- [ ] Tema personalizado
- [ ] Editor SQL configurado
- [ ] Preferencias ajustadas

---

## 🎉 **¡Listo!**

Tu DBeaver está configurado y conectado a PostgreSQL. Ahora puedes:

- ✅ **Explorar la base de datos**
- ✅ **Ejecutar consultas SQL**
- ✅ **Analizar datos**
- ✅ **Practicar Data Engineering**

**¡Disfruta aprendiendo SQL con datos reales!**

---

## 📞 **Soporte Adicional**

### **Recursos útiles:**
- [Documentación oficial de DBeaver](https://dbeaver.io/docs/)
- [Documentación de PostgreSQL](https://www.postgresql.org/docs/)
- [Comunidad DBeaver](https://dbeaver.io/community/)

### **Si nada funciona:**
1. **Revisar logs de Docker:** `docker logs educacionit-metastore-1`
2. **Revisar logs de DBeaver:** Ver en la consola de errores
3. **Reiniciar todo:** `docker-compose down && docker-compose up -d`
4. **Buscar ayuda en la comunidad** o con el instructor
