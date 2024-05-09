

import 'package:flutter/material.dart';

class MyCredentialWidget extends StatefulWidget {
  @override
  _MyCredentialWidgetState createState() => _MyCredentialWidgetState();
}

class _MyCredentialWidgetState extends State<MyCredentialWidget> {
  bool editMode = false;
  bool showAddSubcategoryButton = false;
  List<String> categories = [];
  Map<String, List<String>> subcategories = {};

  TextEditingController categoryNameController = TextEditingController();
  TextEditingController subcategoryNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addCategory(String categoryName) {
    setState(() {
      categories.add(categoryName);
    });
  }

  void addSubcategory(String categoryName, String subcategoryName, String description) {
    setState(() {
      if (!subcategories.containsKey(categoryName)) {
        subcategories[categoryName] = [];
      }
      subcategories[categoryName]?.add('$subcategoryName: $description');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Credenciales'),
      ),
      body: ListView(
        children: [
          for (var category in categories)
            ExpansionTile(
              title: Text('Categoría: $category'),
              trailing: editMode
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          categories.remove(category);
                          subcategories.remove(category);
                        });
                      },
                    )
                  : null,
              children: [
                for (var subcategory in subcategories[category] ?? [])
                  ListTile(
                    title: Text('Subcategoría: $subcategory'),
                    trailing: editMode
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                subcategories[category]?.remove(subcategory);
                              });
                            },
                          )
                        : null,
                  ),
                if (editMode)
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () async {
                        var result = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Añadir Subcategoría'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: subcategoryNameController,
                                  decoration: InputDecoration(labelText: 'Nombre de la Subcategoría'),
                                  onChanged: (value) {
                                    setState(() {
                                      showAddSubcategoryButton = value.isNotEmpty &&
                                          descriptionController.text.isNotEmpty;
                                    });
                                  },
                                ),
                                TextField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(labelText: 'Descripción'),
                                  onChanged: (value) {
                                    setState(() {
                                      showAddSubcategoryButton = value.isNotEmpty &&
                                          subcategoryNameController.text.isNotEmpty;
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: showAddSubcategoryButton
                                    ? () {
                                        addSubcategory(
                                          category,
                                          subcategoryNameController.text,
                                          descriptionController.text,
                                        );
                                        Navigator.pop(context, true);
                                      }
                                    : null,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                ),
                                child: Text('Añadir'),
                              ),
                            ],
                          ),
                        );
                        if (result == true) {
                          setState(() {
                            showAddSubcategoryButton = false;
                            subcategoryNameController.clear();
                            descriptionController.clear();
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: Text('Añadir Subcategoría'),
                    ),
                  ),
              ],
            ),
          if (editMode)
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  var result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Añadir Categoría'),
                      content: TextField(
                        controller: categoryNameController,
                        decoration: InputDecoration(labelText: 'Nombre de la Categoría'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addCategory(categoryNameController.text);
                            Navigator.pop(context);
                            categoryNameController.clear();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Text('Añadir'),
                        ),
                      ],
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: Text('Añadir Categoría'),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            editMode = !editMode;
          });
        },
        child: Icon(editMode ? Icons.check : Icons.edit),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            editMode ? 'Modo Edición Activado' : '',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}