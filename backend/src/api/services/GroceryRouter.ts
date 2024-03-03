import { KrogerService } from './KrogerService';
import { TargetService } from './TargetService'; // Import the missing module
import { StoreShoppingList } from './StoreShoppingList';
import { GeoLocation } from './GeoLocation';
import { Item } from './Item';

class GroceryRouter {
    private krogerService: KrogerService;
    private targetService: TargetService;
    private currentLocation: GeoLocation;
    private radius: number;
    constructor(currentLocation: GeoLocation, radius: number, krogerService: KrogerService, targetService: TargetService) {
        this.currentLocation = currentLocation;
        this.krogerService = krogerService;
        this.targetService = targetService;
        this.radius = radius;
    }

    public async processList(list: string[]): Promise<StoreShoppingList[]> {
        let targetShoppingList = new StoreShoppingList(await this.targetService.getClosestLocation(this.currentLocation, this.radius), 'Target', []);
        let krogerShoppingList = new StoreShoppingList(await this.krogerService.getClosestLocation(this.currentLocation, this.radius), 'Kroger', []);
        let notFoundShoppingList = new StoreShoppingList(new GeoLocation(0, 0), 'Not Found', []);
        let shoppingRoute: StoreShoppingList[] = [];
        for (const itemName of list) {
            const targetItems: Item[] = await this.targetService.searchForItem(itemName);
            const krogerItems: Item[] = await this.krogerService.searchForItem(itemName);

            console.log('targetItems:', targetItems);
            console.log('krogerItems:', krogerItems);

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
            
            const targetMedianPrice = calculateMedianPrice(targetItems);
            const krogerMedianPrice = calculateMedianPrice(krogerItems);

            console.log('targetMedianPrice:', targetMedianPrice);
            console.log('krogerMedianPrice:', krogerMedianPrice);

            if (targetItems.length === 0 && krogerItems.length === 0) {
                notFoundShoppingList.items.push(new Item(itemName, 0));
            }
            else if (krogerMedianPrice < targetMedianPrice) {
                krogerShoppingList.items.push(new Item(itemName, krogerMedianPrice));
            } else {
                targetShoppingList.items.push(new Item(itemName, targetMedianPrice));
            }
        }

        shoppingRoute.push(targetShoppingList, krogerShoppingList, notFoundShoppingList);

        // TODO: Find shortest path to visit all stores
        return shoppingRoute;
    }
}

export { GroceryRouter };