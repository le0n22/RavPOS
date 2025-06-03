/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function (knex) {
  const addCol = (name, cb) =>
    knex.schema.hasColumn('tables', name).then(exists => {
      if (!exists) {
        return knex.schema.alterTable('tables', cb);
      }
    });

  await addCol('status', tbl => tbl.string('status', 20).defaultTo('EMPTY'));
  await addCol('current_order_id', tbl => tbl.integer('current_order_id'));
  await addCol('current_order_total', tbl =>
    tbl.decimal('current_order_total', 10, 2),
  );
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = async function (knex) {
  await knex.schema.alterTable('tables', tbl => {
    tbl.dropColumn('status');
    tbl.dropColumn('current_order_id');
    tbl.dropColumn('current_order_total');
  });
};
