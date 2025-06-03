// 20250601_initial_schema.js
exports.up = function (knex) {
  return knex.schema
    .createTable('orders', tbl => {
      tbl.increments('id').primary();
      tbl.string('order_number', 20).notNullable();
      tbl.decimal('total', 10, 2).notNullable();
      tbl.string('status', 20).defaultTo('NEW');
      tbl.integer('table_id');
      tbl.integer('user_id');
      tbl.timestamps(true, true);
    })
    .then(() =>
      knex.schema.createTable('order_items', tbl => {
        tbl.increments('id').primary();
        tbl
          .integer('order_id')
          .references('orders.id')
          .onDelete('CASCADE');
        tbl.integer('product_id');
        tbl.integer('quantity').notNullable();
        tbl.decimal('price', 10, 2).notNullable();
        tbl.string('product_name', 255);
        tbl.decimal('total_price', 10, 2);
      }),
    )
    .then(() =>
      knex.schema.createTable('products', tbl => {
        tbl.increments('id').primary();
        tbl.string('name', 255).notNullable();
        tbl.decimal('price', 10, 2).notNullable();
        tbl.string('category_id', 255);
        tbl.integer('stock').defaultTo(0);
        tbl.boolean('is_active').defaultTo(true);
        tbl.timestamps(true, true);
      }),
    );
};

exports.down = function (knex) {
  return knex.schema
    .dropTableIfExists('order_items')
    .then(() => knex.schema.dropTableIfExists('orders'))
    .then(() => knex.schema.dropTableIfExists('products'));
};
