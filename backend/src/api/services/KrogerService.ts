import axios from "axios";
import { GeoLocation } from "./GeoLocation";
import { Item } from "./Item";
import { GroceryStoreService } from "./GroceryStoreService";

class KrogerService implements GroceryStoreService {
  private clientId: string;
  private clientSecret: string;
  private accessToken: string | null = null;
  private accessTokenExpiration: Date | null = null;
  private locationId: string;
  private location: GeoLocation | null = null;
  private distance: number | null = null;
  private address: string = "";
  private chainName: string = "Kroger";

  constructor(clientId: string, clientSecret: string) {
    this.clientId = clientId;
    this.clientSecret = clientSecret;
    this.locationId = "";
  }

  public getName(): string {
    return this.chainName;
  }

  public getAddress(): string {
    return this.address;
  }

  public async initializeLocation(
    currentLocation: GeoLocation,
    radius: number
  ): Promise<GeoLocation> {
    this.location = await this.getClosestLocation(currentLocation, radius);
    this.distance = currentLocation.distanceTo(this.location);
    return this.location;
  }

  public isInRange(radius: number): boolean {
    return this.distance !== null && this.distance < radius;
  }

  private async getAccessToken(): Promise<string> {
    if (
      this.accessToken &&
      this.accessTokenExpiration &&
      new Date() < this.accessTokenExpiration
    ) {
      return this.accessToken;
    }

    const params = new URLSearchParams();
    params.append("grant_type", "client_credentials");
    params.append("scope", "product.compact");

    try {
      const response = await axios.post(
        "https://api-ce.kroger.com/v1/connect/oauth2/token",
        params,
        {
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            Authorization: `Basic ${Buffer.from(
              `${this.clientId}:${this.clientSecret}`
            ).toString("base64")}`,
          },
        }
      );

      this.accessToken = response.data.access_token;
      // Assuming the token expires in 3600 seconds (1 hour) as a common scenario
      this.accessTokenExpiration = new Date(
        new Date().getTime() + response.data.expires_in * 1000
      );

      return this.accessToken as string;
    } catch (error) {
      console.error("Error obtaining Kroger access token:", error);
      throw error;
    }
  }

  public async getClosestLocation(
    currentLocation: GeoLocation,
    radius: number
  ): Promise<GeoLocation> {
    const accessToken = await this.getAccessToken();

    const latitude = currentLocation.getLatitude();
    const longitude = currentLocation.getLongitude();

    try {
      const response = await axios.get(
        `https://api-ce.kroger.com/v1/locations?filter.latLong.near=${latitude},${longitude}&filter.radiusInMiles=${radius}`,
        {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        }
      );
      // console.log('Kroger locations:')
      // for (const location of response.data.data) {
      //   console.log(location.name, location.geolocation.latitude, location.geolocation.longitude);
      // }

      console.log("Kroger Data Location:", response.data.data[0]);

      this.locationId = response.data.data[0].locationId;
      const closestLocation: GeoLocation = new GeoLocation(
        response.data.data[0].geolocation.latitude,
        response.data.data[0].geolocation.longitude
      );
      this.address =
        response.data.data[0].address.addressLine1 +
        ", " +
        response.data.data[0].address.city +
        ", " +
        response.data.data[0].address.state +
        " " +
        response.data.data[0].address.zipCode;

      this.chainName = response.data.data[0].chain;
      return closestLocation;
    } catch (error) {
      console.error("Error fetching Kroger locations:", error);
      throw error;
    }
  }

  public async searchForItem(searchTerm: string): Promise<Item[]> {
    if (!this.location) {
      return [];
    }

    const accessToken = await this.getAccessToken();

    try {
      const response = await axios.get(
        `https://api-ce.kroger.com/v1/products?filter.term=${encodeURIComponent(
          searchTerm
        )}&filter.locationId=${this.locationId}`,
        {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        }
      );
      if (response.data.data.length === 0) {
        return [];
      }
      const items: Item[] = response.data.data.map((item: any) => {
        const price =
          item.items && item.items[0].price
            ? item.items[0].price.regular
            : null;

        const img =
          item.images && item.images[1] && item.images[1].sizes[0].url
            ? item.images[1].sizes[0].url
            : null;
        return {
          name: item.description,
          price: price,
          img: img,
          groceryStoreName: this.getName(),
          distance: this.distance,
        };
      });
      // remove items with no price
      return items.filter(
        (item) => item.price !== null && item.price !== undefined
      );
    } catch (error) {
      console.error("Error fetching Kroger items:", error);
      throw error;
    }
  }
}

export { KrogerService };
