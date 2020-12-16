import 'package:driver_app/helpers/constants.dart';
import 'package:driver_app/models/user.dart';

class UserServices {
  String collection = "drivers";

  void createUser({
    String id,
    String dbId,
    String name,
    String email,
    String phone,
    String token,
    int votes = 0,
    int trips = 0,
    double rating = 0,
    Map position,
    String car,
    String plate,
    String passport,
    String driveLicense,
  }) {
    firebaseFiretore.collection(collection).doc(id).set({
      "name": name,
      "id": id,
      "dbId": dbId,
      "phone": phone,
      "email": email,
      "votes": votes,
      "trips": trips,
      "rating": rating,
      "position": position,
      "car": car,
      "plate": plate,
      "token": token,
      "passport": passport,
      "driveLicense": driveLicense,
    });
  }

  void updateUserData(Map<String, dynamic> values) {
    firebaseFiretore.collection(collection).doc(values['id']).update(values);
  }

  void addDeviceToken({String token, String userId}) {
    firebaseFiretore
        .collection(collection)
        .doc(userId)
        .update({"token": token});
  }

  Future<UserModel> getUserById(String id) =>
      firebaseFiretore.collection(collection).doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
