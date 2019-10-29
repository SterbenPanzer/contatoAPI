import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/LoginScreen.dart';
import 'package:flutter/services.dart';
import 'helper/login_helper.dart';

void main() async{
  LoginHelper helper = LoginHelper();

  dynamic logado = await helper.getLogado();
  dynamic login_id = await helper.getLogadoid();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
      MaterialApp(
      home: (logado != null)?HomePage(logado,login_id):LoginScreen(),
      debugShowCheckedModeBanner: false,
    ));


}


