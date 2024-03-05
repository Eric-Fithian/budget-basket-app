import { GroceryStore } from './GroceryStore';
import { GeoLocation } from './GeoLocation';
import { Item } from './Item';
import { GroceryStoreService } from './GroceryStoreService';

class GroceryRouter {
    private currentLocation: GeoLocation;
    private groceryStoreServices: GroceryStoreService[];
    private radius: number;
    constructor(currentLocation: GeoLocation, radius: number, services: GroceryStoreService[]) {
        this.currentLocation = currentLocation;
        this.groceryStoreServices = services;
        this.radius = radius;
    }

    public async processList(list: string[]): Promise<GroceryStore[]> {
        let groceryStores: GroceryStore[] = [];

        for (const service of this.groceryStoreServices) {
            groceryStores.push(new GroceryStore(await service.getClosestLocation(this.currentLocation, this.radius), service.getName(), []));
        }

        for (const store of groceryStores) {
            console.log(store.name, "location: ", store.location);
        }

        let notFoundShoppingList = new GroceryStore(new GeoLocation(0, 0), 'Not Found', []);
        let shoppingRoute: GroceryStore[] = [];
        for (const itemName of list) {
            let itemResultsList: Item[][] = [];
            for (const service of this.groceryStoreServices) {
                const items = await service.searchForItem(itemName);
                const cleanedItems = this.cleanItemList(itemName, items);
                itemResultsList.push(cleanedItems);
            }
            
            // List to keep track of items and their estimated prices at each store
            let processedItems: Item[] = [];

            // Calculate median price for each list of results
            for (const items of itemResultsList) {
                processedItems.push(new Item(itemName, this.getEstimatedPrice(items)));
            }

            // get min median price
            let minPrice = Infinity;
            let secondMinPrice = Infinity;
            let minIndex = -1;
            let secondMinIndex = -1;
            let savings = 0;

            for (let i = 0; i < processedItems.length; i++) {
                if (processedItems[i].price < minPrice) {
                    // Update second lowest to current lowest before updating lowest
                    secondMinPrice = minPrice;
                    secondMinIndex = minIndex;
                    
                    // Update lowest to new lowest
                    minPrice = processedItems[i].price;
                    minIndex = i;
                } else if (processedItems[i].price < secondMinPrice && processedItems[i].price !== minPrice) {
                    // Update second lowest if current item's price is lower than second lowest but not equal to lowest
                    secondMinPrice = processedItems[i].price;
                    secondMinIndex = i;
                }
            }

            if (minIndex !== -1 && secondMinIndex !== -1) {
                savings = secondMinPrice - minPrice;
                processedItems[minIndex].savings = savings;
            }


            if (minIndex === -1) {
                notFoundShoppingList.items.push(new Item(itemName, 0));
            }
            else {
                groceryStores[minIndex].items.push(processedItems[minIndex]);
            }
        }

        for (const store of groceryStores) {
            if (store.items.length > 0) {
                shoppingRoute.push(store);
            }
        }
        if (notFoundShoppingList.items.length > 0) {
            shoppingRoute.push(notFoundShoppingList);
        }

        return shoppingRoute;
    }

    private cleanItemList(targetName: string, items: Item[]): Item[] {
        // Split the target name first, then clean each word separately
        console.log("Target name: ", targetName);
        console.log("Items: ", items);
        const targetWords = targetName.toLowerCase().split(/\s+/).map(word => word.replace(/\W/g, ''));
        let cleanedList: Item[] = [];
    
        items.forEach(item => {
            const cleanedItemString = item.name.toLowerCase().replace(/\W/g, '');
            let isClean = true;
    
            for (const word of targetWords) {
                if (!cleanedItemString.includes(word)) {
                    isClean = false;
                    break; // No need to check further words if one is not found
                }
            }
    
            if (isClean) {
                cleanedList.push(item);
            }
        });
    
        return cleanedList;
    }

    public getEstimatedPrice(items: Item[]): number {
        const calculateMedianPrice = (items: Item[]) => {
            if (items.length === 0) {
                return Infinity;
            }
            if (items.length === 1) {
                return items[0].price;
            }
            // Sort items by price in ascending order
            const sortedItems = items.sort((a, b) => a.price - b.price);
            const middleIndex = Math.floor(sortedItems.length / 2);
        
            if (sortedItems.length % 2 === 0) { // Even number of items
                // Average of the two middle numbers
                return (sortedItems[middleIndex - 1].price + sortedItems[middleIndex].price) / 2;
            } else { // Odd number of items
                // Middle number
                return sortedItems[middleIndex].price;
            }
        };

        return calculateMedianPrice(items);
    }
}

export { GroceryRouter };