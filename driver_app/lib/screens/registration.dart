import 'package:driver_app/helpers/screen_navigation.dart';
import 'package:driver_app/helpers/style.dart';
import 'package:driver_app/providers/app_provider.dart';
import 'package:driver_app/providers/user.dart';
import 'package:driver_app/widgets/custom_text.dart';
import 'package:driver_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

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
    UserProvider authProvider = provider.Provider.of<UserProvider>(context);
    AppStateProvider app = provider.Provider.of<AppStateProvider>(context);

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
                              labelText: "ФИО",
                              hintText: "Иванов Иван Иванович",
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
                              hintText: "user@mail.ru",
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
                              hintText: "не менее 6 символов",
                              icon: Icon(
                                Icons.lock,
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
                          controller: authProvider.car,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: white),
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: white),
                              labelText: "Машина",
                              hintText: "Toyota Camry",
                              icon: Icon(
                                Icons.car_rental,
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
                          controller: authProvider.plate,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: white),
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: white),
                              labelText: "Гос номер",
                              hintText: "Н001НН048",
                              icon: Icon(
                                Icons.image,
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
                          controller: authProvider.passport,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: white),
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: white),
                              labelText: "Паспорт",
                              hintText: "4213852590",
                              icon: Icon(
                                Icons.confirmation_num_sharp,
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
                          controller: authProvider.driveLicense,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: white),
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: white),
                              labelText: "Номер ВУ",
                              hintText: "4213852590",
                              icon: Icon(
                                Icons.confirmation_num,
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
                        if (!await authProvider.signUp(app.position)) {
                          _key.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                "Ошибка регистрации!",
                              ),
                            ),
                          );
                          return;
                        }
                        authProvider.clearController();
                        changeScreenReplacement(
                          context,
                          MyHomePage(),
                        );
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
                                text: "Зарегестрироваться",
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
                      changeScreen(
                        context,
                        LoginScreen(),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomText(
                          text: "Перейти к авторизации",
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
