import 'package:budget_basket/models/store_list.dart';
import 'package:geolocator/geolocator.dart';

class TravelingSalesMan {
  static int counter = 0;

  static double calculateTotalDistance(
      List<StoreList> path, double startLatitude, double startLongitude) {
    double totalDistance = 0.0;
    totalDistance += Geolocator.distanceBetween(startLatitude, startLongitude,
        path.first.location.latitude, path.first.location.longitude);
    for (int i = 0; i < path.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        path[i].location.latitude,
        path[i].location.longitude,
        path[i + 1].location.latitude,
        path[i + 1].location.longitude,
      );
    }

    counter++;
    // Return trip to the start
    totalDistance += Geolocator.distanceBetween(path.last.location.latitude,
        path.last.location.longitude, startLatitude, startLongitude);
    return totalDistance;
  }

  static void swap(List<StoreList> list, int i, int j) {
    StoreList temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  static void permute(
      List<StoreList> stores,
      int start,
      double startLatitude,
      double startLongitude,
      List<StoreList> shortestPath,
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

  static List<StoreList> travelingSalesmanBruteForce(
    List<StoreList> stores,
    double startLatitude,
    double startLongitude,
  ) {
    List<StoreList> shortestPath = [];
    List<double> shortestDistance = [double.infinity];
    counter = 0; // Reset counter at the beginning of the method call

    permute(stores, 0, startLatitude, startLongitude, shortestPath,
        shortestDistance);

    return shortestPath;
  }
}
