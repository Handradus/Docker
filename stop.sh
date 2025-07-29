#!/bin/bash
#
# Script para detener el proyecto Pokemon TCG
# Uso: ./stop.sh

echo "🛑 DETENIENDO POKEMON TCG PROJECT"
echo "================================="

# Detener y eliminar contenedores
echo "⏹️  Deteniendo contenedores..."
sudo docker-compose down

# Opcional: eliminar volúmenes (descomentar si quieres borrar la BD)
# echo "🗑️  Eliminando volúmenes..."
# sudo docker-compose down -v

echo "✅ Proyecto detenido correctamente"
echo ""
echo "🔄 Para iniciar nuevamente: ./run.sh"
echo "🗑️  Para eliminar todo (incluyendo BD): sudo docker-compose down -v"
