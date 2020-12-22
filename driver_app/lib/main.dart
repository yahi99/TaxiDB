import 'package:driver_app/providers/app_provider.dart';
import 'package:driver_app/providers/user.dart';
import 'package:driver_app/screens/login.dart';
import 'package:driver_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

import 'helpers/constants.dart';
import 'locators/service_locator.dart';
import 'screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  return runApp(
    provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<AppStateProvider>.value(
          value: AppStateProvider(),
        ),
        provider.ChangeNotifierProvider.value(
          value: UserProvider.initialize(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.deepOrange),
        title: "Flutter Taxi",
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider auth = provider.Provider.of<UserProvider>(context);

    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Something went wrong")],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          switch (auth.status) {
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginScreen();
            case Status.Authenticated:
              return MyHomePage();
            default:
              return LoginScreen();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
