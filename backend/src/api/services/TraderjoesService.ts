import axios from "axios";
import { Item } from "../models/Item";
import { GeoLocation } from "../models/GeoLocation";
import { GroceryStoreService } from "./GroceryStoreService";

class TraderjoesService implements GroceryStoreService {
  googleMapsApiKey: string;
  private location: GeoLocation | null = null;
  private distance: number | null = null;
  private appKey: string = "8BC3433A-60FC-11E3-991D-B2EE0C70A832";
  private storeCode: string = "301";
  private address: string = "";

  constructor(googleMapsApiKey: string) {
    this.googleMapsApiKey = googleMapsApiKey;
  }

  public getName(): string {
    return "TraderJoes";
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
    return (
      this.location !== null && this.distance !== null && this.distance < radius
    );
  }

  public async getClosestLocation(
    currentLocation: GeoLocation,
    radius: number
  ): Promise<GeoLocation> {
    const requestBody = {
      request: {
        appkey: this.appKey,
        formdata: {
          geoip: false,
          dataview: "store_default",
          limit: 1,
          searchradius: radius.toString(), // Assuming radius is already in the desired unit for the API
          geolocs: {
            geoloc: [
              {
                addressline: "", // Assuming address line is not required or can be left blank
                country: "US", // Assuming the country is known and fixed as "US"
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
      const response = await axios.post(
        "https://alphaapi.brandify.com/rest/locatorsearch",
        requestBody,
        config
      );

      // Assuming the response structure has a way to determine the closest location
      // This part might need to be adjusted based on the actual API response structure
      if (
        response.data.response &&
        response.data.response.collection &&
        response.data.response.collection.length > 0
      ) {
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
        return new GeoLocation(
          latitude, // Adjust these property paths based on actual response
          longitude
        );
      } else {
        throw new Error("No locations found within the specified radius.");
      }
    } catch (error) {
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
  }

  public async searchForItem(searchTerm: string): Promise<Item[]> {
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
      storeCode: this.storeCode, // Optional: specify if needed
      availability: "1",
      published: "1",
      search: searchTerm,
      currentPage: 0,
      pageSize: 10, // Adjust the page size as needed
    };

    try {
      const response = await axios.post(
        graphqlEndpoint,
        {
          query,
          variables,
        },
        {
          headers: {
            "Content-Type": "application/json",
            // Include any other headers your API requires
          },
        }
      );

      const items = response.data.data.products.items.map((item: any) => {
        const name = item.item_title;
        const description = null;
        const img = "https://www.traderjoes.com" + item.primary_image;
        const groceryStoreName = this.getName();
        const distance = this.distance || -1;
        const price = item.price_range.minimum_price.final_price.value;
        const arbitraryUOM = item.sales_uom_description;
        const unitAmount = item.sales_size;
        return new Item(
          name,
          description,
          img,
          groceryStoreName,
          distance,
          price,
          unitAmount,
          arbitraryUOM
        );
      });

      // remove items with no price
      return items.filter(
        (item: Item) =>
          item.price !== null && item.price !== undefined && item.price > 0
      );
    } catch (error) {
      console.error("Error fetching items:", error);
      throw error; // Or handle error as needed
    }
  }
}

export { TraderjoesService };
