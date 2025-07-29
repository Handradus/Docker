const { DataSource } = require('typeorm');
require('dotenv').config({ path: './src/config/.env' });

const Carta = require('./entities/Carta'); // ← sin destructuración
const ConsultaAPI = require('./entities/ConsultaAPI');
const Tienda = require('./entities/Tienda');
const CartaLink = require('./entities/CartaLink'); // Asegúrate de importar CartaLink si lo necesitas
const HistorialCarta = require('./entities/HistorialCarta');
const HistorialTienda = require('./entities/HistorialTienda');

const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'database',
  port: parseInt(process.env.DB_PORT) || 5432,
  username: process.env.DB_USERNAME || 'pokemon_user',
  password: process.env.DB_PASSWORD || 'pokemon_pass123',
  database: process.env.DB_NAME || 'pokemon_tcg_db',
  synchronize: true,
  logging: true,
  entities: [Carta,ConsultaAPI,Tienda,CartaLink,HistorialCarta,HistorialTienda], // ← arreglo de entidades reales, no strings
});

module.exports = { AppDataSource };
