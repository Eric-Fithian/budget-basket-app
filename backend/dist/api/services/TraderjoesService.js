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
const Item_1 = require("../models/Item");
const GeoLocation_1 = require("../models/GeoLocation");
class TraderjoesService {
    constructor(googleMapsApiKey) {
        this.location = null;
        this.distance = null;
        this.appKey = "8BC3433A-60FC-11E3-991D-B2EE0C70A832";
        this.storeCode = "301";
        this.address = "";
        this.googleMapsApiKey = googleMapsApiKey;
    }
    getName() {
        return "TraderJoes";
    }
    getAddress() {
        return this.address;
    }
    initializeLocation(currentLocation, radius) {
        return __awaiter(this, void 0, void 0, function* () {
            this.location = yield this.getClosestLocation(currentLocation, radius);
            this.distance = currentLocation.distanceTo(this.location);
            return this.location;
        });
    }
    isInRange(radius) {
        return (this.location !== null && this.distance !== null && this.distance < radius);
    }
    getClosestLocation(currentLocation, radius) {
        return __awaiter(this, void 0, void 0, function* () {
            const requestBody = {
                request: {
                    appkey: this.appKey,
                    formdata: {
                        geoip: false,
                        dataview: "store_default",
                        limit: 1,
                        searchradius: radius.toString(),
                        geolocs: {
                            geoloc: [
                                {
                                    addressline: "",
                                    country: "US",
                                    latitude: currentLocation.getLatitude().toString(),
                                    longitude: currentLocation.getLongitude().toString(),
                                },
                            ],
                        },
                        where: {
                            warehouse: {
                                distinctfrom: "1",
                            },
                        },
                    },
                },
            };
            const config = {
                headers: {
                    "Content-Type": "application/json",
                },
            };
            try {
                const response = yield axios_1.default.post("https://alphaapi.brandify.com/rest/locatorsearch", requestBody, config);
                console.log(response.data);
                // Assuming the response structure has a way to determine the closest location
                // This part might need to be adjusted based on the actual API response structure
                if (response.data.response &&
                    response.data.response.collection &&
                    response.data.response.collection.length > 0) {
                    this.storeCode = response.data.response.collection[0].clientkey;
                    const latitude = response.data.response.collection[0].latitude;
                    const longitude = response.data.response.collection[0].longitude;
                    this.address =
                        response.data.response.collection[0].address1 +
                            ", " +
                            response.data.response.collection[0].city +
                            ", " +
                            response.data.response.collection[0].state +
                            " " +
                            response.data.response.collection[0].postalcode;
                    return new GeoLocation_1.GeoLocation(latitude, // Adjust these property paths based on actual response
                    longitude);
                }
                else {
                    throw new Error("No locations found within the specified radius.");
                }
            }
            catch (error) {
                console.error("Error fetching closest location:", error);
                throw error;
            }
            // GOOGLE MAPS VERSION
            // // Use Google Maps API to get the closest Trader Joe's location
            // const latitude = currentLocation.getLatitude();
            // const longitude = currentLocation.getLongitude();
            // // Miles to meters
            // const radiusInMeters = radius * 1609.34;
            // const googleMapsPlacesURL = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&radius=${radiusInMeters}&type=grocery_or_supermarket&keyword=Trader+Joe's&key=${this.googleMapsApiKey}`;
            // try {
            //   const response = await axios.get(googleMapsPlacesURL);
            //   if (response.data.results.length > 0) {
            //     const closestTraderJoes = response.data.results[0];
            //     return new GeoLocation(
            //       closestTraderJoes.geometry.location.lat,
            //       closestTraderJoes.geometry.location.lng
            //     );
            //   } else {
            //     throw new Error(
            //       "No Trader Joe's locations found within the specified radius."
            //     );
            //   }
            // } catch (error) {
            //   console.error("Error fetching closest Trader Joe's location:", error);
            //   throw error;
            // }
        });
    }
    searchForItem(searchTerm) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!this.location) {
                return [];
            }
            const graphqlEndpoint = "https://www.traderjoes.com/api/graphql";
            const query = `
          query SearchProducts($search: String, $pageSize: Int, $currentPage: Int, $storeCode: String, $availability: String = "1", $published: String = "1") {
            products(
              search: $search
              filter: {store_code: {eq: $storeCode}, published: {eq: $published}, availability: {match: $availability}}
              pageSize: $pageSize
              currentPage: $currentPage
            ) {
              items {
                item_title
                price_range {
                  minimum_price {
                    final_price {
                      value
                    }
                  }
                }
                sales_size
                sales_uom_description
                primary_image
              }
            }
          }`;
            const variables = {
                storeCode: this.storeCode,
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
                const items = response.data.data.products.items.map((item) => {
                    const name = item.item_title;
                    const description = "";
                    const img = "https://www.traderjoes.com" + item.primary_image;
                    const groceryStoreName = this.getName();
                    const distance = this.distance || 0;
                    const price = item.price_range.minimum_price.final_price.value;
                    const arbitraryUOM = item.sales_uom_description;
                    const unitAmount = item.sales_size;
                    return new Item_1.Item(name, description, img, groceryStoreName, distance, price, unitAmount, arbitraryUOM);
                });
                // remove items with no price
                return items.filter((item) => item.price !== null && item.price !== undefined && item.price > 0);
            }
            catch (error) {
                console.error("Error fetching items:", error);
                throw error; // Or handle error as needed
            }
        });
    }
}
exports.TraderjoesService = TraderjoesService;
