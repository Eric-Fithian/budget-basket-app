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
exports.TargetService = void 0;
const axios_1 = __importDefault(require("axios"));
const GeoLocation_1 = require("./GeoLocation");
class TargetService {
    constructor(apiKey, googleMapsApiKey) {
        this.apiKey = apiKey;
        this.googleMapsApiKey = googleMapsApiKey;
        this.zipCode = '';
    }
    getClosestLocation(currentLocation, radius) {
        return __awaiter(this, void 0, void 0, function* () {
            const latitude = currentLocation.getLatitude();
            const longitude = currentLocation.getLongitude();
            // use google maps api to get the closest target location
            // miles to meters
            const radiusInMeters = radius * 1609.34;
            console.log('latitude:', latitude);
            console.log('longitude:', longitude);
            const googleMapsPlacesURL = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&radius=${radiusInMeters}&type=department_store&keyword=Target&key=${this.googleMapsApiKey}`;
            try {
                const response = yield axios_1.default.get(googleMapsPlacesURL);
                if (response.data.results.length > 0) {
                    const closestTarget = response.data.results[0];
                    this.zipCode = closestTarget.vicinity.split(' ')[-1];
                    return new GeoLocation_1.GeoLocation(closestTarget.geometry.location.lat, closestTarget.geometry.location.lng);
                }
                else {
                    throw new Error('No Target locations found within the specified radius.');
                }
            }
            catch (error) {
                console.error('Error fetching closest Target location:', error);
                throw error;
            }
        });
    }
    searchForItem(searchTerm) {
        return __awaiter(this, void 0, void 0, function* () {
            const params = {
                api_key: this.apiKey,
                search_term: searchTerm,
                customer_zip: this.zipCode,
                type: "search"
            };
            try {
                const response = yield axios_1.default.get('https://api.redcircleapi.com/request', { params });
                if (response.data.search_results == undefined || response.data.search_results.length === 0) {
                    return [];
                }
                const items = response.data.search_results.map((result) => ({
                    title: result.product.title,
                    price: result.offers.primary.price
                }));
                // remove items with no price
                return items.filter((item) => item.price !== null && item.price !== undefined);
            }
            catch (error) {
                console.error('Error fetching items from Target:', error);
                throw error;
            }
        });
    }
}
exports.TargetService = TargetService;
