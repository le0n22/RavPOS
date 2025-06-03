const knex = require('../db/knex');

async function idempotency(req, res, next) {
  const idempotencyKey = req.get('Idempotency-Key');
  if (!idempotencyKey) {
    return next();
  }

  try {
    const existingOrder = await knex('orders')
      .where({ request_id: idempotencyKey })
      .first();

    if (existingOrder) {
      return res.status(200).json(existingOrder);
    }

    req.idempotencyKey = idempotencyKey;
    next();
  } catch (error) {
    next(error);
  }
}

module.exports = idempotency; 