const express = require('express');
const router = express.Router();
const db = require('../db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');
const Joi = require('joi');

const settingSchema = Joi.object({
  key: Joi.string().max(64).required(),
  value: Joi.any().required(),
  type: Joi.string().valid('string', 'int', 'double', 'bool', 'json').required(),
  description: Joi.string().allow('', null),
});

const updateSchema = Joi.object({
  value: Joi.any().required(),
  type: Joi.string().valid('string', 'int', 'double', 'bool', 'json'),
  description: Joi.string().allow('', null),
});

// All routes require authentication
router.use(authenticateToken);

// GET /settings
router.get('/', async (req, res, next) => {
  try {
    const settings = await db('settings').select();
    res.json(settings);
  } catch (err) { next(err); }
});

// GET /settings/:key
router.get('/:key', async (req, res, next) => {
  try {
    const setting = await db('settings').where({ key: req.params.key }).first();
    if (!setting) return res.status(404).json({ error: 'Not found' });
    res.json(setting);
  } catch (err) { next(err); }
});

// POST /settings (admin only)
router.post('/', requireAdmin, async (req, res, next) => {
  const { error } = settingSchema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    const [created] = await db('settings')
      .insert({ ...req.body, value: JSON.stringify(req.body.value) })
      .returning('*');
    res.status(201).json(created);
  } catch (err) {
    if (err.code === '23505') {
      res.status(409).json({ error: 'Key already exists' });
    } else {
      next(err);
    }
  }
});

// PUT /settings/:key (admin only)
router.put('/:key', requireAdmin, async (req, res, next) => {
  const { error } = updateSchema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    const update = {};
    if (req.body.value !== undefined) update.value = JSON.stringify(req.body.value);
    if (req.body.type) update.type = req.body.type;
    if (req.body.description) update.description = req.body.description;
    update.updated_at = new Date();
    const [updated] = await db('settings')
      .where({ key: req.params.key })
      .update(update)
      .returning('*');
    if (!updated) return res.status(404).json({ error: 'Not found' });
    res.json(updated);
  } catch (err) {
    next(err);
  }
});

// DELETE /settings/:key (admin only)
router.delete('/:key', requireAdmin, async (req, res, next) => {
  try {
    const deleted = await db('settings').where({ key: req.params.key }).del();
    if (!deleted) return res.status(404).json({ error: 'Not found' });
    res.status(204).send();
  } catch (err) {
    next(err);
  }
});

module.exports = router; 