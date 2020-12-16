import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_client/providers/app_state.dart';
import 'package:taxi_client/providers/user.dart';
import 'package:taxi_client/screens/login.dart';
import 'package:taxi_client/screens/splash.dart';

import 'locators/service_locator.dart';
import 'screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppStateProvider>.value(
          value: AppStateProvider(),
        ),
        ChangeNotifierProvider<UserProvider>.value(
          value: UserProvider.initialize(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taxi Client',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider auth = Provider.of<UserProvider>(context);
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
  }
}
