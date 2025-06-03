exports.up = knex =>
  knex.schema.createTable('tables', t => {
    t.increments('id').primary();
    t.string('name', 50).notNullable().unique();   // e.g. "A1", "B2"
    t.integer('capacity').defaultTo(4);
    t.string('status', 20).defaultTo('EMPTY');     // EMPTY | OCCUPIED | RESERVED
    t.timestamps(true, true);
  });

exports.down = knex => knex.schema.dropTable('tables'); 