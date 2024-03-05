import { GeoLocation } from "./GeoLocation";
import { Item } from "./Item";

interface GroceryStoreService {
    getName(): string;
    getClosestLocation(currentLocation: GeoLocation, radius: number): Promise<GeoLocation>;
    searchForItem(searchTerm: string): Promise<Item[]>;
}

export { GroceryStoreService };