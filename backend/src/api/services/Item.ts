class Item {
    name: string;
    description: string;
    img: string;
    groceryStoreName: string;
    distance: number;
    price: number;
    savings: number;

    constructor(name: string, description: string, img: string, groceryStoreName: string, distance: number, price: number) {
        this.name = name;
        this.description = description;
        this.img = img;
        this.groceryStoreName = groceryStoreName;
        this.distance = distance;
        this.price = price;
        this.savings = 0;
    }
}

export { Item };