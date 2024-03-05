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
exports.CostcoService = void 0;
const axios_1 = __importDefault(require("axios"));
const GeoLocation_1 = require("./GeoLocation");
class CostcoService {
    constructor(googleMapsApiKey) {
        this.googleMapsApiKey = googleMapsApiKey;
    }
    getClosestLocation(currentLocation, radius) {
        return __awaiter(this, void 0, void 0, function* () {
            const latitude = currentLocation.getLatitude();
            const longitude = currentLocation.getLongitude();
            // use google maps api to get the closest costco location
            // miles to meters
            const radiusInMeters = radius * 1609.34;
            console.log('latitude:', latitude);
            console.log('longitude:', longitude);
            const googleMapsPlacesURL = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&radius=${radiusInMeters}&type=department_store&keyword=Costco&key=${this.googleMapsApiKey}`;
            try {
                const response = yield axios_1.default.get(googleMapsPlacesURL);
                if (response.data.results.length > 0) {
                    const closestCostco = response.data.results[0];
                    return new GeoLocation_1.GeoLocation(closestCostco.geometry.location.lat, closestCostco.geometry.location.lng);
                }
                else {
                    throw new Error('No Costco locations found within the specified radius.');
                }
            }
            catch (error) {
                console.error('Error fetching closest Costco location:', error);
                throw error;
            }
        });
    }
    searchForItem(searchTerm) {
        return __awaiter(this, void 0, void 0, function* () {
            // Replace whitespaces with plus signs for URL compatibility
            const formattedSearchTerm = searchTerm.replace(/\s+/g, '+');
            const params = {
                platform: "costco_search",
                search: formattedSearchTerm
            };
            try {
                const response = yield axios_1.default.get('https://data.unwrangle.com/api/getter/', { params });
                if (response.data.results === undefined || response.data.results.length === 0) {
                    return [];
                }
                const items = response.data.results.map((result) => ({
                    name: result.name,
                    price: result.price
                }));
                return items;
            }
            catch (error) {
                console.error('Error fetching items from Costco:', error);
                throw error;
            }
        });
    }
}
exports.CostcoService = CostcoService;
