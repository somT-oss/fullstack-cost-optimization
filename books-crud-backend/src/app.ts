import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import { sequelize } from './models/book.ts';   // <-- import sequelize
import { setBooksRoutes } from './routes/booksRoutes.js';

const app = express();
const PORT = process.env.PORT ? parseInt(process.env.PORT, 10) : 3000;

// ---------- Middleware ----------
app.use(bodyParser.json());
app.use(
  cors({
    origin: 'http://localhost:5500', // your frontend origin
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true,
  })
);

// Logging middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// ---------- Database connection ----------
(async () => {
  try {
    await sequelize.authenticate();
    await sequelize.sync(); // creates tables if they don't exist
    console.log('✅ Database connected & tables synced');

    // ---------- Routes ----------
    setBooksRoutes(app);

    app.listen(PORT, '0.0.0.0', () => {
      console.log(`🚀 Server is running on http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error('❌ Unable to connect to the database:', err);
    process.exit(1);
  }
})();
