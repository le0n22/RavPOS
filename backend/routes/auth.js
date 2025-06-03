const express = require('express');
const router = express.Router();
const pool = require('../db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Kullanıcı kaydı (register)
router.post('/register', async (req, res) => {
  const { username, password, role, name } = req.body;
  try {
    // Kullanıcı var mı kontrol et
    const userCheck = await pool('users').where({ username }).first();
    if (userCheck) {
      return res.status(400).json({ error: 'Kullanıcı adı zaten mevcut' });
    }
    // Şifreyi hashle
    const hashedPassword = await bcrypt.hash(password, 10);
    // Kullanıcıyı ekle
    const [user] = await pool('users')
      .insert({ username, password: hashedPassword, role, name, is_active: true })
      .returning('*');
    res.status(201).json({ message: 'Kayıt başarılı', user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Kullanıcı girişi (login)
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  try {
    // Kullanıcıyı bul
    const user = await pool('users').where({ username }).first();
    if (!user) {
      return res.status(400).json({ error: 'Kullanıcı bulunamadı' });
    }
    // Şifreyi kontrol et
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Şifre hatalı' });
    }
    // JWT token oluştur
    const token = jwt.sign(
      { userId: user.id, username: user.username, role: user.role },
      process.env.JWT_SECRET || 'gizli_anahtar',
      { expiresIn: '8h' }
    );
    res.json({ token, user: { id: user.id, username: user.username, role: user.role, name: user.name } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router; 