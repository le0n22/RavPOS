/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function (knex) {
  const addCol = (name, cb) =>
    knex.schema.hasColumn('products', name).then(exists => {
      if (!exists) return knex.schema.alterTable('products', cb);
    });

  await addCol('description',      t => t.string('description', 500));
  await addCol('image_url',        t => t.string('image_url', 500));
  await addCol('preparation_time', t => t.integer('preparation_time'));
  await addCol('created_at',       t => t.timestamp('created_at'));
  await addCol('updated_at',       t => t.timestamp('updated_at'));
};


/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = knex =>
  knex.schema.alterTable('products', t => {
    t.dropColumn('description');
    t.dropColumn('image_url');
    t.dropColumn('preparation_time');
    t.dropColumn('created_at');
    t.dropColumn('updated_at');
  });
