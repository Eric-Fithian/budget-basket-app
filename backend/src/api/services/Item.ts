class Item {
    name: string;
    price: number;
    savings: number;
    constructor(name: string, price: number) {
        this.name = name;
        this.price = price;
        this.savings = 0;
    }
}

export { Item };