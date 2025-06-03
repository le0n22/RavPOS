const express = require('express');
const router = express.Router();
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

// Tüm kullanıcıları getir (korumalı)
router.get('/', authenticateToken, async (req, res) => {
  try {
    const result = await knex('users').select('*').orderBy('id');
    const resultWithStringIds = result.map(row => ({ ...row, id: String(row.id) }));
    res.json(resultWithStringIds);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Yeni kullanıcı ekle (korumalı)
router.post('/', authenticateToken, async (req, res) => {
  const { username, password, role, name, is_active } = req.body;
  try {
    const [inserted] = await knex('users')
      .insert({ username, password, role, name, is_active })
      .returning('*');
    const insertedWithStringId = { ...inserted, id: String(inserted.id) };
    res.status(201).json(insertedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Kullanıcı güncelle (korumalı)
router.put('/:id', authenticateToken, async (req, res) => {
  const { username, password, role, name, is_active } = req.body;
  const { id } = req.params;
  try {
    const [updated] = await knex('users')
      .where({ id })
      .update({ username, password, role, name, is_active })
      .returning('*');
    const updatedWithStringId = { ...updated, id: String(updated.id) };
    res.json(updatedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Kullanıcı sil (korumalı)
router.delete('/:id', authenticateToken, async (req, res) => {
  const { id } = req.params;
  try {
    await knex('users').where({ id }).del();
    res.json({ message: 'Kullanıcı silindi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router; 