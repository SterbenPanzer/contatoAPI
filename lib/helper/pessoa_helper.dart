import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../utils/Strings.dart';
import '../helper/Databases.dart';

class PersonHelper {
  static final PersonHelper _instance = PersonHelper.internal();
  factory PersonHelper() => _instance;
  PersonHelper.internal();

  Databases databases = new Databases();

  /*Future<Person> savePerson(Person person,int login_id) async {
    Person person2 = person;
    Person novaPerson = Person();
    novaPerson.login_id = login_id;
    novaPerson.nome = person2.nome;
    novaPerson.telefone = person2.telefone;
    Database dbPerson = await databases.db;
    person.id = await dbPerson.insert(personTable, novaPerson.toMap());
    return person;
  }

  Future<Person> getPerson(int id) async {
    Database dbPerson = await databases.db;
    List<Map> maps = await dbPerson.query(personTable,
        columns: [idPersonColumn, nomePersonColumn, telefonePersonColumn],
        where: "$idPersonColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Person.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletePerson(int id) async {
    Database dbPerson = await databases.db;
    return await dbPerson.delete(personTable, where: "$idPersonColumn = ?", whereArgs: [id]);
  }

  Future<int> updatePerson(Person person,int login_id) async {
    Person person2 = person;
    Person novaPerson = Person();
    novaPerson.login_id = login_id;
    novaPerson.nome = person2.nome;
    novaPerson.telefone = person2.telefone;
    Database dbPerson = await databases.db;
    return await dbPerson.update(personTable,
        novaPerson.toMap(),
        where: "$idPersonColumn = ?",
        whereArgs: [person2.id]);
  }

  Future<List> getAllPersons(int login_id) async {
    Database dbPerson = await databases.db;
    List listMap = await dbPerson.rawQuery("SELECT * FROM $personTable WHERE login_id=$login_id");
    List<Person> listPerson = List();
    for(Map m in listMap){
      listPerson.add(Person.fromMap(m));
    }
    return listPerson;
  }
  */

  Future close() async {
    Database dbPerson = await databases.db;
    dbPerson.close();
  }

}

class Person {
  dynamic id;
  String nome;
  String telefone;
  dynamic usuario_id;


  Person({this.id, this.nome, this.telefone, this.usuario_id});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      usuario_id: json['usuario_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    return data;
  }


  @override
  String toString() {
    return "Person(id: $id, nome: $nome, telefone: $telefone, usuario_id: $usuario_id)";
  }
}