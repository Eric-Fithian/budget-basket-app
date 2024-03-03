import axios from 'axios';
import { GeoLocation } from './GeoLocation';
import { Item } from './Item';

class TargetService {
  private apiKey: string;
  private googleMapsApiKey: string;
  private zipCode: string;

  constructor(apiKey: string, googleMapsApiKey: string) {
    this.apiKey = apiKey;
    this.googleMapsApiKey = googleMapsApiKey;
    this.zipCode = '';
  }

  public async getClosestLocation(currentLocation: GeoLocation, radius: number) : Promise<GeoLocation> {
    const latitude = currentLocation.getLatitude();
    const longitude = currentLocation.getLongitude();
    // use google maps api to get the closest target location
    // miles to meters
    const radiusInMeters = radius * 1609.34;

    const googleMapsPlacesURL = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&radius=${radiusInMeters}&type=department_store&keyword=Target&key=${this.googleMapsApiKey}`;

    try {
      const response = await axios.get(googleMapsPlacesURL);
      if (response.data.results.length > 0) {
        const closestTarget = response.data.results[0];
        this.zipCode = closestTarget.vicinity.split(' ')[-1];
        return new GeoLocation(closestTarget.geometry.location.lat, closestTarget.geometry.location.lng);
      } else {
        throw new Error('No Target locations found within the specified radius.');
      }
    } catch (error) {
      console.error('Error fetching closest Target location:', error);
      throw error;
    }
  }


  public async searchForItem(searchTerm: string) : Promise<Item[]>{
    const params = {
      api_key: this.apiKey,
      search_term: searchTerm,
      customer_zip: this.zipCode,
      type: "search"
    };

    try {
      const response = await axios.get('https://api.redcircleapi.com/request', { params });
      if (response.data.search_results == undefined || response.data.search_results.length === 0) {
        return [];
      }
      const items: Item[] = response.data.search_results.map((result: any) => ({
        title: result.product.title,
        price: result.offers.primary.price
      }));
      // remove items with no price
      return items.filter((item) => item.price !== null && item.price !== undefined);
    } catch (error) {
      console.error('Error fetching items from Target:', error);
      throw error;
    }
  }
}


export { TargetService };