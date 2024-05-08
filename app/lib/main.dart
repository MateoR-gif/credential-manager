import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Credenciales',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool editMode = false;
  bool showAddSubcategoryButton = false;
  bool showAddCategoryButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Credenciales'),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('Categoría: Credenciales Personales'),
            trailing: editMode
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Acción para borrar categoría
                    },
                  )
                : null,
            children: [
              ExpansionTile(
                title: Text('Subcategoría: Descripción'),
                trailing: editMode
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Acción para borrar subcategoría
                        },
                      )
                    : null,
                children: [
                  ListTile(
                    title: Text('Texto Ejemplo'),
                    onTap: () {
                      if (editMode) {
                        // Acción al hacer clic en modo edición
                      }
                    },
                  ),
                ],
              ),
              if (showAddSubcategoryButton)
                ListTile(
                  title: ElevatedButton(
                    onPressed: () {
                      // Acción para agregar subcategoría
                    },
                    child: Text('Añadir Subcategoría'),
                  ),
                ),
            ],
          ),
          if (showAddCategoryButton)
            ListTile(
              title: ElevatedButton(
                onPressed: () {
                  // Acción para agregar categoría
                },
                child: Text('Añadir Categoría'),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            editMode = !editMode;
            showAddSubcategoryButton = editMode;
            showAddCategoryButton = editMode;
          });
        },
        child: Icon(editMode ? Icons.check : Icons.edit),
      ),
    );
  }
}

