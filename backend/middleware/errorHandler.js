function errorHandler(err, req, res, next) {
  console.error(err); // Use winston or similar in production
  res.status(500).json({ error: 'Internal server error' });
}
module.exports = errorHandler; 