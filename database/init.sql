-- Inicialización de la base de datos para Pokemon TCG
-- Este archivo se ejecuta automáticamente al crear el contenedor de PostgreSQL

-- Crear extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Las tablas se crearán automáticamente por TypeORM
-- debido a synchronize: true en data-source.js

-- Insertar datos de ejemplo para tiendas si es necesario
-- (Los datos se pueden insertar a través del backend con los scripts de migración)

SELECT 'Base de datos Pokemon TCG inicializada correctamente' as status;
