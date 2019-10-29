import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../utils/Strings.dart';
import '../helper/Databases.dart';
import 'dart:convert';


class LoginHelper {
  static final LoginHelper _instance = LoginHelper.internal();
  factory LoginHelper() => _instance;
  LoginHelper.internal();

  Databases databases = new Databases();


  /*Future<bool> saveCadastro(String nome, String email, String senha) async {
    Database dbLogin = await databases.db;
    Login login = new Login();
    login.nome = nome;
    login.email = email;
    login.senha = senha;
    if(await dbLogin.insert(loginTable, login.toMap())>0){
      return true;
    }else{
      return false;
    }

  }



  Future<Login> getLogin(String email,String senha) async {
    Database dbLogin = await databases.db;
    List<Map> maps = await dbLogin.query(loginTable,
        columns: [idLoginColumn, nomeLoginColumn, senhaLoginColumn],
        where: "$emailLoginColumn = ? AND $senhaLoginColumn = ?",
        whereArgs: [email,senha]);
    if(maps.length > 0){
      return Login.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteLogin(int id) async {
    Database dbLogin = await databases.db;
    return await dbLogin.delete(loginTable, where: "$idLoginColumn = ?", whereArgs: [id]);
  }

  Future<int> updateLogin(Login login) async {
    Database dbLogin = await databases.db;
    return await dbLogin.update(loginTable,
        login.toMap(),
        where: "$idLoginColumn = ?",
        whereArgs: [login.id]);
  }

  Future<List> getAllLogins() async {
    Database dbLogin = await databases.db;
    List listMap = await dbLogin.rawQuery("SELECT * FROM $loginTable");
    List<Login> listLogin = List();
    for(Map m in listMap){
      listLogin.add(Login.fromMap(m));
    }
    return listLogin;
  }
  */

  Future<bool> saveLogado(String login_id, String token) async {
    Database dbLogado = await databases.db;
    Logado logado = new Logado();
    logado.id=1;
    logado.logado_login_id = login_id;
    logado.token = token;
    if(await dbLogado.insert(logadoTable, logado.toMap())>0) {
      return true;
    }else{
      return false;
    }
  }

  Future<int> getLogadoid() async {
    Database dbLogado = await databases.db;
    List<Map> maps = await dbLogado.rawQuery("SELECT * FROM $logadoTable");
    if (maps.length > 0) {
      Logado usuariologado = Logado.fromMap(maps.first);
      return usuariologado.logado_login_id;
    } else {
      return null;
    }
  }

  Future<String> getLogado() async {
    Database dbLogado = await databases.db;
    List<Map> maps = await dbLogado.rawQuery("SELECT * FROM $logadoTable");
    if (maps.length > 0) {
      Logado usuariologado = Logado.fromMap(maps.first);
      return usuariologado.token;
    } else {
      return null;
    }
  }
    Future<int> deleteLogado() async {
    Database dbLogin = await databases.db;
    await dbLogin.delete(logadoTable);
    return 1;
  }

  Future close() async {
    Database dbLogin = await databases.db;
    dbLogin.close();
  }

}

class Logado {
  dynamic id;
  String token;
  dynamic logado_login_id;
  Logado();
  Logado.fromMap(Map map){
    id = map[idLogadoColumn];
    logado_login_id = map[login_idLogadoColumn];
    token = map[tokenColumn];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      idLoginColumn: id,
      tokenColumn: token,
      login_idLogadoColumn: logado_login_id
    };
    return map;
  }
}

class Login {
  int id;
  String token;
  String nome;
  String email;
  String senha;
  Login();
  Login.fromMap(Map map){
    id = int.parse(map[idLoginColumn]);
    email = map[emailLoginColumn];
    nome = map[nomeLoginColumn];
    senha = map[senhaLoginColumn];
    token = map[tokenColumn];
  }

  /* Map toMap() {
    Map<String, dynamic> map = {
      emailLoginColumn: email,
      nomeLoginColumn: nome,
      senhaLoginColumn: senha,
      tokenColumn: token
    };
    if (id != null) {
      map[idLoginColumn] = id;
    }
    return map;
  }
  */

  @override
  String toString() {
    return "Login(id: $id, name: $nome, email: $email, senha: $senha, token: $token)";
  }

}
