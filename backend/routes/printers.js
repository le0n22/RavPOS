const express = require('express');
const router = express.Router();
const db = require('../db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

// GET /printers
router.get('/', authenticateToken, async (req, res, next) => {
  try {
    const printers = await db('printers').select();
    res.json(printers);
  } catch (err) { next(err); }
});

// GET /printers/:id
router.get('/:id', authenticateToken, async (req, res, next) => {
  try {
    const printer = await db('printers').where({ id: req.params.id }).first();
    if (!printer) return res.status(404).json({ error: 'Not found' });
    res.json(printer);
  } catch (err) { next(err); }
});

// POST /printers
router.post('/', requireAdmin, async (req, res, next) => {
  try {
    const [created] = await db('printers').insert(req.body).returning('*');
    res.status(201).json(created);
  } catch (err) { next(err); }
});

// PUT /printers/:id
router.put('/:id', requireAdmin, async (req, res, next) => {
  try {
    const [updated] = await db('printers').where({ id: req.params.id }).update(req.body).returning('*');
    if (!updated) return res.status(404).json({ error: 'Not found' });
    res.json(updated);
  } catch (err) { next(err); }
});

// DELETE /printers/:id
router.delete('/:id', requireAdmin, async (req, res, next) => {
  try {
    const deleted = await db('printers').where({ id: req.params.id }).del();
    if (!deleted) return res.status(404).json({ error: 'Not found' });
    res.status(204).send();
  } catch (err) { next(err); }
});

// POST /printers/:id/test
router.post('/:id/test', requireAdmin, async (req, res, next) => {
  // Here you would trigger a test print (e.g., via a print service)
  res.json({ message: 'Test print sent (mock)' });
});

module.exports = router; 