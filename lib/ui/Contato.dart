import 'dart:async';
import 'package:flutter/material.dart';
import '../helper/pessoa_helper.dart';

class Contato extends StatefulWidget {
  final Person contact;
  final login_id;
  Contato({this.contact, this.login_id});

  @override
  _ContatoState createState() => _ContatoState();
}

class _ContatoState extends State<Contato> {
  final _nameController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _nameFocus = FocusNode();

  final _formContato = GlobalKey<FormState>();

  Person _editedContact;
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Person();
    } else {
      _editedContact = Person.fromJson(widget.contact.toJson());
      _nameController.text = _editedContact.nome;
      _telefoneController.text = _editedContact.telefone;
      _editedContact.usuario_id = widget.login_id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text(_editedContact.nome ?? 'Novo contato'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                if (_formContato.currentState.validate()) {
                  Navigator.pop(context, _editedContact);
                }
              }),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formContato,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        decoration: InputDecoration(labelText: "Nome"),
                        focusNode: _nameFocus,
                        onChanged: (text) {
                          _userEdited = true;
                          _editedContact.nome = text;
                        },
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Digite o nome do seu contato';
                          }
                          return null;
                        }),
                    TextFormField(
                        decoration: InputDecoration(labelText: "Telefone"),
                        onChanged: (text) {
                          _userEdited = true;
                          _editedContact.telefone = text;
                        },
                        keyboardType: TextInputType.number,
                        controller: _telefoneController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Digite o telefone do seu contato';
                          }
                          return null;
                        }),
                  ],
                ),
              )),
        ));
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar alterações?'),
              content: Text('Se sair as alterações serão perdidas.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
