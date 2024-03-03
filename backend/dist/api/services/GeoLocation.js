"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GeoLocation = void 0;
class GeoLocation {
    constructor(longitude, latitude) {
        this.longitude = longitude;
        this.latitude = latitude;
    }
    // Getters and setters for longitude and latitude
    getLongitude() {
        return this.longitude;
    }
    setLongitude(longitude) {
        this.longitude = longitude;
    }
    getLatitude() {
        return this.latitude;
    }
    setLatitude(latitude) {
        this.latitude = latitude;
    }
}
exports.GeoLocation = GeoLocation;
