import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyCredentialWidget extends StatefulWidget {
  @override
  _MyCredentialWidgetState createState() => _MyCredentialWidgetState();
}

class _MyCredentialWidgetState extends State<MyCredentialWidget> {
  bool editMode = false;
  bool showAddSubcategoryButton = false;
  List<String> categories = [];
  Map<String, Map<String, List<String>>> subcategories = {};
  Map<String, String> fileRepositories = {};

  TextEditingController categoryNameController = TextEditingController();
  TextEditingController subcategoryNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  Future<void> loadCredentials() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonData = prefs.getString('credentials') ?? '{}';
      Map<String, dynamic> data = json.decode(jsonData);

      List<dynamic>? categoryList = data['categories'];
      if (categoryList != null) {
        for (var categoryData in categoryList) {
          String categoryName = categoryData['name'];
          List<dynamic>? subcategoryList = categoryData['subcategories'];
          if (subcategoryList != null) {
            Map<String, List<String>> subcategoryMap = {};
            for (var subcategoryData in subcategoryList) {
              String subcategoryName = subcategoryData['name'];
              List<dynamic>? descriptionList = subcategoryData['descriptions'];
              if (descriptionList != null) {
                subcategoryMap[subcategoryName] = List<String>.from(descriptionList);
              }
            }
            subcategories[categoryName] = subcategoryMap;
          }
          fileRepositories[categoryName] = categoryData['fileRepository'];
        }
        setState(() {
          categories = subcategories.keys.toList();
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
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

  Future<void> saveCredentialsToJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'categories': categories.map((categoryName) {
        return {
          'name': categoryName,
          'subcategories': subcategories[categoryName]?.entries.map((entry) {
            return {
              'name': entry.key,
              'descriptions': entry.value,
            };
          }).toList(),
          'fileRepository': fileRepositories[categoryName],
        };
      }).toList(),
    };

    String jsonData = json.encode(data);
    await prefs.setString('credentials', jsonData);
  }

  void addCategory(String categoryName) {
    setState(() {
      categories.add(categoryName);
      fileRepositories[categoryName] =
          ''; // Agregar una entrada vacía para el repositorio de archivos
      subcategories[categoryName] =
          {}; // Agregar una entrada vacía para las subcategorías
    });

    saveCredentialsToJson();
  }

  void addSubcategory(
      String categoryName, String subcategoryName, String description) {
    setState(() {
      if (!subcategories.containsKey(categoryName)) {
        subcategories[categoryName] = {};
      }
      if (!subcategories[categoryName]!.containsKey(subcategoryName)) {
        subcategories[categoryName]![subcategoryName] = [];
      }
      subcategories[categoryName]![subcategoryName]?.add(description);
    });

    saveCredentialsToJson();
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionTile(
                  title: Text(category),
                  trailing: editMode
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              categories.remove(category);
                              subcategories.remove(category);
                              fileRepositories.remove(category);
                            });
                            saveCredentialsToJson();
                          },
                        )
                      : null,
                  children: [
                    for (var subcategory
                        in subcategories[category]?.keys.toList() ?? [])
                      ExpansionTile(
                        title: Text(subcategory),
                        trailing: editMode
                            ? IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    subcategories[category]
                                        ?.remove(subcategory);
                                  });
                                  saveCredentialsToJson();
                                },
                              )
                            : null,
                        children: [
                          for (var description
                              in subcategories[category]![subcategory] ?? [])
                            ListTile(
                              title: Text(description),
                              trailing: editMode
                                  ? IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          subcategories[category]![subcategory]
                                              ?.remove(description);
                                        });
                                        saveCredentialsToJson();
                                      },
                                    )
                                  : null,
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
                                      decoration: InputDecoration(
                                          labelText:
                                              'Nombre de la Subcategoría'),
                                      onChanged: (value) {
                                        setState(() {
                                          showAddSubcategoryButton =
                                              value.trim().isNotEmpty &&
                                                  descriptionController.text
                                                      .trim()
                                                      .isNotEmpty;
                                        });
                                      },
                                    ),
                                    TextField(
                                      controller: descriptionController,
                                      decoration: InputDecoration(
                                          labelText: 'Descripción'),
                                      onChanged: (value) {
                                        setState(() {
                                          showAddSubcategoryButton =
                                              value.trim().isNotEmpty &&
                                                  subcategoryNameController.text
                                                      .trim()
                                                      .isNotEmpty;
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
                                            String subcategoryName =
                                                subcategoryNameController.text
                                                    .trim();
                                            String description =
                                                descriptionController.text
                                                    .trim();
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
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Error'),
                                                  content: Text(
                                                      'Los campos no pueden estar vacíos.'),
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
                if (!editMode)
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyAssociatedUsersScreen(category),
                            ),
                          );
                        },
                        child: Text('Ver Usuarios Asociados'),
                      ),
                      if (fileRepositories.containsKey(category))
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FileRepositoryScreen(category),
                              ),
                            );
                          },
                          child: Icon(Icons.description),
                        ),
                    ],
                  ),
                Divider(),
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
                        decoration: InputDecoration(
                            labelText: 'Nombre de la Categoría'),
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
                            String categoryName =
                                categoryNameController.text.trim();
                            if (categoryName.isNotEmpty) {
                              addCategory(categoryNameController.text);
                              Navigator.pop(context);
                              categoryNameController.clear();
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'El nombre de la categoría no puede estar vacío.'),
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
            editMode ? 'Modo Edición Activado.' : '',
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
    );
  }
}

class MyAssociatedUsersScreen extends StatelessWidget {
  final String category;

  MyAssociatedUsersScreen(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios Asociados a $category'),
      ),
      body: Center(
        child: Text('Lista de usuarios asociados a $category'),
      ),
    );
  }
}

class FileRepositoryScreen extends StatelessWidget {
  final String category;

  FileRepositoryScreen(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositorio de Archivos de $category'),
      ),
      body: Center(
        child: Text('Contenido del repositorio de archivos de $category'),
      ),
    );
  }
}
