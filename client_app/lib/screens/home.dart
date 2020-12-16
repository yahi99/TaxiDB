import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:google_maps_webservice/places.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_client/helpers/constants.dart';
import 'package:taxi_client/helpers/screen_navigation.dart';
import 'package:taxi_client/helpers/style.dart';
import 'package:taxi_client/providers/app_state.dart';
import 'package:taxi_client/providers/user.dart';
import 'package:taxi_client/widgets/custom_text.dart';
import 'package:taxi_client/widgets/destination_selection.dart';
import 'package:taxi_client/widgets/driver_found.dart';
import 'package:taxi_client/widgets/loading.dart';
import 'package:taxi_client/widgets/payment_method_selection.dart';
import 'package:taxi_client/widgets/pickup_selection_widget.dart';
import 'package:taxi_client/widgets/trip_draggable.dart';

import '../helpers/style.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _deviceToken();
  }

  _deviceToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserProvider _user = Provider.of<UserProvider>(context, listen: false);

    if (_user.userModel?.token != preferences.getString('token')) {
      Provider.of<UserProvider>(context, listen: false).saveDeviceToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: CustomText(
                  text: userProvider.userModel?.name ?? "Имя не найдено",
                  size: 18,
                  weight: FontWeight.bold,
                ),
                accountEmail: CustomText(
                  text: userProvider.userModel?.email ?? "Почта не найдена",
                ),
              ),
              ListTile(
                leading: Icon(Icons.inbox),
                title: CustomText(text: "Отправить жалобу"),
                onTap: () {
                  // ToDo: сделать отправку жалобы
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: CustomText(text: "Выйти"),
                onTap: () {
                  userProvider.signOut();
                  changeScreenReplacement(
                    context,
                    LoginScreen(),
                  );
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            MapScreen(scaffoldState),
            Visibility(
              visible: appState.show == Show.DRIVER_FOUND,
              child: Positioned(
                top: 60,
                left: 15,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: appState.driverArrived
                            ? Container(
                                color: green,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: CustomText(
                                    text:
                                        "Ожидайте водителя на выбранной точке",
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container(
                                color: primary,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: CustomText(
                                    text:
                                        "Ожидайте водителя на выбранной точке",
                                    weight: FontWeight.w300,
                                    color: white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: appState.show == Show.TRIP,
              child: Positioned(
                top: 60,
                left: MediaQuery.of(context).size.width / 7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Container(
                          color: primary,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      "Вы прибудете в место назначение через \n",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                TextSpan(
                                  text: appState.routeModel?.timeNeeded?.text ??
                                      "",
                                  style: TextStyle(fontSize: 22),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ANCHOR Draggable
            Visibility(
              visible: appState.show == Show.DESTINATION_SELECTION,
              child: DestinationSelectionWidget(),
            ),
            // ANCHOR PICK UP WIDGET
            Visibility(
              visible: appState.show == Show.PICKUP_SELECTION,
              child: PickupSelectionWidget(
                scaffoldState: scaffoldState,
              ),
            ),
            //  ANCHOR Draggable PAYMENT METHOD
            Visibility(
              visible: appState.show == Show.PAYMENT_METHOD_SELECTION,
              child: PaymentMethodSelectionWidget(
                scaffoldState: scaffoldState,
              ),
            ),
            //  ANCHOR Draggable DRIVER
            Visibility(
              visible: appState.show == Show.DRIVER_FOUND,
              child: DriverFoundWidget(),
            ),

            //  ANCHOR Draggable DRIVER
            Visibility(
              visible: appState.show == Show.TRIP,
              child: TripWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  MapScreen(this.scaffoldState);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapsPlaces googlePlaces;
  TextEditingController destinationController = TextEditingController();
  Color darkBlue = Colors.black;
  Color grey = Colors.grey;
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    scaffoldSate = widget.scaffoldState;
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return appState.center == null
        ? Loading()
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: appState.center, zoom: 15),
                onMapCreated: appState.onCreate,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                polylines: appState.poly,
              ),
              Positioned(
                top: 10,
                left: 15,
                child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: primary,
                      size: 30,
                    ),
                    onPressed: () {
                      scaffoldSate.currentState.openDrawer();
                    }),
              ),
            ],
          );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
    }
  }
}
