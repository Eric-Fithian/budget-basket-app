import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

// Initialize dotenv to use environment variables
dotenv.config();

const db = require('./services/database');
const app = express();

app.use(cors());
app.use(express.json());

// Example route
app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.listen(process.env.PORT, () => {
    console.log(`Server is running on port ${process.env.PORT}`);
});
