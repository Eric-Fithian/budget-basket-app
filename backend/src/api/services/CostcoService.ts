import axios from 'axios';
import { GeoLocation } from './GeoLocation';
import { Item } from './Item';

class CostcoService {
    googleMapsApiKey: string;

    constructor(googleMapsApiKey: string) {
        this.googleMapsApiKey = googleMapsApiKey;
    }

    public async getClosestLocation(currentLocation: GeoLocation, radius: number) : Promise<GeoLocation> {
        const latitude = currentLocation.getLatitude();
        const longitude = currentLocation.getLongitude();
        // use google maps api to get the closest costco location
        // miles to meters
        const radiusInMeters = radius * 1609.34;

        console.log('latitude:', latitude);
        console.log('longitude:', longitude);

        const googleMapsPlacesURL = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&radius=${radiusInMeters}&type=department_store&keyword=Costco&key=${this.googleMapsApiKey}`;

        try {
            const response = await axios.get(googleMapsPlacesURL);
            if (response.data.results.length > 0) {
                const closestCostco = response.data.results[0];
                return new GeoLocation(closestCostco.geometry.location.lat, closestCostco.geometry.location.lng);
            } else {
                throw new Error('No Costco locations found within the specified radius.');
            }
        } catch (error) {
            console.error('Error fetching closest Costco location:', error);
            throw error;
        }
    }

    public async searchForItem(searchTerm: string): Promise<Item[]> {
        // Replace whitespaces with plus signs for URL compatibility
        const formattedSearchTerm = searchTerm.replace(/\s+/g, '+');
        const params = {
          platform: "costco_search",
          search: formattedSearchTerm
        };
    
        try {
          const response = await axios.get('https://data.unwrangle.com/api/getter/', { params });
          if (response.data.results === undefined || response.data.results.length === 0) {
            return [];
          }
          const items: Item[] = response.data.results.map((result: any) => ({
            name: result.name,
            price: result.price
          }));
          return items;
        } catch (error) {
          console.error('Error fetching items from Costco:', error);
          throw error;
        }
      }
}

export { CostcoService };