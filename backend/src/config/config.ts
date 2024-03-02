import dotenv from 'dotenv';

// Initialize dotenv
dotenv.config();

export default {
  databaseURL: process.env.DATABASE_URL || "postgres://user:password@localhost:5432/mydatabase",
};
