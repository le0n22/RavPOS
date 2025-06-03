// controllers/tablesController.js
const knex = require('../db/knex');

function toCamel(obj) {
  if (!obj) return obj;
  return Object.fromEntries(
    Object.entries(obj).map(([k, v]) => [
      k.replace(/_([a-z])/g, (_, c) => c.toUpperCase()),
      v
    ])
  );
}

exports.updateTable = async (req, res) => {
  try {
    const tableId = req.params.id;

    console.log('[DEBUG] Table Update Request Body:', req.body);

    // Güncellenecek veriler
    const updateData = {
      name: req.body.name,
      capacity: req.body.capacity,
      status: req.body.status,
      x_position: req.body.xPosition,
      y_position: req.body.yPosition,
      current_order_id: req.body.currentOrderId, // Sadece camelCase versiyonu kullan
      current_order_total: req.body.currentOrderTotal,
      last_occupied_time: req.body.lastOccupiedTime,
      updated_at: new Date().toISOString(),
      category: req.body.category
    };

    console.log('[DEBUG] Kaydedilecek current_order_id:', updateData.current_order_id);

    // Güncelleme işlemi
    await knex('tables')
      .where({ id: tableId })
      .update(updateData);

    // Güncellenmiş veriyi döndür
    const updatedTable = await knex('tables')
      .where({ id: tableId })
      .first();
    const camel = toCamel(updatedTable);
    res.json({
      ...camel,
      id: updatedTable.id.toString(),
      currentOrderId: updatedTable.current_order_id != null ? updatedTable.current_order_id.toString() : null,
      currentOrderTotal: updatedTable.current_order_total != null
        ? parseFloat(updatedTable.current_order_total)
        : null
    });

  } catch (err) {
    console.error('[ERROR] Table Update:', err);
    res.status(500).json({ 
      error: 'Table update failed',
      details: err.message // Hata detaylarını ekle
    });
  }
};

// controllers/tablesController.js
exports.getTables = async (req, res) => {
  try {
    const tables = await knex('tables').select('*').orderBy('name'); // Get all tables

    const tablesWithAccurateData = await Promise.all(
      tables.map(async (table) => {
        // Find all active orders for the current table
        // Define "active" statuses based on your application's logic
        const activeOrders = await knex('orders')
          .where({ table_id: table.id })
          .whereIn('status', ['pending', 'preparing', 'ready', 'paymentPending']);

        let totalAmount = 0;
        let finalStatus = 'available';
        let currentOrderIdToStore = null; // To store an active order ID if present

        if (activeOrders.length > 0) {
          // If there's at least one active order, the table is occupied
          finalStatus = 'occupied';
          currentOrderIdToStore = activeOrders[0].id; // Store one of the active order IDs
          
          const orderIds = activeOrders.map(o => o.id);

          // Calculate the total sum of all items from all active orders
          const sumResult = await knex('order_items')
            .whereIn('order_id', orderIds)
            .sum('total_price as total');
            
          if (sumResult && sumResult[0] && sumResult[0].total) {
            totalAmount = parseFloat(sumResult[0].total);
          }
        }

        // Update the table record to reflect dynamic state
        await knex('tables')
          .where({ id: table.id })
          .update({
            status: finalStatus,
            current_order_id: currentOrderIdToStore,
            current_order_total: totalAmount
          });

        return {
          ...table,
          status: finalStatus,
          current_order_total: totalAmount,
          current_order_id: currentOrderIdToStore
        };
      })
    );

    res.json(tablesWithAccurateData.map(row => {
      const camel = toCamel(row);
      return {
        ...camel,
        id: row.id.toString(), // Ensure ID is a string
        currentOrderId: row.current_order_id != null ? row.current_order_id.toString() : null,
        currentOrderTotal: row.current_order_total != null
          ? parseFloat(row.current_order_total)
          : 0
      };
    }));

  } catch (err) {
    console.error('[ERROR] Get Tables with Accurate Data:', err);
    res.status(500).json({ error: 'Failed to get tables with accurate data', details: err.message });
  }
};