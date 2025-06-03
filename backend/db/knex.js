const knex = require('knex');
const config = require('../knexfile.js'); // veya config yolunu kendi projenize göre ayarlayın

// Ortam değişkenine göre config seçimi (ör: development)
const env = process.env.NODE_ENV || 'development';
const knexInstance = knex(config[env]);

module.exports = knexInstance;