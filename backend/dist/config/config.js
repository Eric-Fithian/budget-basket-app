"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv_1 = __importDefault(require("dotenv"));
// Initialize dotenv
dotenv_1.default.config();
exports.default = {
    databaseURL: process.env.DATABASE_URL || "postgres://user:password@localhost:5432/mydatabase",
};
