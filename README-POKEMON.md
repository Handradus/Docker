# 🎴 POKEMON TCG PROJECT - Docker Setup

## 📋 **DESCRIPCIÓN**
Proyecto completo con Frontend (React), Backend (Node.js) y Base de datos (PostgreSQL) para manejo de cartas Pokemon TCG, ejecutado con Docker.

## 🏗️ **ARQUITECTURA**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   FRONTEND      │    │    BACKEND      │    │   DATABASE      │
│                 │    │                 │    │                 │
│ React + Vite    │◄──►│ Node.js + API   │◄──►│ PostgreSQL 15   │
│ Puerto: 5173    │    │ Puerto: 3000    │    │ Puerto: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 **INSTALACIÓN RÁPIDA**

### 📋 Requisitos:
- Ubuntu 18.04+ / Debian 10+ / cualquier distribución Linux
- 4GB RAM libre
- 5GB espacio en disco
- Conexión a internet

### ⚡ Instalación en 2 pasos:

1. **Instalar dependencias y configurar entorno:**
```bash
chmod +x setup.sh
./setup.sh
```

2. **Ejecutar la aplicación:**
```bash
chmod +x run.sh
./run.sh
```

## 🌐 **ACCESOS DESPUÉS DE LA INSTALACIÓN**

| Servicio | URL | Descripción |
|----------|-----|-------------|
| **🌐 Frontend** | http://localhost:5173 | Aplicación React |
| **🔧 Backend API** | http://localhost:3000/api | API REST |
| **🗄️ Base de Datos** | localhost:5432 | PostgreSQL |

## 🔑 **CREDENCIALES**

### Base de Datos PostgreSQL:
- **Host:** localhost:5432
- **Database:** pokemon_tcg_db  
- **Usuario:** pokemon_user
- **Password:** pokemon_pass123

## 🛠️ **COMANDOS ÚTILES**

```bash
# Iniciar aplicación
./run.sh

# Detener aplicación
./stop.sh

# Ver logs en tiempo real
sudo docker-compose logs -f

# Ver logs específicos
sudo docker-compose logs -f frontend
sudo docker-compose logs -f backend  
sudo docker-compose logs -f database

# Reiniciar servicios
sudo docker-compose restart

# Eliminar todo (incluyendo base de datos)
sudo docker-compose down -v

# Reconstruir contenedores
sudo docker-compose up --build -d
```

## 📁 **ESTRUCTURA DEL PROYECTO**

```
ProyectoPokemonTCG/
├── docker-compose.yml          # Configuración principal Docker
├── setup.sh                    # Script de instalación 
├── run.sh                      # Script para ejecutar
├── stop.sh                     # Script para detener
├── database/
│   └── init.sql                # Inicialización BD
├── Backend/
│   ├── Dockerfile              # Imagen Docker Backend
│   ├── package.json
│   └── src/
│       ├── index.js           # Punto de entrada
│       ├── data-source.js     # Configuración TypeORM
│       └── config/
│           └── .env           # Variables de entorno
└── Frontend/
    ├── Dockerfile              # Imagen Docker Frontend
    ├── package.json
    ├── nginx.conf
    └── .env                    # Variables de entorno
```

## 🔧 **CONFIGURACIÓN**

### Variables de entorno importantes:

**Backend (`Backend/src/config/.env`):**
```env
DB_HOST=database
DB_PORT=5432
DB_USERNAME=pokemon_user
DB_PASSWORD=pokemon_pass123
DB_NAME=pokemon_tcg_db
```

**Frontend (`Frontend/.env`):**
```env
VITE_API_BASE_URL=http://localhost:3000/api
```

## 🐛 **TROUBLESHOOTING**

### Problemas comunes:

1. **Error de permisos Docker:**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

2. **Puertos ocupados:**
```bash
# Verificar puertos
sudo netstat -tulpn | grep :5173
sudo netstat -tulpn | grep :3000

# Detener servicios que usen los puertos
sudo docker-compose down
```

3. **Contenedores no inician:**
```bash
# Ver logs detallados
sudo docker-compose logs

# Reconstruir desde cero
sudo docker-compose down -v
sudo docker-compose up --build -d
```

4. **Base de datos no conecta:**
```bash
# Verificar contenedor de BD
sudo docker-compose logs database

# Reiniciar solo la BD
sudo docker-compose restart database
```

## 📊 **MONITORING**

Para monitorear el estado de los servicios:

```bash
# Estado de contenedores
sudo docker-compose ps

# Uso de recursos
sudo docker stats

# Logs en tiempo real
sudo docker-compose logs -f
```

## 🔄 **DESARROLLO**

Para desarrollo local sin Docker:

1. **Backend:**
```bash
cd Backend
npm install
npm run dev
```

2. **Frontend:**
```bash
cd Frontend  
npm install
npm run dev
```

3. **Base de datos:**
Usar PostgreSQL local o mantener solo el contenedor de BD:
```bash
sudo docker-compose up database -d
```

---

## 📝 **NOTAS**

- Los datos de la base de datos persisten en un volumen Docker
- Los archivos de configuración `.env` se crean automáticamente  
- El proyecto usa TypeORM con sincronización automática
- Nginx sirve el frontend en producción

**¡Proyecto listo para usar! 🎉**
