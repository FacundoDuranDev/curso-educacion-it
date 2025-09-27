# 🔌 CONEXIÓN DBEAVER A POSTGRESQL

> **🎯 Objetivo:** Conectar DBeaver a PostgreSQL desde cualquier sistema operativo

## 🚀 **CONFIGURACIÓN RÁPIDA**

### **⚡ Pasos Básicos:**
1. **Instalar DBeaver** → https://dbeaver.io/download/
2. **Nueva Conexión** → PostgreSQL
3. **Configurar credenciales** → `localhost:5432`
4. **¡Conectar!**

---

## 📥 **INSTALACIÓN DBEAVER**

### **🪟 Windows:**
```bash
# Opción 1: Descargar desde web
https://dbeaver.io/download/ → Windows x64 Installer

# Opción 2: Chocolatey
choco install dbeaver

# Opción 3: Winget
winget install dbeaver.dbeaver
```

### **🐧 Linux:**
```bash
# Ubuntu/Debian
sudo snap install dbeaver-ce

# O descargar .deb desde:
https://dbeaver.io/download/
```

### **🍎 macOS:**
```bash
# Homebrew
brew install --cask dbeaver-community

# O descargar desde:
https://dbeaver.io/download/
```

---

## 🔧 **CONFIGURACIÓN DE CONEXIÓN**

### **📋 Datos de Conexión:**
```
🏠 Host: localhost
🚪 Puerto: 5432
🗄️ Base de datos: educacionit
👤 Usuario: admin
🔑 Contraseña: admin123
```

### **📝 Paso a Paso:**

#### **1. Nueva Conexión:**
- Abrir DBeaver
- Click en **"Nueva Conexión"** (icono +)
- Seleccionar **PostgreSQL**
- Click **"Siguiente"**

#### **2. Configuración Principal:**
```
Server Host: localhost
Port: 5432
Database: educacionit
Username: admin
Password: admin123
```

#### **3. Opciones Avanzadas:**
```
✅ Auto-commit: Sí
❌ Read-only: No (Habilitado para escritura)
🔧 Isolation level: Read Committed
❌ SSL: No (desarrollo local)
```

#### **4. Probar Conexión:**
- Click **"Test Connection"**
- Debe mostrar: **"Connected"** ✅
- Click **"OK"** → **"Finish"**

---

## ✅ **VERIFICACIÓN EXITOSA**

### **🎯 Qué deberías ver:**
```sql
-- Tablas disponibles en educacionit:
├── clientes
├── productos
├── ventas
├── empleados
├── sucursales
├── proveedores
├── gastos
├── tiposdegasto
├── canaldeventa
└── compras
```

### **🧪 Consulta de Prueba:**
```sql
-- Verificar que todo funciona
SELECT 
    'Conexión exitosa!' as mensaje,
    count(*) as total_clientes 
FROM clientes;

-- Debería devolver algo como:
-- mensaje: "Conexión exitosa!"
-- total_clientes: 1000+
```

---

## 🚨 **PROBLEMAS COMUNES**

### **❌ "Connection refused"**

**🔍 Causa:** PostgreSQL no está corriendo

**✅ Solución:**
```bash
# Verificar que el contenedor está activo
docker ps | grep metastore

# Si no está corriendo:
docker-compose up -d metastore

# Verificar puerto
telnet localhost 5432
```

---

### **❌ "Database does not exist"**

**🔍 Causa:** Base de datos `educacionit` no fue creada

**✅ Solución:**
```bash
# Crear base de datos
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;"

# Verificar que existe
docker exec -it educacionit-metastore-1 psql -U postgres -c "\l"
```

---

### **❌ "Authentication failed"**

**🔍 Causa:** Usuario `admin` no existe o contraseña incorrecta

**✅ Solución:**
```bash
# Recrear usuario admin
docker exec -it educacionit-metastore-1 psql -U postgres -c "
DROP USER IF EXISTS admin;
CREATE USER admin WITH PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;
"

# Probar conexión
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "SELECT 'OK';"
```

---

### **❌ "Driver not found"**

**🔍 Causa:** DBeaver no tiene el driver PostgreSQL

**✅ Solución:**
- DBeaver descarga drivers automáticamente
- Si falla, ir a **Database → Driver Manager**
- Buscar **PostgreSQL** → **Download/Update**
- Reintentar conexión

---

### **❌ "Timeout" o "Slow connection"**

**🔍 Causa:** Problemas de red o recursos

**✅ Solución:**
```bash
# Verificar recursos Docker
docker stats --no-stream

# Reiniciar PostgreSQL si es necesario
docker-compose restart metastore

# Verificar logs
docker-compose logs metastore
```

---

## 🎯 **CONFIGURACIÓN AVANZADA**

### **⚙️ Optimizaciones de Rendimiento:**
```
Connection Pool:
├── Min Pool Size: 1
├── Max Pool Size: 20
├── Connection Timeout: 30s
└── Keep Alive: 600s
```

### **🔧 Configuraciones Útiles:**
```
General:
├── Auto-commit: ON (para ejercicios)
├── Read-only: OFF (permitir escritura)
├── Show row numbers: ON
└── Confirm data changes: ON (seguridad)

SQL Editor:
├── Auto-completion: ON
├── Highlight syntax: ON
├── Show execution time: ON
└── Max result rows: 10000
```

---

## 📊 **CONSULTAS DE EJEMPLO**

### **🔍 Exploración Básica:**
```sql
-- Ver todas las tablas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Contar registros por tabla
SELECT 
    'clientes' as tabla, count(*) as registros FROM clientes
UNION ALL
SELECT 
    'productos' as tabla, count(*) as registros FROM productos
UNION ALL
SELECT 
    'ventas' as tabla, count(*) as registros FROM ventas;
```

### **📈 Análisis de Datos:**
```sql
-- Top 10 clientes por ventas
SELECT 
    c.nombre_completo,
    count(v.id_venta) as total_compras,
    sum(v.precio * v.cantidad) as total_gastado
FROM clientes c
JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre_completo
ORDER BY total_gastado DESC
LIMIT 10;
```

---

## 🌐 **CONEXIONES ADICIONALES**

### **👥 Usuario Administrador:**
```
Host: localhost
Port: 5432
Database: postgres
Username: postgres
Password: jupyter
```
**Uso:** Administración del sistema, crear bases de datos

### **🐝 Metastore Hive:**
```
Host: localhost
Port: 5432
Database: metastore
Username: jupyter
Password: jupyter
```
**Uso:** Ver metadatos de Hive (avanzado)

---

## 📚 **RECURSOS ADICIONALES**

### **🎓 Tutoriales SQL:**
- `../../05-EXERCISES/sql-queries/tutorial-sql.md`
- `../../03-CONCEPTS/sql-avanzado.md`

### **🔧 Troubleshooting:**
- `../troubleshooting/problemas-comunes.md`
- `../../04-REFERENCE/credenciales.md`

### **🚀 Integración Big Data:**
- `../hadoop-spark/spark-postgresql.md`
- `../../03-CONCEPTS/arquitectura-datos.md`

---

## 💡 **CONSEJOS PRO**

### **✅ Buenas Prácticas:**
- 💾 **Hacer backup** antes de cambios grandes
- 🔍 **Usar LIMIT** en consultas exploratorias
- 📊 **Crear bookmarks** para consultas frecuentes
- 🎯 **Usar transacciones** para cambios múltiples

### **⚡ Atajos de Teclado:**
```
Ctrl+Enter    → Ejecutar consulta
Ctrl+Shift+F  → Formatear SQL
F5            → Refrescar
Ctrl+Space    → Autocompletado
```

### **🎨 Personalización:**
- **Tema oscuro:** Preferences → Appearance → Dark theme
- **Font size:** Preferences → Editors → SQL Editor → Font
- **Colores:** Preferences → Editors → SQL Editor → Syntax coloring

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas de Conexión:**
1. Verificar que PostgreSQL está corriendo: `docker ps`
2. Probar conexión desde terminal: `telnet localhost 5432`
3. Ver logs: `docker-compose logs metastore`

### **📞 Soporte:**
- **Troubleshooting completo:** `../troubleshooting/problemas-comunes.md`
- **Credenciales:** `../../04-REFERENCE/credenciales.md`
- **Instructor:** Consulta en clase

**🎯 ¡Con DBeaver conectado, ya puedes explorar y analizar todos los datos del curso!**
