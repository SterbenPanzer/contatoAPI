import 'package:flutter/material.dart';
import '../helper/login_helper.dart';
import 'home.dart';
import '../utils/Dialogs.dart';
import '../ui/Cadastro.dart';
import 'package:flutter/services.dart';
import'package:db_contatos_sqflite/helper/Api.dart';

class LoginScreen extends StatefulWidget {
  final Login login;
  LoginScreen({this.login});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 Api api = new Api();

 
  
  LoginHelper helper = LoginHelper();
  List<Login> login = List();
  Dialogs dialog = new Dialogs();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _emaiLFocus = FocusNode();

  final _formLogin = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[50],
      body: WillPopScope(
          child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 60, left: 30, right: 30),
              child: Form(
                key: _formLogin,
                child: Column(
                  children: <Widget>[
                    Image.asset('images/ic_launcher.png'),
                    TextFormField(
                        decoration: InputDecoration(labelText: "Email"),
                        focusNode: _emaiLFocus,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Digite seu email';
                          }
                          return null;
                        }),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Senha"),
                      keyboardType: TextInputType.visiblePassword,
                      controller: _senhaController,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Digite sua senha';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    RaisedButton(

                      child:
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.https),
                            Text("Entrar"),
                          ]
                      ),

                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_formLogin.currentState.validate()) {
                          Login user = await api.login(_emailController.text,

                              _senhaController.text);

                          if (user !=
                              null) {
                            api.token = user.id.toString();
                            Navigator.pop(context);
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(user.id,user.token)));
                          } else {
                            dialog.showAlertDialog(
                                context, 'Aviso', 'Login inválido');
                          }
                        }
                      },
                    ),
                    RaisedButton(

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.edit),
                            Text("Cadastrar")
                          ],
                        ),
                        color: Colors.white,
                        textColor: Colors.blueAccent,
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Cadastro()));
                        }),
                  ],
                ),
              )),
          onWillPop: (){
            SystemNavigator.pop();
          }
          ),
    );
  }
}
