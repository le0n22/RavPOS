const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const pool = require('./db'); // db.js dosyasını dahil et
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// CORS'u EN ÜSTE EKLE
app.use(cors({
  origin: '*', // Geliştirme için tüm kaynaklara izin ver
  credentials: true,
}));

app.use(bodyParser.json());

// Route imports
const userRoutes = require('./routes/users');
const productRoutes = require('./routes/products');
const categoryRoutes = require('./routes/categories');
const tableRoutes = require('./routes/tables');
const orderRoutes = require('./routes/orders');
const paymentRoutes = require('./routes/payments');
const orderItemRoutes = require('./routes/order_items');
const authRoutes = require('./routes/auth');
const discountRoutes = require('./routes/discounts');
const onlineOrderRoutes = require('./routes/online_orders');
const reportRoutes = require('./routes/reports');
const debugController = require('./controllers/debugController');
const ensureIdempotent = require('./middleware/idempotency');

app.use('/api/users', userRoutes);
app.use('/api/products', productRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/tables', tableRoutes);
app.use('/api/orders', ensureIdempotent);
app.use('/api/orders', orderRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/orders', orderItemRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/discounts', discountRoutes);
app.use('/api/online-orders', onlineOrderRoutes);
app.use('/api/reports', reportRoutes);
app.get('/api/debug/table/:tableId', debugController.debugTable);
app.post('/api/debug/fix-totals', debugController.fixOrderTotals);

app.get('/', (req, res) => {
  res.send('RavPOS Backend Çalışıyor!');
});

// Basit bir test endpoint'i: Veritabanından tarih çek
app.get('/api/test-db', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Sunucu ${PORT} portunda çalışıyor.`);
});

