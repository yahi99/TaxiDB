import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taxi_client/helpers/constants.dart';

class RideRequestServices {
  String collection = "requests";

  void createRideRequest({
    String id,
    String dbId,
    String userId,
    String userDbId,
    String username,
    Map<String, dynamic> destination,
    Map<String, dynamic> position,
    Map distance,
  }) {
    firebaseFiretore.collection(collection).document(id).setData({
      "username": username,
      "id": id,
      "dbId": dbId,
      "userId": userId,
      "userDbId": userDbId,
      "driverId": "",
      "position": position,
      "status": 'pending',
      "destination": destination,
      "distance": distance
    });
  }

  void updateRequest(Map<String, dynamic> values) {
    firebaseFiretore
        .collection(collection)
        .document(values['id'])
        .updateData(values);
  }

  Stream<QuerySnapshot> requestStream() {
    CollectionReference reference = Firestore.instance.collection(collection);
    return reference.snapshots();
  }
}
