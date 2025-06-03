const express = require('express');
const router = express.Router();
const knex = require('../db');
const jwt = require('jsonwebtoken');

// JWT doğrulama middleware'i
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

// Tüm ürünleri getir (korumalı)
router.get('/', authenticateToken, async (req, res) => {
  try {
    const result = await knex('products').select('*').orderBy('id');
    const resultWithStringIds = result.map(row => ({
      ...row,
      id: String(row.id),
      category_id: row.category_id !== undefined ? String(row.category_id) : undefined,
      price: row.price !== undefined ? parseFloat(row.price) : 0
    }));
    res.json(resultWithStringIds);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Yeni ürün ekle (korumalı)
router.post('/', authenticateToken, async (req, res) => {
  const { name, price, stock, category_id, description, is_active } = req.body;
  try {
    const [inserted] = await knex('products')
      .insert({ name, price, stock, category_id, description, is_active })
      .returning('*');
    const insertedWithStringId = { ...inserted, id: String(inserted.id), price: parseFloat(inserted.price) };
    res.status(201).json(insertedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Ürün güncelle (korumalı)
router.put('/:id', authenticateToken, async (req, res) => {
  const { name, price, stock, category_id, description, is_active } = req.body;
  const { id } = req.params;
  try {
    const [updated] = await knex('products')
      .where({ id })
      .update({ name, price, stock, category_id, description, is_active })
      .returning('*');
    const updatedWithStringId = { ...updated, id: String(updated.id), price: parseFloat(updated.price) };
    res.json(updatedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Ürün sil (korumalı)
router.delete('/:id', authenticateToken, async (req, res) => {
  const { id } = req.params;
  try {
    await knex('products').where({ id }).del();
    res.json({ message: 'Ürün silindi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;