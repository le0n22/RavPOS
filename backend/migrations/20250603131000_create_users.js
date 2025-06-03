exports.up = knex =>
  knex.schema.createTable('users', tbl => {
    tbl.increments('id').primary();
    tbl.string('username', 100).notNullable().unique();
    tbl.string('password_hash', 255).notNullable();
    tbl.string('role', 20).defaultTo('STAFF');
    tbl.timestamps(true, true);
  });

exports.down = knex => knex.schema.dropTableIfExists('users'); 