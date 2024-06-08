import 'package:app/providers/articles_provider.dart';
import 'package:app/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ArticlesProvider()..fetchArticles(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        dividerColor:
            Colors.transparent, // Eliminar las líneas entre ExpansionTiles
      ),
      home: HomeScreen(),
    );
  }
}
