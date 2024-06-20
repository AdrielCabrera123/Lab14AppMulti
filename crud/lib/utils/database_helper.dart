// lib/utils/database_helper.dart
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/person.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "MyDatabase.db");
    var db = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE Person(id INTEGER PRIMARY KEY, name TEXT, carrera TEXT, fechaIngreso INTEGER, age INTEGER)",
    );
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < 2) {
      // Ejemplo: agregar columna carrera
      db.execute("ALTER TABLE Person ADD COLUMN carrera TEXT");
    }
    // Añadir condiciones para otras actualizaciones si es necesario
  }

  Future<int> createPerson(Person person) async {
    var client = await db;
    return client.insert('Person', person.toMap());
  }

  Future<List<Person>> getPersons() async {
    var client = await db;
    List<Map<String, dynamic>> maps = await client.query('Person', columns: ['id', 'name', 'carrera', 'fechaIngreso', 'age']);
    List<Person> persons = [];
    if (maps.isNotEmpty) {
      persons = maps.map((map) => Person.fromMap(map)).toList();
    }
    return persons;
  }

  Future<int> updatePerson(Person person) async {
    var client = await db;
    return client.update('Person', person.toMap(),
        where: 'id = ?', whereArgs: [person.id]);
  }

  Future<void> deletePerson(int id) async {
    var client = await db;
    await client.delete('Person', where: 'id = ?', whereArgs: [id]);
  }
}
