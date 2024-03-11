import 'package:geolocator/geolocator.dart';
import 'package:grocery_getter/objects/StoreShoppingList.dart';

class TSM {
  static int counter = 0;

  static double calculateTotalDistance(List<StoreShoppingList> path,
      double startLatitude, double startLongitude) {
    double totalDistance = 0.0;
    totalDistance += Geolocator.distanceBetween(startLatitude, startLongitude,
        path.first.latitude, path.first.longitude);
    for (int i = 0; i < path.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        path[i].latitude,
        path[i].longitude,
        path[i + 1].latitude,
        path[i + 1].longitude,
      );
    }

    counter++;
    // Return trip to the start
    totalDistance += Geolocator.distanceBetween(
        path.last.latitude, path.last.longitude, startLatitude, startLongitude);
    return totalDistance;
  }

  static void swap(List<StoreShoppingList> list, int i, int j) {
    StoreShoppingList temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  static void permute(
      List<StoreShoppingList> stores,
      int start,
      double startLatitude,
      double startLongitude,
      List<StoreShoppingList> shortestPath,
      List<double> shortestDistance) {
    if (start == stores.length) {
      double currentDistance =
          calculateTotalDistance(stores, startLatitude, startLongitude);
      if (currentDistance < shortestDistance[0]) {
        shortestDistance[0] = currentDistance;
        shortestPath.clear();
        shortestPath.addAll(List.from(stores));
      }
      return;
    }

    for (int i = start; i < stores.length; i++) {
      swap(stores, start, i);
      permute(stores, start + 1, startLatitude, startLongitude, shortestPath,
          shortestDistance);
      swap(stores, start, i); // Swap back for backtracking
    }
  }

  static List<StoreShoppingList> travelingSalesmanBruteForce(
    List<StoreShoppingList> stores,
    double startLatitude,
    double startLongitude,
  ) {
    List<StoreShoppingList> shortestPath = [];
    List<double> shortestDistance = [double.infinity];
    counter = 0; // Reset counter at the beginning of the method call

    permute(stores, 0, startLatitude, startLongitude, shortestPath,
        shortestDistance);

    return shortestPath;
  }
}
