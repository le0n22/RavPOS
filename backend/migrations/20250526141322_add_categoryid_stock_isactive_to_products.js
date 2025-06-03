/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function(knex) {
  await knex.schema.table('products', function(table) {
    table.string('category_id');
    table.integer('stock').defaultTo(0);
    table.boolean('is_active').defaultTo(true);
  });
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = async function(knex) {
  await knex.schema.table('products', function(table) {
    table.dropColumn('category_id');
    table.dropColumn('stock');
    table.dropColumn('is_active');
  });
};
