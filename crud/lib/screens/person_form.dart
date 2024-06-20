// lib/screens/person_form.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import '../models/person.dart';
import '../utils/database_helper.dart';

class PersonForm extends StatefulWidget {
  final Person? person;

  PersonForm(this.person);

  @override
  _PersonFormState createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DBHelper();
  late TextEditingController _nameController;
  late TextEditingController _carreraController;
  late TextEditingController _fechaIngresoController;
  late TextEditingController _ageController;
  late DateTime _selectedDate = DateTime.now(); // Fecha seleccionada

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.person?.name ?? '');
    _carreraController = TextEditingController(text: widget.person?.carrera ?? '');
    _fechaIngresoController = TextEditingController(
        text: widget.person != null ? DateFormat('yyyy-MM-dd').format(widget.person!.fechaIngreso) : '');
    _ageController = TextEditingController(text: widget.person?.age.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _carreraController.dispose();
    _fechaIngresoController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person == null ? 'Agregar Persona' : 'Editar Persona'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _carreraController,
                decoration: InputDecoration(labelText: 'Carrera'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _fechaIngresoController,
                    decoration: InputDecoration(labelText: 'Fecha Ingreso'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _savePerson();
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _fechaIngresoController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  void _savePerson() async {
    String name = _nameController.text;
    String carrera = _carreraController.text;
    DateTime fechaIngreso = _selectedDate;
    int age = int.parse(_ageController.text);
    if (widget.person == null) {
      await dbHelper.createPerson(Person(
        id: 0,
        name: name,
        carrera: carrera,
        fechaIngreso: fechaIngreso,
        age: age,
      ));
    } else {
      Person updatedPerson = Person(
        id: widget.person!.id,
        name: name,
        carrera: carrera,
        fechaIngreso: fechaIngreso,
        age: age,
      );
      await dbHelper.updatePerson(updatedPerson);
    }
  }
}
