import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TripEvent extends Equatable {}

class FetchTripsEvent extends TripEvent {
  int userId;

  FetchTripsEvent({@required this.userId});

  @override
  List<Object> get props => null;
}
