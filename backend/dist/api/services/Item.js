"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Item = void 0;
class Item {
    constructor(name, description, img, groceryStoreName, distance, price) {
        this.name = name;
        this.description = description;
        this.img = img;
        this.groceryStoreName = groceryStoreName;
        this.distance = distance;
        this.price = price;
        this.savings = 0;
    }
}
exports.Item = Item;
