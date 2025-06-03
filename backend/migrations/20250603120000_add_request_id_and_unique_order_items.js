/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function(knex) {
  await knex.schema.alterTable('orders', function(table) {
    table.uuid('request_id').unique();
  });
  await knex.schema.alterTable('order_items', function(table) {
    table.unique(['order_id', 'product_id'], 'uq_order_item');
  });
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = async function(knex) {
  await knex.schema.alterTable('order_items', function(table) {
    table.dropUnique(['order_id', 'product_id'], 'uq_order_item');
  });
  await knex.schema.alterTable('orders', function(table) {
    table.dropColumn('request_id');
  });
}; 