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
exports.KrogerService = void 0;
const axios_1 = __importDefault(require("axios"));
const GeoLocation_1 = require("./GeoLocation");
const Item_1 = require("./Item");
class KrogerService {
    constructor(clientId, clientSecret) {
        this.accessToken = null;
        this.accessTokenExpiration = null;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.locationId = '';
    }
    getAccessToken() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.accessToken && this.accessTokenExpiration && new Date() < this.accessTokenExpiration) {
                return this.accessToken;
            }
            const params = new URLSearchParams();
            params.append('grant_type', 'client_credentials');
            params.append('scope', 'product.compact');
            try {
                const response = yield axios_1.default.post('https://api-ce.kroger.com/v1/connect/oauth2/token', params, {
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        Authorization: `Basic ${Buffer.from(`${this.clientId}:${this.clientSecret}`).toString('base64')}`,
                    },
                });
                this.accessToken = response.data.access_token;
                // Assuming the token expires in 3600 seconds (1 hour) as a common scenario
                this.accessTokenExpiration = new Date(new Date().getTime() + response.data.expires_in * 1000);
                return this.accessToken;
            }
            catch (error) {
                console.error('Error obtaining Kroger access token:', error);
                throw error;
            }
        });
    }
    getClosestLocation(currentLocation, radius) {
        return __awaiter(this, void 0, void 0, function* () {
            const accessToken = yield this.getAccessToken();
            const latitude = currentLocation.getLatitude();
            const longitude = currentLocation.getLongitude();
            try {
                const response = yield axios_1.default.get(`https://api-ce.kroger.com/v1/locations?filter.lat=${latitude}&filter.lon=${longitude}&filter.radiusInMiles=${radius}`, {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                });
                this.locationId = response.data.data[0].locationId;
                const closestLocation = new GeoLocation_1.GeoLocation(response.data.data[0].geolocation.latitude, response.data.data[0].geolocation.longitude);
                return closestLocation;
            }
            catch (error) {
                console.error('Error fetching Kroger locations:', error);
                throw error;
            }
        });
    }
    searchForItem(searchTerm) {
        return __awaiter(this, void 0, void 0, function* () {
            const accessToken = yield this.getAccessToken();
            try {
                const response = yield axios_1.default.get(`https://api-ce.kroger.com/v1/products?filter.term=${encodeURIComponent(searchTerm)}&filter.locationId=${this.locationId}`, {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                });
                console.log(response.data);
                if (response.data.data.length === 0) {
                    return [];
                }
                const items = response.data.data.map((item) => {
                    const price = item.items && item.items[0].price ? item.items[0].price.regular : null;
                    return new Item_1.Item(item.description, price);
                });
                // remove items with no price
                return items.filter((item) => item.price !== null && item.price !== undefined);
                return items;
            }
            catch (error) {
                console.error('Error fetching Kroger items:', error);
                throw error;
            }
        });
    }
}
exports.KrogerService = KrogerService;
