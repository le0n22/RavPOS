/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = knex =>
  knex.schema
    .createTable('categories', t => {
      t.increments('id').primary();
      t.string('name', 255).notNullable().unique();
      t.timestamps(true, true);
    })
    .then(() =>
      // link products.category_id -> categories.id  (nullable OK)
      knex.schema.alterTable('products', t => {
        t
          .integer('category_id')
          .references('categories.id')
          .onDelete('SET NULL')
          .alter();
      }),
    );

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = knex =>
  knex.schema
    .alterTable('products', t => {
      t.dropForeign('category_id');
    })
    .then(() => knex.schema.dropTableIfExists('categories'));
