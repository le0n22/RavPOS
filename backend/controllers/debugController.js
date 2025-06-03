const knex = require('../db/knex');

exports.debugTable = async (req, res) => {
  try {
    const { tableId } = req.params;

    // Get all orders for this table, regardless of status
    const allOrders = await knex('orders').where({ table_id: tableId });
    
    if (allOrders.length === 0) {
        return res.json({ message: 'No orders found for this table.', orders: [] });
    }

    const orderIds = allOrders.map(o => o.id);

    // Get all order items for all these orders
    const allItems = await knex('order_items').whereIn('order_id', orderIds);

    // Calculate the total sum of all items found
    const totalSum = allItems.reduce((sum, item) => sum + parseFloat(item.total_price), 0);

    // Structure the response for easy debugging
    const detailedOrders = allOrders.map(order => ({
        ...order,
        items: allItems.filter(item => item.order_id === order.id)
    }));

    res.json({
        tableId: tableId,
        totalCalculatedSum: totalSum,
        orderCount: detailedOrders.length,
        orders: detailedOrders
    });

  } catch (err) {
    console.error(`[ERROR] Debugging table ${req.params.tableId}:`, err);
    res.status(500).json({ error: 'Failed to debug table data', details: err.message });
  }
};

exports.fixOrderTotals = async (req, res) => {
  try {
    // Get all orders
    const allOrders = await knex('orders').select('id');
    let updatedCount = 0;

    // Loop through each order
    for (const order of allOrders) {
      // Calculate the correct total from its items
      const sumResult = await knex('order_items')
        .where({ order_id: order.id })
        .sum('total_price as total');

      const correctTotal = (sumResult && sumResult[0] && sumResult[0].total)
        ? parseFloat(sumResult[0].total)
        : 0;

      // Get the currently saved (potentially incorrect) total
      const currentOrder = await knex('orders').where({ id: order.id }).first();
      const savedTotal = parseFloat(currentOrder.total);

      // If the saved total is incorrect, update it
      if (savedTotal !== correctTotal) {
        await knex('orders')
          .where({ id: order.id })
          .update({ total: correctTotal });
        updatedCount++;
      }
    }

    res.json({ message: 'Cleanup complete.', orders_updated: updatedCount });

  } catch (err) {
    console.error('[ERROR] Fixing order totals:', err);
    res.status(500).json({ error: 'Failed to fix order totals.', details: err.message });
  }
}; 