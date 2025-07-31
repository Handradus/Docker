// scripts/seedPikachu.js
const fs = require('fs');
const path = require('path');
const { AppDataSource } = require('../data-source');
const Carta = require('../entities/Carta');

async function seedCartasPikachu() {
  try {
    const rawData = fs.readFileSync(path.join(__dirname, 'pikachuBD.txt'), 'utf-8');
    const { data: cartas } = JSON.parse(rawData);

    const cartaRepo = AppDataSource.getRepository(Carta);

    for (const carta of cartas) {
      const yaExiste = await cartaRepo.findOneBy({ nombre: carta.name, numero: carta.number });
      if (yaExiste) {
        console.log(`⚠️ Ya existe: ${carta.name} (${carta.number})`);
        continue;
      }

      const nuevaCarta = cartaRepo.create({
        nombre: carta.name,
        numero: carta.number,
        set: carta.set?.name || null,
        setId: carta.set?.id || null,
        printedTotal: carta.set?.printedTotal || null,
        serie: carta.set?.series || null,
        fechaLanzamiento: carta.set?.releaseDate ? new Date(carta.set.releaseDate) : null,
        supertipo: carta.supertype || null,
        subtipos: carta.subtypes || null,
        nivel: carta.level || null,
        hp: carta.hp || null,
        tipos: carta.types || null,
        evolucionaA: carta.evolvesTo || null,
        retreatCost: carta.retreatCost || null,
        debilidades: carta.weaknesses || null,
        ataques: carta.attacks || null,
        reglas: carta.rules || null,
        rareza: carta.rarity || null,
        ilustrador: carta.artist || null,
        flavorText: carta.flavorText || null,
        pokedexIds: carta.nationalPokedexNumbers || null,
        imagenPequena: carta.images?.small || null,
        imagenGrande: carta.images?.large || null,
        precioNormal: carta.cardmarket?.prices?.averageSellPrice || null,
        fechaActualizacionPrecios: new Date(),
      });

      await cartaRepo.save(nuevaCarta);
      console.log(`✅ Insertada carta: ${carta.name} (${carta.number})`);
    }

    console.log('🎉 Inserción completada');
  } catch (error) {
    console.error('❌ Error al insertar cartas:', error);
  }
}

module.exports = { seedCartasPikachu };
