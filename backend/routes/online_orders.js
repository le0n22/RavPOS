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

// Tüm online siparişleri getir (korumalı)
router.get('/', authenticateToken, async (req, res) => {
  try {
    const result = await knex('online_orders').select('*').orderBy('id');
    const resultWithStringIds = result.map(row => ({ ...row, id: String(row.id) }));
    res.json(resultWithStringIds);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Online siparişi kabul et (korumalı)
router.post('/:id/accept', authenticateToken, async (req, res) => {
  const { id } = req.params;
  try {
    await knex('online_orders').where({ id }).update({ status: 'accepted' });
    res.json({ message: 'Sipariş kabul edildi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Online siparişi reddet (korumalı)
router.post('/:id/reject', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { reason } = req.body;
  try {
    await knex('online_orders').where({ id }).update({ status: 'rejected', reject_reason: reason });
    res.json({ message: 'Sipariş reddedildi' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Yeni online sipariş ekle (korumalı)
router.post('/', authenticateToken, async (req, res) => {
  const { customer_name, address, status, total } = req.body;
  try {
    const [inserted] = await knex('online_orders')
      .insert({ customer_name, address, status, total })
      .returning('*');
    const insertedWithStringId = { ...inserted, id: String(inserted.id) };
    res.status(201).json(insertedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Online sipariş güncelle (korumalı)
router.put('/:id', authenticateToken, async (req, res) => {
  const { customer_name, address, status, total } = req.body;
  const { id } = req.params;
  try {
    const [updated] = await knex('online_orders')
      .where({ id })
      .update({ customer_name, address, status, total })
      .returning('*');
    const updatedWithStringId = { ...updated, id: String(updated.id) };
    res.json(updatedWithStringId);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router; 