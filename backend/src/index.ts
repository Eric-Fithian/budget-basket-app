import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { KrogerService } from './api/services/KrogerService';
import { TargetService } from './api/services/TargetService';
import { CostcoService } from './api/services/CostcoService';
import { TraderjoesService } from './api/services/TraderjoesService';
import { GroceryRouter } from './api/services/GroceryRouter';
import { GeoLocation } from './api/services/GeoLocation';
import { GroceryStoreService } from './api/services/GroceryStoreService';

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

  const cleanedItems = items.map((item: string) => 
    item.toLowerCase().replace(/[^a-z\s]/g, '')
);


  const currentLocation = new GeoLocation(latitude, longitude);

  let groceryServices: GroceryStoreService[] = [];
  groceryServices.push(new KrogerService(process.env.KROGER_CLIENT_ID || '', process.env.KROGER_CLIENT_SECRET || ''));
  // groceryServices.push(new TargetService(process.env.TARGET_API_KEY || '', process.env.GOOGLE_MAPS_API_KEY || ''));
  groceryServices.push(new TraderjoesService(process.env.GOOGLE_MAPS_API_KEY || ''));

  const groceryRouter = new GroceryRouter(currentLocation, radius, groceryServices);

  groceryRouter.processList(cleanedItems).then((route) => {
    console.log("Route: ", route);
    res.json(route);
  }).catch((error) => {
    res.status(500).json({ error: error.message });
  });
});
  

app.listen(process.env.PORT, () => {
    console.log(`Server is running on port ${process.env.PORT}`);
});
