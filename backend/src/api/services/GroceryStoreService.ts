import { GeoLocation } from "./GeoLocation";
import { Item } from "./Item";

interface GroceryStoreService {
  getName(): string;
  initializeLocation(
    currentLocation: GeoLocation,
    radius: number
  ): Promise<void>;
  getClosestLocation(
    currentLocation: GeoLocation,
    radius: number
  ): Promise<GeoLocation>;
  isInRange(radius: number): boolean;
  searchForItem(searchTerm: string): Promise<Item[]>;
}

export { GroceryStoreService };
