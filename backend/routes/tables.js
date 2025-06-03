const express = require('express');
const router = express.Router();
const tablesController = require('../controllers/tablesController');
const knex = require('../db');
const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Token gerekli' });

  jwt.verify(token, process.env.JWT_SECRET || 'gizli_anahtar', (err, user) => {
    if (err) return res.status(403).json({ error: 'Geçersiz token' });
    req.user = user;
    next();
  });
}

// Update table (protected)
router.put('/:id', authenticateToken, tablesController.updateTable);
// Tüm masaları getir (korumalı)
router.get('/', authenticateToken, tablesController.getTables);

// Yeni masa ekle (korumalı)
router.post('/', authenticateToken, async (req, res) => {
  const { name, status, capacity } = req.body;
  try {
    const [inserted] = await knex('tables')
      .insert({ name, status, capacity })
      .returning('*');
    const insertedWithStringId = { ...inserted, id: String(inserted.id) };
    res.status(201).json(insertedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


// Masa sil (korumalı)
router.delete('/:id', authenticateToken, async (req, res) => {
  const { id } = req.params;
  try {
    await knex('tables').where({ id }).del();
    res.json({ message: 'Masa silindi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Tek bir masayı getir (korumalı)
router.get('/:id', authenticateToken, async (req, res) => {
  const { id } = req.params;
  try {
    const table = await knex('tables').where({ id }).first();
    if (!table) {
      return res.status(404).json({ error: 'Masa bulunamadı' });
    }
    const tableWithStringId = { ...table, id: String(table.id) };
    res.json(tableWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router; 