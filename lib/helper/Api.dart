import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_helper.dart';
import 'pessoa_helper.dart';

const BASE_URL = "";

class Api {
  String token;
  Api(this.token);

  Future<Login> login(String email, String senha) async {
   http.Response response = await http.post( BASE_URL + "login", body: jsonEncode({"senha": senha,"email": email}),
        headers: {'token': token, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Login dadosJson = new Login.fromMap(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }

  }

  Future<List<Person>> contatos() async {
    http.Response response = await http.get(BASE_URL+'contatos/',headers: {'token': token, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      List<Person> pessoas =json.decode(response.body).map<Person>((map) {
        return Person.fromMap(map);
      }).toList();
      return pessoas;
    } else {
      return null;
    }
  }

  Future<Person> atualizarContato(String codigoContato) async {
    http.Response response = await http.patch(BASE_URL + "contatos/" + codigoContato,headers: {'token': token, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return new Person.fromMap(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> deletarContato(String codigoContato) async {
    http.Response response = await http.delete(BASE_URL + "contatos/" + codigoContato,headers: {'token': token, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}

