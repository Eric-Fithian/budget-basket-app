import { GeoLocation } from './GeoLocation';
import { Item } from './Item';

class GroceryStore {
    location: GeoLocation;
    name: string;
    items: Item[];
    constructor(location: GeoLocation, name: string, items: Item[]) {
        this.location = location;
        this.name = name;
        this.items = items;
    }
}

export { GroceryStore };