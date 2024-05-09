import 'package:flutter/material.dart';

class FileRepositoryScreen extends StatelessWidget {
  final String categoryName;

  FileRepositoryScreen(this.categoryName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositorio de Archivos - $categoryName'),
      ),
      body: Center(
        child: Text(
          'Contenido del Repositorio de Archivos para la categoría $categoryName\n\nNo se encuentran archivos asociados.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}