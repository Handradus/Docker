#!/bin/bash
#
# Script de instalación automática para el proyecto Pokemon TCG
# Instala Docker, Docker Compose y configura el entorno para ejecutar
# Frontend (React), Backend (Node.js) y Base de datos (PostgreSQL)

set -e

# Función para manejar errores
handle_error() {
    echo "❌ Error en la línea $1"
    echo "🔄 Continuando con la instalación..."
}

trap 'handle_error $LINENO' ERR

echo "🚀 INSTALACIÓN AUTOMÁTICA - POKEMON TCG PROJECT"
echo "==============================================="

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: No se encontró docker-compose.yml"
    echo "💡 Asegúrate de estar en el directorio del proyecto Pokemon TCG"
    exit 1
fi

echo "✅ Directorio del proyecto verificado"

# Verificar espacio en disco
echo "💾 Verificando espacio en disco..."
FREE_SPACE=$(df / | awk 'NR==2 {print $4}')
if [ "$FREE_SPACE" -lt 5000000 ]; then
    echo "⚠️  Poco espacio en disco. Se requieren al menos 5GB libres."
    echo "💡 Espacio disponible: $((FREE_SPACE / 1024 / 1024))GB"
    echo "🔄 Continuando de todas formas..."
else
    echo "✅ Espacio en disco suficiente: $((FREE_SPACE / 1024 / 1024))GB libres"
fi

# Detener actualizaciones automáticas que bloquean el sistema
echo "⏹️  Deteniendo actualizaciones automáticas..."
sudo killall unattended-upgrade 2>/dev/null || true
sudo dpkg --configure -a

# Actualizar sistema e instalar herramientas básicas
echo "📦 Verificando herramientas del sistema..."
sudo apt update

# Verificar si git está instalado
if ! command -v git &> /dev/null; then
    echo "📦 Instalando Git..."
    sudo apt install -y git
else
    echo "✅ Git ya está instalado"
fi

# Verificar si curl está instalado
if ! command -v curl &> /dev/null; then
    echo "📦 Instalando Curl..."
    sudo apt install -y curl
else
    echo "✅ Curl ya está instalado"
fi

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "🐳 Instalando Docker..."
    echo "🔄 Instalando con apt..."
    sudo apt update
    sudo apt install -y docker.io docker-compose
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "✅ Docker instalado con apt"
else
    echo "✅ Docker ya está instalado"
fi

# Crear grupo docker si no existe y agregar usuario
echo "👥 Configurando permisos Docker..."
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER

# Nota: Los cambios de grupo se aplicarán después de reiniciar sesión
echo "ℹ️  Nota: Si hay problemas de permisos, reinicia la sesión o usa 'sudo'"

# Verificar si Docker Compose está instalado y funcionando
if ! command -v docker-compose &> /dev/null; then
    echo "🔧 Instalando Docker Compose..."
    sudo apt install -y docker-compose
    echo "✅ Docker Compose instalado con apt"
else
    echo "✅ Docker Compose ya está instalado"
fi

# Verificar que Docker Compose funcione correctamente
echo "🔍 Verificando Docker Compose..."
if ! docker-compose --version &> /dev/null; then
    echo "⚠️  Docker Compose no funciona. Instalando versión más reciente..."
    # Eliminar versión problemática
    sudo apt remove -y docker-compose
    sudo apt autoremove -y
    # Instalar versión más reciente
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose actualizado"
fi

# Iniciar Docker
echo "🚀 Iniciando Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Esperar a que Docker inicie
echo "⏳ Esperando a que Docker inicie..."
sleep 5

# Verificar que Docker esté funcionando
echo "🔍 Verificando que Docker esté funcionando..."
if ! sudo docker info &> /dev/null; then
    echo "❌ Docker no está funcionando correctamente"
    echo "🔄 Reiniciando Docker..."
    sudo systemctl restart docker
    sleep 3
    if ! sudo docker info &> /dev/null; then
        echo "❌ Docker sigue sin funcionar. Verifica la instalación."
        exit 1
    fi
fi
echo "✅ Docker funcionando correctamente"

# Asegurar que el directorio temporal de Docker exista
if [ ! -d "/var/lib/docker/tmp" ]; then
    echo "🛠️  Creando directorio temporal de Docker (/var/lib/docker/tmp)..."
    sudo mkdir -p /var/lib/docker/tmp
    sudo chown root:root /var/lib/docker/tmp
fi

# Pre‑descargar imagen de la base de datos para evitar fallos en docker-compose pull
echo "🐳 Descargando imagen de base de datos (postgres:15)..."
if ! sudo docker pull postgres:15; then
    echo "⚠️  Error al descargar la imagen de Postgres. Reiniciando Docker y reintentando..."
    sudo systemctl restart docker
    sleep 3
    sudo docker pull postgres:15 || {
        echo "❌ No se pudo descargar la imagen postgres:15 después de reintento. Continúa con la instalación, pero la base de datos puede no funcionar."
    }
fi

# Configurar para localhost
echo "🌐 Configurando para localhost..."
echo "✅ Usando localhost:5173"

# Crear archivo .env para el backend
echo "📝 Verificando archivo .env para el backend..."
if [ ! -f "Backend/src/config/.env" ]; then
    mkdir -p Backend/src/config
    cat > Backend/src/config/.env << 'EOF'
# Pokemon TCG Backend Configuration
HOST=0.0.0.0
PORT=3000

# Database Configuration
DB_HOST=database
DB_PORT=5432
DB_USERNAME=pokemon_user
DB_PASSWORD=pokemon_pass123
DB_NAME=pokemon_tcg_db

# Security tokens
ACCESS_TOKEN_SECRET=pokemon_tcg_secret_key_2024_very_secure_token_for_jwt_authentication
COOKIE_KEY=pokemon_tcg_cookie_secret_key_for_session_management_2024
EOF
    echo "✅ Archivo .env del backend creado"
else
    echo "✅ Archivo .env del backend ya existe"
fi

# Crear archivo .env para el frontend
echo "📝 Verificando archivo .env para el frontend..."
if [ ! -f "Frontend/.env" ]; then
    cat > Frontend/.env << 'EOF'
# Pokemon TCG Frontend Configuration
VITE_API_BASE_URL=http://localhost:3000/api
EOF
    echo "✅ Archivo .env del frontend creado"
else
    echo "✅ Archivo .env del frontend ya existe"
fi

# Verificar que los archivos .env se crearon
echo "🔍 Verificando archivos .env..."
if [ -f "Backend/src/config/.env" ] && [ -f "Frontend/.env" ]; then
    echo "✅ Archivos .env creados correctamente"
else
    echo "❌ Error: No se pudieron crear los archivos .env"
    exit 1
fi

# Limpiar contenedores anteriores si existen
echo "🧹 Limpiando contenedores anteriores..."
sudo docker-compose down -v --remove-orphans 2>/dev/null || true

# Ejecutar aplicación
echo "🏗️  Construyendo y ejecutando aplicación..."
echo "⏳ Construyendo contenedores con Docker Compose (puede tardar unos minutos)..."
sudo docker-compose up --build -d
echo "✅ Aplicación iniciada correctamente"

# Verificar estado
echo "📊 Verificando estado de contenedores..."
sleep 20
sudo docker-compose ps

# Verificar si hay errores
echo "🔍 Verificando logs..."
if sudo docker-compose logs frontend | grep -q "error\|Error\|ERROR\|emerg"; then
    echo "⚠️  Errores detectados en frontend:"
    sudo docker-compose logs frontend --tail=10
fi

if sudo docker-compose logs backend | grep -q "error\|Error\|ERROR"; then
    echo "⚠️  Errores detectados en backend:"
    sudo docker-compose logs backend --tail=10
fi

# Mostrar puertos abiertos
echo "🌐 Puertos disponibles:"
ss -lntp | egrep ':5173|:3000|:5432' || echo "No se detectaron puertos abiertos"

echo "✅ Verificación completada"

# Mostrar información final
echo ""
echo "✅ INSTALACIÓN COMPLETADA - POKEMON TCG"
echo "======================================"
echo "🌐 Aplicación disponible en: http://localhost:5173"
echo "🔧 API disponible en: http://localhost:3000/api"
echo "�️ Base de datos: localhost:5432"
echo ""
echo "� Credenciales de la base de datos:"
echo "   🏷️  Database: pokemon_tcg_db"
echo "   👤 User: pokemon_user"
echo "   � Password: pokemon_pass123"
echo ""
echo "🛠️  Comandos útiles:"
echo "   Ver logs: sudo docker-compose logs -f"
echo "   Detener: sudo docker-compose down"
echo "   Reiniciar: sudo docker-compose restart"
echo "   Ver solo logs del backend: sudo docker-compose logs -f backend"
echo "   Ver solo logs del frontend: sudo docker-compose logs -f frontend"
echo ""

echo "🎉 ¡LISTO! Tu aplicación Pokemon TCG está funcionando"
