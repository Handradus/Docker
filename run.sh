#!/bin/bash
#
# Script simple para ejecutar el proyecto Pokemon TCG con Docker
# Uso: ./run.sh

echo "🚀 INICIANDO POKEMON TCG PROJECT"
echo "================================"

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Ejecuta ./setup.sh primero"
    exit 1
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado. Ejecuta ./setup.sh primero"
    exit 1
fi

# Verificar que el archivo docker-compose.yml existe
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: No se encontró docker-compose.yml"
    exit 1
fi

# Detener contenedores existentes si están corriendo
echo "🛑 Deteniendo contenedores existentes..."
sudo docker-compose down -v --remove-orphans 2>/dev/null || true

# Construir y ejecutar contenedores
echo "🏗️  Construyendo y ejecutando contenedores..."
sudo docker-compose up --build -d

# Esperar un momento para que los contenedores inicien
echo "⏳ Esperando que los servicios inicien..."
sleep 15

# Verificar estado de los contenedores
echo "📊 Estado de los contenedores:"
sudo docker-compose ps

# Mostrar logs iniciales
echo ""
echo "📋 Logs recientes:"
echo "==================="
sudo docker-compose logs --tail=10

echo ""
echo "✅ POKEMON TCG PROJECT INICIADO"
echo "==============================="
echo "🌐 Frontend: http://localhost:5173"
echo "🔧 Backend API: http://localhost:3000/api"
echo "🗄️ Database: localhost:5432"
echo ""
echo "🛠️  Para ver logs en tiempo real: sudo docker-compose logs -f"
echo "🛑 Para detener: sudo docker-compose down"
