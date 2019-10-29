import 'dart:io';
import 'package:flutter/material.dart';
import 'Contato.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/pessoa_helper.dart';
import '../helper/login_helper.dart';
import '../utils/Dialogs.dart';
import '../ui/LoginScreen.dart';
import 'package:db_contatos_sqflite/helper/Api.dart';

class HomePage extends StatefulWidget {
  dynamic login_id;
  String token;

  HomePage(this.login_id, this.token);
  @override
  _HomePageState createState() => _HomePageState();
}

enum OrderOptions { orderaz, orderza, sair }

class _HomePageState extends State<HomePage> {
  Dialogs dialog = new Dialogs();
  LoginHelper helperLog = LoginHelper();
  PersonHelper helper = PersonHelper();
  List<Person> person = List();
  Api api = new Api();

  var isLoading = false;

  @override
  void initState(){
    super.initState();
    isLoading = true;
    _getAllPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contatos'),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton<OrderOptions>(
                itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                      const PopupMenuItem<OrderOptions>(
                        child: Text('Ordenar de A-Z'),
                        value: OrderOptions.orderaz,
                      ),
                      const PopupMenuItem<OrderOptions>(
                        child: Text('Ordenar de Z-A'),
                        value: OrderOptions.orderza,
                      ),
                      const PopupMenuItem<OrderOptions>(
                          child: Text('Sair'),
                          value: OrderOptions.sair,
                      )
                    ],
                onSelected: _orderList)
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showContactPage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),

        body:WillPopScope(
            child: (isLoading)
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: person.length,
                itemBuilder: (context, index) {
                  return _personCard(context, index);
                }),
            onWillPop: () {
              return null;
            })
    );

  }

  void _showContactPage({Person person}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Contato(
              contact: person,
                )));
    if (recContact != null) {
      if (person != null) {
        await api.atualizarContato(recContact,widget.login_id, widget.token);
      } else {
        await api.cadastroPerson(recContact,widget.login_id, widget.token);
      }
      _getAllPersons();
    }
  }

  Widget _personCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('Nome: ' + person[index].nome),
              subtitle: Text('Número: ' + person[index].telefone),
              trailing: Text((index+1).toString()),
            )),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _orderList(OrderOptions result) async{
    switch (result) {
      case OrderOptions.orderaz:
        person.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        person.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
      case OrderOptions.sair:
          await helperLog.deleteLogado();
          Navigator.pop(context);
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
    }
    setState(() {});
  }

  void _showOptions(BuildContext context, int index) {
    List<Widget> botoes = [];
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.phone_in_talk, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Ligar',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        launch("tel:${person[index].telefone}");
        Navigator.pop(context);
      },
    ));
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.edit, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Modificar',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
        _showContactPage(person: person[index]);
      },
    ));
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.delete, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Apagar',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        api.deletarContato(person[index].id, widget.token);
        setState(() {
          person.removeAt(index);
          Navigator.pop(context);
        });
      },
    ));
    dialog.showBottomOptions(context, botoes);
  }

  void _getAllPersons() async{
    api.contatos(widget.token).then((list) {
      setState(() {
        isLoading = false;
        person = list;
      });
    });
  }
}
