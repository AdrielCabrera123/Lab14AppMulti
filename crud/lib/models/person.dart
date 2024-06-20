// lib/models/person.dart
import 'package:intl/intl.dart';

class Person {
  int id;
  String name;
  String carrera;
  DateTime fechaIngreso;
  int age;

  Person({
    required this.id,
    required this.name,
    required this.carrera,
    required this.fechaIngreso,
    required this.age,
  });

  // Método para convertir un objeto Person a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'carrera': carrera,
      'fechaIngreso': fechaIngreso.millisecondsSinceEpoch,
      'age': age,
    };
  }

  // Método para crear un objeto Person desde un mapa
  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      name: map['name'],
      carrera: map['carrera'],
      fechaIngreso: DateTime.fromMillisecondsSinceEpoch(map['fechaIngreso']),
      age: map['age'],
    );
  }

  // Método para obtener la fecha de ingreso formateada como una cadena
  String formattedFechaIngreso() {
    return DateFormat('yyyy-MM-dd').format(fechaIngreso);
  }
}
