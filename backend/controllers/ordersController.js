const knex = require('../db/knex');

exports.createOrder = async (req, res) => {
  // Extract data from the request body.
  // The 'items' array is crucial and should contain objects with
  // { productId, quantity, price, totalPrice, productName }.
  const { userId, tableId, orderNumber, order_number, status, items } = req.body;
  const orderNum = orderNumber || order_number;
  const key = req.idempotencyKey;

  // 1. Backend-side calculation of the total amount. Never trust the frontend for this.
  if (!items || items.length === 0) {
    return res.status(400).json({ error: 'Order must contain at least one item.' });
  }
  const calculatedTotal = items.reduce((sum, item) => {
    // Ensure totalPrice is a number before adding
    return sum + (parseFloat(item.totalPrice) || 0);
  }, 0);

  // 2. Use a transaction to ensure all or nothing is saved.
  try {
    const result = await knex.transaction(async (trx) => {
      // 3. Insert the main order record with the CORRECT calculated total.
      const [order] = await trx('orders')
        .insert({
          user_id: userId,
          table_id: tableId,
          order_number: orderNum,
          status: status || 'pending',
          total: calculatedTotal, // Use the backend-calculated total
          created_at: new Date(),
          request_id: key
        })
        .returning('*');

      // Cast total (string) to number
      order.total = Number(order.total);

      // 4. Prepare the order items for insertion.
      const itemsToInsert = items.map(item => ({
        order_id: order.id,
        product_id: item.productId,
        quantity: item.quantity,
        price: item.unitPrice,
        total_price: item.totalPrice,
        product_name: item.productName,
      }));

      // 5. Insert all order items.
      await trx('order_items').insert(itemsToInsert);

      return { order, items: itemsToInsert };
    });

    res.status(201).json(result);

  } catch (err) {
    console.error('[ERROR] Creating Order:', err);
    res.status(500).json({ error: 'Failed to create order.', details: err.message });
  }
};

// Add other order-related functions here in the future (e.g., getOrderById, updateOrderStatus, etc.) 