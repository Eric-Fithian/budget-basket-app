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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TraderjoesService = void 0;
const axios_1 = __importDefault(require("axios"));
const GeoLocation_1 = require("./GeoLocation");
class TraderjoesService {
    constructor(googleMapsApiKey) {
        this.location = null;
        this.distance = null;
        this.googleMapsApiKey = googleMapsApiKey;
    }
    getName() {
        return "TraderJoes";
    }
    initializeLocation(currentLocation, radius) {
        return __awaiter(this, void 0, void 0, function* () {
            this.location = yield this.getClosestLocation(currentLocation, radius);
            this.distance = currentLocation.distanceTo(this.location);
        });
    }
    isInRange(radius) {
        return (this.location !== null && this.distance !== null && this.distance < radius);
    }
    getClosestLocation(currentLocation, radius) {
        return __awaiter(this, void 0, void 0, function* () {
            // Use Google Maps API to get the closest Trader Joe's location
            const latitude = currentLocation.getLatitude();
            const longitude = currentLocation.getLongitude();
            // Miles to meters
            const radiusInMeters = radius * 1609.34;
            const googleMapsPlacesURL = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&radius=${radiusInMeters}&type=grocery_or_supermarket&keyword=Trader+Joe's&key=${this.googleMapsApiKey}`;
            try {
                const response = yield axios_1.default.get(googleMapsPlacesURL);
                if (response.data.results.length > 0) {
                    const closestTraderJoes = response.data.results[0];
                    return new GeoLocation_1.GeoLocation(closestTraderJoes.geometry.location.lat, closestTraderJoes.geometry.location.lng);
                }
                else {
                    throw new Error("No Trader Joe's locations found within the specified radius.");
                }
            }
            catch (error) {
                console.error("Error fetching closest Trader Joe's location:", error);
                throw error;
            }
        });
    }
    searchForItem(searchTerm) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.location) {
                return [];
            }
            const graphqlEndpoint = "https://www.traderjoes.com/api/graphql";
            const query = `
          query SearchProducts($search: String, $pageSize: Int, $currentPage: Int, $storeCode: String = "301", $availability: String = "1", $published: String = "1") {
            products(
              search: $search
              filter: {store_code: {eq: $storeCode}, published: {eq: $published}, availability: {match: $availability}}
              pageSize: $pageSize
              currentPage: $currentPage
            ) {
              items {
                name
                price_range {
                  minimum_price {
                    final_price {
                      value
                    }
                  }
                }
              }
            }
          }`;
            const variables = {
                storeCode: "",
                availability: "1",
                published: "1",
                search: searchTerm,
                currentPage: 0,
                pageSize: 10, // Adjust the page size as needed
            };
            try {
                const response = yield axios_1.default.post(graphqlEndpoint, {
                    query,
                    variables,
                }, {
                    headers: {
                        "Content-Type": "application/json",
                        // Include any other headers your API requires
                    },
                });
                const items = response.data.data.products.items;
                const formattedItems = items.map((item) => ({
                    name: item.name,
                    price: item.price_range.minimum_price.final_price.value,
                    groceryStoreName: this.getName(),
                    distance: this.distance,
                }));
                return formattedItems;
            }
            catch (error) {
                console.error("Error fetching items:", error);
                throw error; // Or handle error as needed
            }
        });
    }
}
exports.TraderjoesService = TraderjoesService;
