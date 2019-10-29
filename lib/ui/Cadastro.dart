import 'package:flutter/material.dart';
import '../helper/login_helper.dart';
import '../utils/Dialogs.dart';
import 'package:db_contatos_sqflite/helper/Api.dart';
import 'package:db_contatos_sqflite/ui/home.dart';


class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  Api api = new Api();

  LoginHelper helper = LoginHelper();
  Dialogs dialog = new Dialogs();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeFocus = FocusNode();

  final _formCadastro = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de usuário'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 60, left: 30, right: 30),
          child: Form(
            key: _formCadastro,
            child: Column(
              children: <Widget>[
                TextFormField(
                    decoration: InputDecoration(labelText: "Nome"),
                    focusNode: _nomeFocus,
                    controller: _nomeController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Digite seu nome';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
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
                  obscureText: true,
                  controller: _senhaController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Digite sua senha';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("Cadastrar"),
                        elevation: 3,
                        color: Colors.white,
                        textColor: Colors.blueAccent,
                        onPressed: () async {
                          if (_formCadastro.currentState.validate()) {
                            Login user = await api.saveCadastro(_nomeController.text,
                                _emailController.text, _senhaController.text);

                              if(user != null){
                                api.saveCadastro(_emailController.text, _senhaController.text, _nomeController.text);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(user.email,user.token)));
                              }else {
                              dialog.showAlertDialog(
                                  context, 'Aviso', 'Usuário não cadastrado');
                            }

                          }
                        }),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
