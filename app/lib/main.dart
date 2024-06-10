import 'package:app/providers/articles_provider.dart';
import 'package:app/screens/HomeScreen.dart';
import 'package:app/screens/LoginScreen.dart';
import 'package:app/screens/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ArticlesProvider()..fetchArticles(),
      child: MaterialApp(
        title: 'Your App Name',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomeScreen(),
        },
      ),
    ),
  );
}