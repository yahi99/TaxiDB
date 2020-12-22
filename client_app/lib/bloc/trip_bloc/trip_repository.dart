import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../models/trip.dart';

abstract class TripRepository {
  Future<List<TripModel>> getTrips(int userId);
}

class TripRepositoryImpl implements TripRepository {
  @override
  Future<List<TripModel>> getTrips(int userId) async {
    var uri = Uri.http(apiUrl, '/get_all_trips_user/$userId');
    var response = await http.get(
      uri,
      headers: {"Content-Type": "application/json", "Connection": "keep-alive"},
    );
    if (response.statusCode == 200) {
      List<TripModel> list = new List<TripModel>();
      try {
        var data = json.decode(utf8.decode(response.bodyBytes));
        for (var item in data) {
          list.add(TripModel.fromJson(item));
        }
      } catch (e) {
        var msg = json.decode(response.body);
        throw Exception(msg['msg']);
      }
      return list;
    } else {
      throw Exception('Error! Status code: ${response.statusCode}');
    }
  }
}
