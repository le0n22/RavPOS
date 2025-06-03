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

// Belirli bir siparişin tüm ürünlerini getir
router.get('/:orderId/items', authenticateToken, async (req, res) => {
  const { orderId } = req.params;
  try {
    const result = await knex('order_items').select('*').where({ order_id: orderId }).orderBy('id');
    const resultWithStringIds = result.map(row => ({ ...row, id: String(row.id), order_id: row.order_id !== undefined ? String(row.order_id) : undefined, product_id: row.product_id !== undefined ? String(row.product_id) : undefined }));
    res.json(resultWithStringIds);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Siparişe ürün ekle
router.post('/:orderId/items', authenticateToken, async (req, res) => {
  const { orderId } = req.params;
  const { product_id, product_name, quantity, price, total_price } = req.body;
  try {
    const [inserted] = await knex('order_items')
      .insert({ order_id: orderId, product_id, product_name, quantity, price, total_price })
      .returning('*');
    const insertedWithStringId = { ...inserted, id: inserted.id.toString() };
    res.status(201).json(insertedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Sipariş ürününü güncelle
router.put('/:orderId/items/:itemId', authenticateToken, async (req, res) => {
  const { orderId, itemId } = req.params;
  const { product_id, product_name, quantity, price, total_price } = req.body;
  try {
    const [updated] = await knex('order_items')
      .where({ id: itemId, order_id: orderId })
      .update({ product_id, product_name, quantity, price, total_price })
      .returning('*');
    const updatedWithStringId = { ...updated, id: updated.id.toString() };
    res.json(updatedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Sipariş ürününü sil
router.delete('/:orderId/items/:itemId', authenticateToken, async (req, res) => {
  const { orderId, itemId } = req.params;
  try {
    await knex('order_items').where({ id: itemId, order_id: orderId }).del();
    res.json({ message: 'Sipariş ürünü silindi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Yeni sipariş ürünü ekle (korumalı)
router.post('/', authenticateToken, async (req, res) => {
  const { order_id, product_id, quantity, price } = req.body;
  try {
    const [inserted] = await knex('order_items')
      .insert({ order_id, product_id, quantity, price })
      .returning('*');
    const insertedWithStringId = { ...inserted, id: String(inserted.id) };
    res.status(201).json(insertedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Sipariş ürünü güncelle (korumalı)
router.put('/:id', authenticateToken, async (req, res) => {
  const { order_id, product_id, quantity, price } = req.body;
  const { id } = req.params;
  try {
    const [updated] = await knex('order_items')
      .where({ id })
      .update({ order_id, product_id, quantity, price })
      .returning('*');
    const updatedWithStringId = { ...updated, id: String(updated.id) };
    res.json(updatedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router; 