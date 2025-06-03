/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async knex => {
  const add = (col, cb) =>
    knex.schema.hasColumn('tables', col).then(exists =>
      exists ? null : knex.schema.alterTable('tables', cb),
    );

  await add('x_position',         t => t.integer('x_position'));
  await add('y_position',         t => t.integer('y_position'));
  await add('last_occupied_time', t => t.timestamp('last_occupied_time'));
  await add('category',           t => t.string('category', 50));
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = knex =>
  knex.schema.alterTable('tables', t => {
    t.dropColumn('x_position');
    t.dropColumn('y_position');
    t.dropColumn('last_occupied_time');
    t.dropColumn('category');
  });
