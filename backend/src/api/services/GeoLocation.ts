class GeoLocation {
    private longitude: number;
    private latitude: number;

    constructor(longitude: number, latitude: number) {
        this.longitude = longitude;
        this.latitude = latitude;
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