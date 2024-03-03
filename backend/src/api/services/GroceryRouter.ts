import { KrogerService } from './KrogerService';
import { TargetService } from './TargetService';
import { CostcoService } from './CostcoService';
import { TraderjoesService } from './TraderjoesService';
import { StoreShoppingList } from './StoreShoppingList';
import { GeoLocation } from './GeoLocation';
import { Item } from './Item';

class GroceryRouter {
    private krogerService: KrogerService;
    private targetService: TargetService;
    private costcoService: CostcoService;
    private currentLocation: GeoLocation;
    private traderjoesService: TraderjoesService;
    private radius: number;
    constructor(currentLocation: GeoLocation, radius: number, krogerService: KrogerService, targetService: TargetService, costcoService: CostcoService, traderjoesService: TraderjoesService) {
        this.currentLocation = currentLocation;
        this.krogerService = krogerService;
        this.targetService = targetService;
        this.costcoService = costcoService;
        this.traderjoesService = traderjoesService;
        this.radius = radius;
    }

    public async processList(list: string[]): Promise<StoreShoppingList[]> {
        let targetShoppingList = new StoreShoppingList(await this.targetService.getClosestLocation(this.currentLocation, this.radius), 'Target', []);
        let krogerShoppingList = new StoreShoppingList(await this.krogerService.getClosestLocation(this.currentLocation, this.radius), 'Kroger', []);
        // let costcoShoppingList = new StoreShoppingList(await this.costcoService.getClosestLocation(this.currentLocation, this.radius), 'Costco', []);
        let traderjoesShoppingList = new StoreShoppingList(await this.traderjoesService.getClosestLocation(this.currentLocation, this.radius), 'Trader Joes', []);
        let notFoundShoppingList = new StoreShoppingList(new GeoLocation(0, 0), 'Not Found', []);
        let shoppingRoute: StoreShoppingList[] = [];
        for (const itemName of list) {
            const targetItems: Item[] = await this.targetService.searchForItem(itemName);
            const krogerItems: Item[] = await this.krogerService.searchForItem(itemName);
            const traderjoesItems: Item[] = await this.traderjoesService.searchForItem(itemName);
            // const costcoItems: Item[] = await this.costcoService.searchForItem(itemName);

            console.log('targetItems:', targetItems);
            console.log('krogerItems:', krogerItems);
            console.log('traderjoesItems:', traderjoesItems);
            // console.log('costcoItems:', costcoItems);

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
            const traderjoesMedianPrice = calculateMedianPrice(traderjoesItems);
            // const costcoMedianPrice = calculateMedianPrice(costcoItems);

            console.log('targetMedianPrice:', targetMedianPrice);
            console.log('krogerMedianPrice:', krogerMedianPrice);
            console.log('traderjoesMedianPrice:', traderjoesMedianPrice);
            // console.log('costcoMedianPrice:', costcoMedianPrice);

            if (targetItems.length === 0 && krogerItems.length === 0 && traderjoesItems.length === 0) {
                notFoundShoppingList.items.push(new Item(itemName, 0));
            }
            else if (traderjoesMedianPrice < targetMedianPrice && traderjoesMedianPrice < krogerMedianPrice) {
                traderjoesShoppingList.items.push(new Item(itemName, traderjoesMedianPrice));
            }
            else if (krogerMedianPrice < targetMedianPrice) {
                krogerShoppingList.items.push(new Item(itemName, krogerMedianPrice));
            }
            else {
                targetShoppingList.items.push(new Item(itemName, targetMedianPrice));
            }
        }

        if (targetShoppingList.items.length > 0) {
            shoppingRoute.push(targetShoppingList);
        }
        if (krogerShoppingList.items.length > 0) {
            shoppingRoute.push(krogerShoppingList);
        }
        if (traderjoesShoppingList.items.length > 0) {
            shoppingRoute.push(traderjoesShoppingList);
        }
        if (notFoundShoppingList.items.length > 0) {
            shoppingRoute.push(notFoundShoppingList);
        }

        // TODO: Find shortest path to visit all stores
        return shoppingRoute;
    }
}

export { GroceryRouter };