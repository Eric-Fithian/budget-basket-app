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
// import { TargetService } from "./api/services/TargetService";
// import { CostcoService } from "./api/services/CostcoService";
const TraderjoesService_1 = require("./api/services/TraderjoesService");
// import { GroceryRouter } from "./api/services/GroceryRouter";
const GeoLocation_1 = require("./api/models/GeoLocation");
// Initialize dotenv to use environment variables
dotenv_1.default.config();
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Example route
app.get("/", (req, res) => {
    res.send("Hello, World!");
});
app.post("/search/items", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    console.log("Request body: ", req.body);
    // get longitude, latitude, radius, and list of strings from request body
    const { latitude, longitude, radiusInMiles, keyword } = req.body;
    let groceryServices = [];
    groceryServices.push(new KrogerService_1.KrogerService(process.env.KROGER_CLIENT_ID || "", process.env.KROGER_CLIENT_SECRET || ""));
    groceryServices.push(new TraderjoesService_1.TraderjoesService(process.env.GOOGLE_MAPS_API_KEY || ""));
    let items = [];
    const currentLocation = new GeoLocation_1.GeoLocation(latitude, longitude);
    for (let service of groceryServices) {
        yield service.initializeLocation(currentLocation, radiusInMiles);
        if (service.isInRange(radiusInMiles)) {
            console.log("Service is in range");
            let serviceItems = yield service.searchForItem(keyword);
            items = items.concat(serviceItems);
        }
    }
    console.log("Items: ", items);
    res.json(items);
}));
app.post("/search/stores", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    console.log("Request body: ", req.body);
    // get longitude, latitude, radius, and list of strings from request body
    const { latitude, longitude, radiusInMiles } = req.body;
    let groceryServices = [];
    groceryServices.push(new KrogerService_1.KrogerService(process.env.KROGER_CLIENT_ID || "", process.env.KROGER_CLIENT_SECRET || ""));
    groceryServices.push(new TraderjoesService_1.TraderjoesService(process.env.GOOGLE_MAPS_API_KEY || ""));
    let stores = [];
    const currentLocation = new GeoLocation_1.GeoLocation(latitude, longitude);
    for (let service of groceryServices) {
        const location = yield service.initializeLocation(currentLocation, radiusInMiles);
        if (service.isInRange(radiusInMiles)) {
            console.log("Service is in range");
            stores.push({
                name: service.getName(),
                location: location,
                address: service.getAddress(),
            });
        }
    }
    console.log("Stores: ", stores);
    res.json(stores);
}));
// app.post("/route", async (req, res) => {
//   console.log("Request body: ", req.body);
//   // get longitude, latitude, radius, and list of strings from request body
//   const { latitude, longitude, radius, items } = req.body;
//   const cleanedItems = items.map((item: string) =>
//     item.toLowerCase().replace(/[^a-z\s]/g, "")
//   );
//   const currentLocation = new GeoLocation(latitude, longitude);
//   let groceryServices: GroceryStoreService[] = [];
//   groceryServices.push(
//     new KrogerService(
//       process.env.KROGER_CLIENT_ID || "",
//       process.env.KROGER_CLIENT_SECRET || ""
//     )
//   );
//   // groceryServices.push(new TargetService(process.env.TARGET_API_KEY || '', process.env.GOOGLE_MAPS_API_KEY || ''));
//   groceryServices.push(
//     new TraderjoesService(process.env.GOOGLE_MAPS_API_KEY || "")
//   );
//   const groceryRouter = new GroceryRouter(
//     currentLocation,
//     radius,
//     groceryServices
//   );
//   groceryRouter
//     .processList(cleanedItems)
//     .then((route) => {
//       console.log("Route: ", route);
//       res.json(route);
//     })
//     .catch((error) => {
//       res.status(500).json({ error: error.message });
//     });
// });
app.listen(process.env.PORT, () => {
    console.log(`Server is running on port ${process.env.PORT}`);
});
