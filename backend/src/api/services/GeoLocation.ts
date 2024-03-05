class GeoLocation {
    private latitude: number;
    private longitude: number;

    constructor(latitude: number, longitude: number) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    // Getters and setters for longitude and latitude
    getLongitude(): number {
        return this.longitude;
    }

    setLongitude(longitude: number): void {
        this.longitude = longitude;
    }

    getLatitude(): number {
        return this.latitude;
    }

    setLatitude(latitude: number): void {
        this.latitude = latitude;
    }
}

export { GeoLocation };