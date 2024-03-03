import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { KrogerService } from './api/services/KrogerService';
import { TargetService } from './api/services/TargetService';
import { CostcoService } from './api/services/CostcoService';
import { TraderjoesService } from './api/services/TraderjoesService';
import { GroceryRouter } from './api/services/GroceryRouter';
import { GeoLocation } from './api/services/GeoLocation';

// Initialize dotenv to use environment variables
dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());

// Example route
app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.post('/route', async (req, res) => {
  console.log("Request body: ", req.body);
  // get longitude, latitude, radius, and list of strings from request body
  const { latitude, longitude, radius, items } = req.body;
  const currentLocation = new GeoLocation(longitude, latitude);
  const krogerService = new KrogerService(process.env.KROGER_CLIENT_ID || '', process.env.KROGER_CLIENT_SECRET || '');
  const targetService = new TargetService(process.env.TARGET_API_KEY || '', process.env.GOOGLE_MAPS_API_KEY || '');
  const traderjoesService = new TraderjoesService(process.env.GOOGLE_MAPS_API_KEY || '');
  const costcoService = new CostcoService(process.env.GOOGLE_MAPS_API_KEY || '');
  const groceryRouter = new GroceryRouter(currentLocation, radius, krogerService, targetService, costcoService, traderjoesService);

  groceryRouter.processList(items).then((route) => {
    res.json(route);
  }).catch((error) => {
    res.status(500).json({ error: error.message });
  });
});
  

app.listen(process.env.PORT, () => {
    console.log(`Server is running on port ${process.env.PORT}`);
});
