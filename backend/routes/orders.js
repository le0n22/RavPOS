const express = require('express');
const router = express.Router();
const knex = require('../db');
const jwt = require('jsonwebtoken');
const ordersController = require('../controllers/ordersController');

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

// Tüm siparişleri getir (korumalı)
router.get('/', authenticateToken, async (req, res) => {
  try {
    let query = knex('orders').select('*').orderBy('id');
    if (req.query.table) {
      query = query.where('table_id', req.query.table);
    }
    const result = await query;
    const resultWithStringIds = result.map(row => ({
      ...row,
      id: row.id != null ? String(row.id) : '',
      table_id: row.table_id != null ? String(row.table_id) : '',
      user_id: row.user_id != null ? String(row.user_id) : ''
    }));
    res.json(resultWithStringIds);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get single order by ID (korumalı)
router.get('/:id', authenticateToken, async (req, res) => {
  const { id } = req.params;
  try {
    const order = await knex('orders').select('*').where({ id }).first();
    if (!order) {
      return res.status(404).json({ error: 'Sipariş bulunamadı' });
    }
    const orderWithStringIds = {
      ...order,
      id: order.id != null ? String(order.id) : '',
      table_id: order.table_id != null ? String(order.table_id) : '',
      user_id: order.user_id != null ? String(order.user_id) : ''
    };
    res.json(orderWithStringIds);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Yeni sipariş ekle (korumalı)
router.post('/', authenticateToken, ordersController.createOrder);

// Sipariş güncelle (korumalı)
router.put('/:id', authenticateToken, async (req, res) => {
  const tableId = req.body.tableId || req.body.table_id;
  const orderNumber = req.body.orderNumber || req.body.order_number;
  const { userId, user_id, status, total, totalAmount } = req.body;
  const totalValue = total ?? totalAmount ?? 0;
  const { id } = req.params;
  try {
    const [updated] = await knex('orders')
      .where({ id })
      .update({
        table_id: tableId,
        user_id: userId || user_id,
        order_number: orderNumber,
        status,
        total: totalValue
      })
      .returning('*');
    const updatedWithStringId = { ...updated, id: String(updated.id) };
    res.json(updatedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Sipariş sil (korumalı)
router.delete('/:id', authenticateToken, async (req, res) => {
  const { id } = req.params;
  try {
    await knex('orders').where({ id }).del();
    res.json({ message: 'Sipariş silindi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Sipariş durumunu güncelle (korumalı)
router.patch('/:id/status', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  if (!status) {
    return res.status(400).json({ error: 'Status alanı gereklidir' });
  }
  try {
    const [updated] = await knex('orders')
      .where({ id })
      .update({ status })
      .returning('*');
    if (!updated) {
      return res.status(404).json({ error: 'Sipariş bulunamadı' });
    }
    const updatedWithStringId = { ...updated, id: String(updated.id) };
    res.json(updatedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router; 