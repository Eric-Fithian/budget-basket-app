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
const GroceryStore_1 = require("./GroceryStore");
const GeoLocation_1 = require("./GeoLocation");
const Item_1 = require("./Item");
class GroceryRouter {
    constructor(currentLocation, radius, services) {
        this.currentLocation = currentLocation;
        this.groceryStoreServices = services;
        this.radius = radius;
    }
    processList(list) {
        return __awaiter(this, void 0, void 0, function* () {
            let groceryStores = [];
            for (const service of this.groceryStoreServices) {
                groceryStores.push(new GroceryStore_1.GroceryStore(yield service.getClosestLocation(this.currentLocation, this.radius), service.getName(), []));
            }
            for (const store of groceryStores) {
                console.log(store.name, " location: ", store.location);
            }
            let notFoundShoppingList = new GroceryStore_1.GroceryStore(new GeoLocation_1.GeoLocation(0, 0), 'Not Found', []);
            let shoppingRoute = [];
            for (const itemName of list) {
                let itemResultsList = [];
                for (const service of this.groceryStoreServices) {
                    const items = yield service.searchForItem(itemName);
                    itemResultsList.push(items);
                }
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
                // median item prices list
                let medianItems = [];
                // Calculate median price for each list of results
                for (const items of itemResultsList) {
                    medianItems.push(new Item_1.Item(itemName, calculateMedianPrice(items)));
                }
                // get min median price
                let minPrice = Infinity;
                let minIndex = -1;
                for (let i = 0; i < medianItems.length; i++) {
                    if (medianItems[i].price < minPrice) {
                        minPrice = medianItems[i].price;
                        minIndex = i;
                    }
                }
                if (minIndex === -1) {
                    notFoundShoppingList.items.push(new Item_1.Item(itemName, 0));
                }
                else {
                    groceryStores[minIndex].items.push(medianItems[minIndex]);
                }
            }
            for (const store of groceryStores) {
                if (store.items.length > 0) {
                    shoppingRoute.push(store);
                }
            }
            return shoppingRoute;
        });
    }
}
exports.GroceryRouter = GroceryRouter;
