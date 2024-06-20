// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import '../models/person.dart';
import '../utils/database_helper.dart';
import 'person_form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD'),
      ),
      body: FutureBuilder<List<Person>>(
        future: dbHelper.getPersons(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No hay estudiantes...'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Person person = snapshot.data![index];
              return ListTile(
                title: Text(person.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Carrera: ${person.carrera}'),
                    Text('Fecha Ingreso: ${person.fechaIngreso.toString()}'),
                    Text('Edad: ${person.age}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _navigateToForm(context, person);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deletePerson(person.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToForm(context, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deletePerson(int id) {
    dbHelper.deletePerson(id).then((_) {
      setState(() {
        // Refresh the list after deletion
      });
    });
  }

  void _navigateToForm(BuildContext context, Person? person) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonForm(person)),
    );
    if (result != null && result) {
      setState(() {
        // Refresh the list after adding/updating
      });
    }
  }
}
