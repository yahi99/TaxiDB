import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_client/helpers/screen_navigation.dart';
import 'package:taxi_client/helpers/style.dart';
import 'package:taxi_client/providers/app_state.dart';
import 'package:taxi_client/providers/user.dart';
import 'package:taxi_client/widgets/custom_text.dart';
import 'package:taxi_client/widgets/loading.dart';

import 'home.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    AppStateProvider app = Provider.of<AppStateProvider>(context);

    return Scaffold(
      key: _key,
      backgroundColor: Colors.deepOrange,
      body: authProvider.status == Status.Authenticating
          ? Loading()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: white,
                    height: 100,
                  ),
                  Container(
                    color: white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "images/lg.png",
                          width: 230,
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    color: white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: white),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: authProvider.name,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: white),
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: white),
                              labelText: "Имя пользователя",
                              hintText: "Петр Петров",
                              icon: Icon(
                                Icons.person,
                                color: white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: white),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: authProvider.email,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: white),
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: white),
                              labelText: "Электронная почта",
                              hintText: "example@mail.ru",
                              icon: Icon(
                                Icons.email,
                                color: white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: white),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: authProvider.phone,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: white),
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: white),
                              labelText: "Номер телефона",
                              hintText: "+78005553535",
                              icon: Icon(
                                Icons.phone,
                                color: white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: white),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: authProvider.password,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: white),
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: white),
                              labelText: "Пароль",
                              hintText: "Не менее 6 символов!",
                              icon: Icon(
                                Icons.lock,
                                color: white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () async {
                        if (!await authProvider.signUp()) {
                          _key.currentState.showSnackBar(SnackBar(
                              content: Text("Ошибка при регистрации!")));
                          return;
                        }
                        authProvider.clearController();
                        changeScreenReplacement(context, MyHomePage());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomText(
                                text: "Регистрация",
                                color: white,
                                size: 22,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeScreen(context, LoginScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomText(
                          text: "Авторизоваться",
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
