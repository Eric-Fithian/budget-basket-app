"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const KrogerService_1 = require("./api/services/KrogerService");
const TargetService_1 = require("./api/services/TargetService");
const GroceryRouter_1 = require("./api/services/GroceryRouter");
const GeoLocation_1 = require("./api/services/GeoLocation");
// Initialize dotenv to use environment variables
dotenv_1.default.config();
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Example route
app.get('/', (req, res) => {
    res.send('Hello, World!');
});
app.post('/route', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    console.log("Request body: ", req.body);
    // get longitude, latitude, radius, and list of strings from request body
    const { latitude, longitude, radius, items } = req.body;
    const currentLocation = new GeoLocation_1.GeoLocation(longitude, latitude);
    const krogerService = new KrogerService_1.KrogerService(process.env.KROGER_CLIENT_ID || '', process.env.KROGER_CLIENT_SECRET || '');
    const targetService = new TargetService_1.TargetService(process.env.TARGET_API_KEY || '', process.env.GOOGLE_MAPS_API_KEY || '');
    const groceryRouter = new GroceryRouter_1.GroceryRouter(currentLocation, radius, krogerService, targetService);
    groceryRouter.processList(items).then((route) => {
        res.json(route);
    }).catch((error) => {
        res.status(500).json({ error: error.message });
    });
}));
app.listen(process.env.PORT, () => {
    console.log(`Server is running on port ${process.env.PORT}`);
});
