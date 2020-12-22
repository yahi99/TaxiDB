import 'package:bloc/bloc.dart';
import 'package:driver_app/models/trip.dart';
import 'package:flutter/cupertino.dart';

import 'trip_event.dart';
import 'trip_state.dart';
import 'trip_repository.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  TripRepository repository;

  TripBloc({@required this.repository}) : super(TripInitialState());

  @override
  Stream<TripState> mapEventToState(TripEvent event) async* {
    if (event is FetchTripsEvent) {
      yield TripLoadingState();
      try {
        List<TripModel> trips = await repository.getTrips(event.userId);
        yield TripLoadedState(trips: trips);
      } catch (e) {
        yield TripErrorState(message: e.toString());
      }
    }
  }
}
