/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function (knex) {
  // 1) password_hash → password  (varsa)
  const hasPwdHash = await knex.schema.hasColumn('users', 'password_hash');
  if (hasPwdHash) {
    await knex.schema.alterTable('users', t => {
      t.renameColumn('password_hash', 'password');
    });
  }

  // 2) name sütunu yoksa ekle
  const hasName = await knex.schema.hasColumn('users', 'name');
  if (!hasName) {
    await knex.schema.alterTable('users', t => {
      t.string('name', 255);
    });
  }

  // 3) is_active sütunu yoksa ekle
  const hasActive = await knex.schema.hasColumn('users', 'is_active');
  if (!hasActive) {
    await knex.schema.alterTable('users', t => {
      t.boolean('is_active').defaultTo(true);
    });
  }
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = async function (knex) {
  // tersine çevirme (isteğe bağlı)
  const hasPwd = await knex.schema.hasColumn('users', 'password');
  if (hasPwd) {
    await knex.schema.alterTable('users', t => {
      t.renameColumn('password', 'password_hash');
    });
  }
  await knex.schema.alterTable('users', t => {
    t.dropColumn('name');
    t.dropColumn('is_active');
  });
};
