import 'package:flutter/material.dart';

class MyCredentialWidget extends StatefulWidget {
  @override
  _MyCredentialWidgetState createState() => _MyCredentialWidgetState();
}

class _MyCredentialWidgetState extends State<MyCredentialWidget> {
  bool editMode = false;
  bool showAddSubcategoryButton = false;
  List<String> categories = [];
  Map<String, Map<String, List<String>>> subcategories = {};

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
        subcategories[categoryName] = {};
      }
      if (!subcategories[categoryName]!.containsKey(subcategoryName)) {
        subcategories[categoryName]![subcategoryName] = [];
      }
      subcategories[categoryName]![subcategoryName]?.add(description);
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
                for (var subcategory in subcategories[category]?.keys.toList() ?? [])
                  ExpansionTile(
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
                    children: [
                      for (var description in subcategories[category]![subcategory] ?? [])
                        ListTile(
                          title: Text('Descripción: $description'),
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
                            title: Text('Añadir Subcategoría'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: subcategoryNameController,
                                  decoration: InputDecoration(labelText: 'Nombre de la Subcategoría'),
                                  onChanged: (value) {
                                    setState(() {
                                      showAddSubcategoryButton = value.trim().isNotEmpty &&
                                          descriptionController.text.trim().isNotEmpty;
                                    });
                                  },
                                ),
                                TextField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(labelText: 'Descripción'),
                                  onChanged: (value) {
                                    setState(() {
                                      showAddSubcategoryButton = value.trim().isNotEmpty &&
                                          subcategoryNameController.text.trim().isNotEmpty;
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
                                        String subcategoryName = subcategoryNameController.text.trim();
                                        String description = descriptionController.text.trim();
                                        if (subcategoryName.isNotEmpty &&
                                            description.isNotEmpty) {
                                          addSubcategory(
                                            category,
                                            subcategoryNameController.text,
                                            descriptionController.text,
                                          );
                                          Navigator.pop(context, true);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Error'),
                                              content: Text('Los campos no pueden estar vacíos.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Aceptar'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    : null,
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
                            String categoryName = categoryNameController.text.trim();
                            if (categoryName.isNotEmpty) {
                              addCategory(categoryNameController.text);
                              Navigator.pop(context);
                              categoryNameController.clear();
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('El nombre de la categoría no puede estar vacío.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Aceptar'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text('Añadir'),
                        ),
                      ],
                    ),
                  );
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
          });
        },
        child: Icon(editMode ? Icons.check : Icons.edit),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            editMode ? 'Modo Edición Activado' : '',
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
    );
  }
}


