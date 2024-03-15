"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Item = void 0;
class Item {
    constructor(name, description, img, groceryStoreName, distance, price, unitAmount, arbitraryUOM // Pass the arbitrary unit of measurement string
    ) {
        this.name = name;
        this.description = description;
        this.img = img;
        this.groceryStoreName = groceryStoreName;
        this.distance = distance;
        this.price = price;
        this.unitAmount = unitAmount; // This will be adjusted inside the convertAndNormalize function
        this.savings = 0;
        // New approach: Handle arbitrary UOM through conversion
        const { normalizedUOM, scaledUnitAmount } = this.convertAndNormalizeUOM(arbitraryUOM, unitAmount);
        this.unitOfMeasurement = normalizedUOM;
        this.unitAmount = scaledUnitAmount;
        this.normalizedPrice = this.calculateNormalizedPrice(price, this.unitAmount, this.unitOfMeasurement);
    }
    convertAndNormalizeUOM(arbitraryUOM, unitAmount) {
        let normalizedUOM;
        let conversionFactor = 1; // Default conversion factor is 1 (no conversion)
        // Convert the arbitrary UOM to a standard UOM and adjust the unitAmount accordingly
        switch (arbitraryUOM.toLowerCase()) {
            case "oz": // Assuming solid, converting to grams
                normalizedUOM = UnitOfMeasurement.G;
                conversionFactor = 28.3495; // 1 Oz is approximately 28.35 grams
                break;
            case "fl oz": // Converting to mL for liquids
                normalizedUOM = UnitOfMeasurement.ML;
                conversionFactor = 29.5735; // 1 fluid Oz is approximately 29.57 mL
                break;
            case "lb":
            case "pound":
            case "pounds":
                normalizedUOM = UnitOfMeasurement.G;
                conversionFactor = 453.592; // 1 pound is approximately 453.59 grams
                break;
            case "g":
                normalizedUOM = UnitOfMeasurement.G;
                conversionFactor = 1; // Direct conversion, 1 gram = 1 gram
                break;
            case "kg":
                normalizedUOM = UnitOfMeasurement.G;
                conversionFactor = 1000; // 1 kg is 1000 grams
                break;
            case "ml":
                normalizedUOM = UnitOfMeasurement.ML;
                conversionFactor = 1; // Direct conversion, 1 mL = 1 mL
                break;
            case "l":
            case "liter":
            case "litre":
                normalizedUOM = UnitOfMeasurement.ML;
                conversionFactor = 1000; // 1 liter is 1000 mL
                break;
            case "gal":
            case "gallon":
            case "gallons": // Assuming US gallons for liquids
                normalizedUOM = UnitOfMeasurement.ML;
                conversionFactor = 3785.41; // 1 US gallon is approximately 3785.41 mL
                break;
            case "qt":
            case "quart":
            case "quarts": // Assuming US quarts for liquids
                normalizedUOM = UnitOfMeasurement.ML;
                conversionFactor = 946.353; // 1 US quart is approximately 946.35 mL
                break;
            case "pt":
            case "pint":
            case "pints": // Assuming US pints for liquids
                normalizedUOM = UnitOfMeasurement.ML;
                conversionFactor = 473.176; // 1 US pint is approximately 473.18 mL
                break;
            case "cup":
            case "cups":
                normalizedUOM = UnitOfMeasurement.ML;
                conversionFactor = 240; // 1 US cup is approximately 240 mL
                break;
            case "tbsp":
            case "tablespoon":
            case "tablespoons":
                normalizedUOM = UnitOfMeasurement.ML;
                conversionFactor = 14.7868; // 1 US tablespoon is approximately 14.79 mL
                break;
            case "tsp":
            case "teaspoon":
            case "teaspoons":
                normalizedUOM = UnitOfMeasurement.ML;
                conversionFactor = 4.92892; // 1 US teaspoon is approximately 4.93 mL
                break;
            case "each": // Countable items, no conversion needed
                normalizedUOM = UnitOfMeasurement.EACH;
                conversionFactor = 1; // Keeping it 1 for consistency
                break;
            // Add more cases as necessary for different units
            default:
                throw new Error("Unsupported unit of measurement: ${uom}");
        }
        return {
            normalizedUOM,
            scaledUnitAmount: unitAmount * conversionFactor,
        };
    }
    calculateNormalizedPrice(price, unitAmount, uom) {
        // Assuming price normalization for 'each' doesn't change as it's a count, not a measure of volume/weight
        switch (uom) {
            case UnitOfMeasurement.ML:
                return price / unitAmount; // price per ml
            case UnitOfMeasurement.G:
                return price / unitAmount; // price per gram
            case UnitOfMeasurement.EACH:
                return price; // No change needed
            default:
                throw new Error("Invalid unit of measurement for normalization: ${uom}");
        }
    }
}
exports.Item = Item;
