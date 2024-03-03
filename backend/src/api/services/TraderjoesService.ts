import axios from "axios";
import { Item } from "./Item";
import { GeoLocation } from "./GeoLocation";

class TraderjoesService {
    googleMapsApiKey: string;

    constructor(googleMapsApiKey: string) {
        this.googleMapsApiKey = googleMapsApiKey;
    }

    public async getClosestLocation(currentLocation: GeoLocation, radius: number): Promise<GeoLocation> {
        // Use Google Maps API to get the closest Trader Joe's location
        const latitude = currentLocation.getLatitude();
        const longitude = currentLocation.getLongitude();
        // Miles to meters
        const radiusInMeters = radius * 1609.34;
      
        const googleMapsPlacesURL = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&radius=${radiusInMeters}&type=grocery_or_supermarket&keyword=Trader+Joe's&key=${this.googleMapsApiKey}`;
      
        try {
          const response = await axios.get(googleMapsPlacesURL);
          if (response.data.results.length > 0) {
            const closestTraderJoes = response.data.results[0];
            return new GeoLocation(closestTraderJoes.geometry.location.lat, closestTraderJoes.geometry.location.lng);
          } else {
            throw new Error('No Trader Joe\'s locations found within the specified radius.');
          }
        } catch (error) {
          console.error('Error fetching closest Trader Joe\'s location:', error);
          throw error;
        }
      }

    public async searchForItem(searchTerm: string): Promise<Item[]> {
        const graphqlEndpoint = 'https://www.traderjoes.com/api/graphql'
        const query = `
          query SearchProducts($search: String, $pageSize: Int, $currentPage: Int, $storeCode: String = "301", $availability: String = "1", $published: String = "1") {
            products(
              search: $search
              filter: {store_code: {eq: $storeCode}, published: {eq: $published}, availability: {match: $availability}}
              pageSize: $pageSize
              currentPage: $currentPage
            ) {
              items {
                name
                price_range {
                  minimum_price {
                    final_price {
                      value
                    }
                  }
                }
              }
            }
          }`;
      
        const variables = {
          storeCode: "", // Optional: specify if needed
          availability: "1",
          published: "1",
          search: searchTerm,
          currentPage: 0,
          pageSize: 15 // Adjust the page size as needed
        };
      
        try {
          const response = await axios.post(graphqlEndpoint, {
            query,
            variables
          }, {
            headers: {
              'Content-Type': 'application/json',
              // Include any other headers your API requires
            }
          });
      
          const items = response.data.data.products.items;
          const formattedItems = items.map((item: any) => ({
            name: item.name,
            price: item.price_range.minimum_price.final_price.value
          }));
      
          return formattedItems;
        } catch (error) {
          console.error('Error fetching items:', error);
          throw error; // Or handle error as needed
        }
      }
}

export { TraderjoesService };