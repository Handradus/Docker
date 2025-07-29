#!/bin/bash
#
# Script de prueba para verificar que todos los servicios estén funcionando
# Uso: ./test.sh

echo "🧪 TESTING POKEMON TCG PROJECT"
echo "=============================="

# Verificar que los contenedores estén corriendo
echo "📊 Verificando contenedores..."
if sudo docker-compose ps | grep -q "Up"; then
    echo "✅ Contenedores están corriendo"
    sudo docker-compose ps
else
    echo "❌ Los contenedores no están corriendo"
    echo "💡 Ejecuta ./run.sh primero"
    exit 1
fi

echo ""

# Probar conexión al backend
echo "🔧 Probando conexión al backend..."
if curl -s http://localhost:3000/api >/dev/null 2>&1; then
    echo "✅ Backend responde correctamente"
else
    echo "⚠️  Backend no responde o aún está iniciando"
    echo "📋 Logs del backend:"
    sudo docker-compose logs backend --tail=5
fi

echo ""

# Probar conexión al frontend
echo "🌐 Probando conexión al frontend..."
if curl -s http://localhost:5173 >/dev/null 2>&1; then
    echo "✅ Frontend responde correctamente"
else
    echo "⚠️  Frontend no responde o aún está iniciando"
    echo "📋 Logs del frontend:"
    sudo docker-compose logs frontend --tail=5
fi

echo ""

# Probar conexión a la base de datos
echo "🗄️  Probando conexión a la base de datos..."
if sudo docker exec pokemon_tcg_db pg_isready -U pokemon_user >/dev/null 2>&1; then
    echo "✅ Base de datos responde correctamente"
else
    echo "⚠️  Base de datos no responde"
    echo "📋 Logs de la base de datos:"
    sudo docker-compose logs database --tail=5
fi

echo ""
echo "🎯 RESUMEN DE SERVICIOS:"
echo "========================"
echo "🌐 Frontend: http://localhost:5173"
echo "🔧 Backend:  http://localhost:3000/api"
echo "🗄️  Database: localhost:5432"
echo ""
echo "💡 Si algún servicio no responde, espera unos minutos más para que inicie completamente"
