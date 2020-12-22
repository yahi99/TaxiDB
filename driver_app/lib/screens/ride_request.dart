import 'package:driver_app/helpers/stars_method.dart';
import 'package:driver_app/helpers/style.dart';
import 'package:driver_app/providers/app_provider.dart';
import 'package:driver_app/providers/user.dart';
import 'package:driver_app/widgets/custom_btn.dart';
import 'package:driver_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart' as provider;

class RideRequestScreen extends StatefulWidget {
  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  @override
  void initState() {
    super.initState();
    AppStateProvider _state =
        provider.Provider.of<AppStateProvider>(context, listen: false);
    _state.listenToRequest(id: _state.rideRequestModel.id, context: context);
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = provider.Provider.of<AppStateProvider>(context);
    UserProvider userProvider = provider.Provider.of<UserProvider>(context);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: "Новая заявка на вызов",
          size: 19,
          weight: FontWeight.bold,
        ),
      ),
      backgroundColor: white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (appState.riderModel.photo == null)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(40)),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 45,
                      child: Icon(
                        Icons.person,
                        size: 65,
                        color: white,
                      ),
                    ),
                  ),
                if (appState.riderModel.photo != null)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(40)),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(appState.riderModel?.photo),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: appState.riderModel?.name ?? "Nada"),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Место назначение",
                    color: grey,
                  ),
                ],
              ),
              subtitle: FlatButton.icon(
                  onPressed: () async {
                    LatLng destinationCoordiates = LatLng(
                        appState.rideRequestModel.dLatitude,
                        appState.rideRequestModel.dLongitude);
                    appState.addLocationMarker(
                      destinationCoordiates,
                      appState.rideRequestModel?.destination ?? "",
                      "Место назначение",
                    );
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return Container(
                          height: 400,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: destinationCoordiates,
                              zoom: 13,
                            ),
                            onMapCreated: appState.onCreate,
                            myLocationEnabled: true,
                            mapType: MapType.normal,
                            tiltGesturesEnabled: true,
                            compassEnabled: false,
                            markers: appState.markers,
                            onCameraMove: appState.onCameraMove,
                            polylines: appState.poly,
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.location_on,
                  ),
                  label: CustomText(
                    text: appState.rideRequestModel?.destination ?? "",
                    weight: FontWeight.bold,
                  )),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.flag),
                    label: Text('Пользователь рядом с вами')),
                FlatButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.attach_money),
                    label: Text(
                        "${appState.rideRequestModel.distance.value / 500} ")),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomBtn(
                  text: "Принять",
                  onTap: () async {
                    if (appState.requestModelFirebase.status != "pending") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20.0,
                                ),
                              ),
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text:
                                            "Ошибка! Время заявки завершилось",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      appState.clearMarkers();
                      appState.acceptRequest(
                        requestId: appState.rideRequestModel.id,
                        requestDbId: appState.rideRequestModel.dbId,
                        driverId: userProvider.userModel.id,
                        driverDbID: userProvider.userModel.dbId,
                      );
                      appState.changeWidgetShowed(showWidget: Show.RIDER);
                      appState.sendRequest(
                        coordinates:
                            appState.requestModelFirebase.getCoordinates(),
                      );
                    }
                  },
                  bgColor: green,
                  shadowColor: Colors.greenAccent,
                ),
                CustomBtn(
                  text: "Отклонить",
                  onTap: () {
                    appState.clearMarkers();
                    appState.changeRideRequestStatus();
                  },
                  bgColor: red,
                  shadowColor: Colors.redAccent,
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
