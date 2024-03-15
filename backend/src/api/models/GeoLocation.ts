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

    distanceTo(other: GeoLocation): number {
        const R = 6371e3; // metres
        const φ1 = this.latitude * Math.PI / 180; // φ, λ in radians
        const φ2 = other.getLatitude() * Math.PI / 180;
        const Δφ = (other.getLatitude() - this.latitude) * Math.PI / 180;
        const Δλ = (other.getLongitude() - this.longitude) * Math.PI / 180;

        const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
            Math.cos(φ1) * Math.cos(φ2) *
            Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        const d = R * c; // in metres
        return d / 1609.34; // in miles
    }
}

export { GeoLocation };