import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:taxi_client/models/trip.dart';

abstract class TripState extends Equatable {}

class TripInitialState extends TripState {
  @override
  List<Object> get props => [];
}

class TripLoadingState extends TripState {
  @override
  List<Object> get props => [];
}

class TripLoadedState extends TripState {
  List<TripModel> trips;

  TripLoadedState({@required this.trips});

  @override
  List<Object> get props => [trips];
}

class TripErrorState extends TripState {
  String message;

  TripErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
