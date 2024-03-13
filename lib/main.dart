import 'package:bd/vista.dart';
import 'package:flutter/material.dart';
import 'package:bd/home.dart';
import 'package:bd/modelo.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _insert(context),
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vista()));
              },
              child: const Text('query'),
              
              
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insert(BuildContext context) async {
    final name = TextEditingController();
    final age = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insertar nuevo usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre'),
              TextFormField(
                controller: name,
                obscureText: false ,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    errorText: null
                ),
                onChanged: (texto) {
                },
              ),
              const SizedBox(height: 20,),
              Text('Años(int)'),
              TextFormField(
                controller: age,
                obscureText: false ,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    errorText: null
                ),
                onChanged: (texto) {
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // row to insert
                /*Model modelo = Model(
                  id: 10,
                  name: name.text,
                  age: int.parse(age.text),
                );
                final id = await dbHelper.insert(modelo);*/
                Map<String, dynamic> row = {
                  DatabaseHelper.columnName: name.text,
                  DatabaseHelper.columnAge: int.parse(age.text)
                };
                final id = await dbHelper.insert(row);

                debugPrint('inserted row id: $id');
                if(!id.isNegative) {
                  SnackBar(
                    content: Text(
                      'Se agrego correctamente el usuario ${name.text} con el id: $id',
                    ),
                  );
                }
                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }
}
