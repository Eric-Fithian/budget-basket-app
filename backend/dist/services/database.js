"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.query = void 0;
const pg_1 = require("pg");
const config_1 = __importDefault(require("../config"));
const pool = new pg_1.Pool({
    connectionString: config_1.default.databaseURL,
});
const query = (text, params) => pool.query(text, params);
exports.query = query;
