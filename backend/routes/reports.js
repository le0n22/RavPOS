const express = require('express');
const router = express.Router();
const pool = require('../db');
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

// Özet rapor getir (korumalı)
router.get('/summary', authenticateToken, async (req, res) => {
  const { start, end } = req.query;
  try {
    // Örnek: Teslim edilen siparişlerin toplamı
    const result = await pool.query(
      'SELECT COUNT(*) as total_orders, SUM(total) as total_sales FROM orders WHERE status = $1 AND created_at BETWEEN $2 AND $3',
      ['delivered', start, end]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router; 