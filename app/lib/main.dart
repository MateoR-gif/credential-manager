import 'package:app/widgets/MyCredentialWidget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Credenciales',
      theme: ThemeData(
        dividerColor: Colors.transparent, // Eliminar las líneas entre ExpansionTiles
      ),
      home: MyCredentialWidget(),
    );
  }
}



