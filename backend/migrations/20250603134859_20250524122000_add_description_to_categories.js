/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function (knex) {
  const hasDesc = await knex.schema.hasColumn('categories', 'description');
  if (!hasDesc) {
    return knex.schema.alterTable('categories', t => {
      t.string('description', 500);
    });
  }
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = knex =>
  knex.schema.alterTable('categories', t => {
    t.dropColumn('description');
  });
