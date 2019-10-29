import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_helper.dart';
import 'pessoa_helper.dart';

const BASE_URL = "http://paulodir.site/rest/";

class Api {
  String token;
  Api({this.token});

  Future<Login> login(String email, String senha) async {
   http.Response response = await http.post( BASE_URL + "login", body: jsonEncode({"senha": senha,"email": email}));
    if (response.statusCode == 200) {
      Login dadosJson = new Login.fromMap(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }


  Future<Login> saveCadastro(String email, String senha, String nome) async {
    http.Response response = await http.post( BASE_URL + "login/cadastro", body: jsonEncode({"senha": senha,"email": email,"nome": nome}));
    if (response.statusCode == 200) {
      Login dadosJson = new Login.fromMap(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }



  Future<Person> cadastroPerson(
      Person person, int login_id, String token) async {
    http.Response response = await http.post(BASE_URL + "Contato",
        body: jsonEncode({
          "telefone": person.telefone,
          "nome": person.nome,
          "usuario_id": login_id
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Person dadosJson = new Person.fromJson(json.decode(response.body));
      return dadosJson;
    } else {
      return null;
    }
  }




  Future<List<Person>> contatos(String token) async {
    http.Response response = await http.get(BASE_URL + 'Contato',
        headers: {'token': token, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      List<Person> pessoas = json.decode(response.body).map<Person>((map) {
        return Person.fromJson(map);
      }).toList();
      return pessoas;
    } else {
      return null;
    }
  }

  Future<Person> atualizarContato(
      Person person, int login_id, String token) async {
    http.Response response = await http.put(BASE_URL + "Contato/" + person.id,
        body: jsonEncode({
          "telefone": person.telefone,
          "nome": person.nome,
          "usuario_id": login_id
        }),
        headers: {'token': token, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      print(response.body);
      return new Person.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> deletarContato(String codigoContato, String token) async {
    http.Response response = await http.delete(BASE_URL + "Contato/" + codigoContato,headers: {'token': token, 'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}

