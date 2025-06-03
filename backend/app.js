require('dotenv').config();
const express = require('express');
const app = express();
const printerRoutes = require('./routes/printers');
const errorHandler = require('./middleware/errorHandler');

app.use(express.json());
app.use('/printers', printerRoutes);
app.use(errorHandler);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Printer API running on port ${PORT}`);
}); 