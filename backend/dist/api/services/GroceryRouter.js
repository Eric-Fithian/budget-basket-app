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
Object.defineProperty(exports, "__esModule", { value: true });
exports.GroceryRouter = void 0;
const StoreShoppingList_1 = require("./StoreShoppingList");
const GeoLocation_1 = require("./GeoLocation");
const Item_1 = require("./Item");
class GroceryRouter {
    constructor(currentLocation, radius, krogerService, targetService) {
        this.currentLocation = currentLocation;
        this.krogerService = krogerService;
        this.targetService = targetService;
        this.radius = radius;
    }
    processList(list) {
        return __awaiter(this, void 0, void 0, function* () {
            let targetShoppingList = new StoreShoppingList_1.StoreShoppingList(yield this.targetService.getClosestLocation(this.currentLocation, this.radius), 'Target', []);
            let krogerShoppingList = new StoreShoppingList_1.StoreShoppingList(yield this.krogerService.getClosestLocation(this.currentLocation, this.radius), 'Kroger', []);
            let notFoundShoppingList = new StoreShoppingList_1.StoreShoppingList(new GeoLocation_1.GeoLocation(0, 0), 'Not Found', []);
            let shoppingRoute = [];
            for (const itemName of list) {
                const targetItems = yield this.targetService.searchForItem(itemName);
                const krogerItems = yield this.krogerService.searchForItem(itemName);
                console.log('targetItems:', targetItems);
                console.log('krogerItems:', krogerItems);
                const calculateMedianPrice = (items) => {
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
                    }
                    else { // Odd number of items
                        // Middle number
                        return sortedItems[middleIndex].price;
                    }
                };
                const targetMedianPrice = calculateMedianPrice(targetItems);
                const krogerMedianPrice = calculateMedianPrice(krogerItems);
                console.log('targetMedianPrice:', targetMedianPrice);
                console.log('krogerMedianPrice:', krogerMedianPrice);
                if (targetItems.length === 0 && krogerItems.length === 0) {
                    notFoundShoppingList.items.push(new Item_1.Item(itemName, 0));
                }
                else if (krogerMedianPrice < targetMedianPrice) {
                    krogerShoppingList.items.push(new Item_1.Item(itemName, krogerMedianPrice));
                }
                else {
                    targetShoppingList.items.push(new Item_1.Item(itemName, targetMedianPrice));
                }
            }
            if (targetShoppingList.items.length > 0) {
                shoppingRoute.push(targetShoppingList);
            }
            if (krogerShoppingList.items.length > 0) {
                shoppingRoute.push(krogerShoppingList);
            }
            if (notFoundShoppingList.items.length > 0) {
                shoppingRoute.push(notFoundShoppingList);
            }
            // TODO: Find shortest path to visit all stores
            return shoppingRoute;
        });
    }
}
exports.GroceryRouter = GroceryRouter;
