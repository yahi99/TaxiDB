import 'package:driver_app/bloc/trip_bloc/trip_bloc.dart';
import 'package:driver_app/bloc/trip_bloc/trip_event.dart';
import 'package:driver_app/bloc/trip_bloc/trip_repository.dart';
import 'package:driver_app/bloc/trip_bloc/trip_state.dart';
import 'package:driver_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart' as provider;

class TripsHistoryScreen extends StatefulWidget {
  @override
  _TripsHistoryScreenState createState() => _TripsHistoryScreenState();

  TripsHistoryScreen();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripBloc(
        repository: TripRepositoryImpl(),
      ),
      child: TripHistoryPage(),
    );
  }
}

class TripHistoryPage extends StatefulWidget {
  @override
  _TripHistoryPageState createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  TripBloc tripBloc;
  @override
  void initState() {
    super.initState();
    tripBloc = BlocProvider.of<TripBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = provider.Provider.of<UserProvider>(context);
    tripBloc.add(
      FetchTripsEvent(
        userId: int.parse(userProvider?.userModel?.dbId),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("История поездок"),
      ),
      body: Builder(
        builder: (context) {
          return Container(
            child: BlocListener<TripBloc, TripState>(
              listener: (context, state) {
                if (state is TripErrorState) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              child: BlocBuilder<TripBloc, TripState>(
                builder: (context, state) {
                  return Container(child: widgetFromState(state));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget widgetFromState(TripState state) {
    if (state is TripInitialState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is TripLoadingState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is TripLoadedState) {
      return state.trips.length > 0
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )
          : Center(
              child: Text('Поездок не найдено!'),
            );
    } else if (state is TripErrorState) {
      return Center(
        child: Text(state.message),
      );
    }
  }
}
