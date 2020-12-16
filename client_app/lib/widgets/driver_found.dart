import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_client/helpers/style.dart';
import 'package:taxi_client/locators/service_locator.dart';
import 'package:taxi_client/providers/app_state.dart';
import 'package:taxi_client/services/call_sms.dart';

import '../helpers/style.dart';
import 'custom_text.dart';

class DriverFoundWidget extends StatelessWidget {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.05,
        maxChildSize: 0.8,
        builder: (BuildContext context, myscrollController) {
          return Container(
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(.8),
                  offset: Offset(3, 2),
                  blurRadius: 7,
                ),
              ],
            ),
            child: ListView(
              controller: myscrollController,
              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: appState.driverArrived == false
                          ? CustomText(
                              text:
                                  'Водитель прибудет через ${appState.routeModel.timeNeeded.text}',
                              size: 12,
                              weight: FontWeight.w300,
                            )
                          : CustomText(
                              text: 'Водитель прибыл в указанную точку',
                              size: 12,
                              color: green,
                              weight: FontWeight.w500,
                            ),
                    ),
                  ],
                ),
                Divider(),
                ListTile(
                  leading: Container(
                    child: appState.driverModel?.phone == null
                        ? CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.person_outline,
                              size: 25,
                            ),
                          )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(appState.driverModel?.photo ?? ""),
                          ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: appState.driverModel.name + "\n",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: appState.driverModel.car,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ],
                          style: TextStyle(color: black),
                        ),
                      ),
                    ],
                  ),
                  subtitle: RaisedButton(
                    color: Colors.grey.withOpacity(0.5),
                    onPressed: null,
                    child: CustomText(
                      text: appState.driverModel.plate,
                      color: white,
                    ),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _service.call(appState.driverModel.phone);
                      },
                      icon: Icon(Icons.call),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomText(
                    text: "Информация о поездке",
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 100,
                      width: 10,
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Container(
                              height: 45,
                              width: 2,
                              color: primary,
                            ),
                          ),
                          Icon(Icons.flag),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Начало поездки:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${appState?.routeModel?.startAddress}\n",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Место назначение:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${appState?.routeModel?.endAddress}\n",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomText(
                        text: "Стоимость поездки",
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomText(
                        text: "\$${appState.ridePrice}",
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: RaisedButton(
                    onPressed: () {},
                    color: red,
                    child: CustomText(
                      text: "Отменить поездку",
                      color: white,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
