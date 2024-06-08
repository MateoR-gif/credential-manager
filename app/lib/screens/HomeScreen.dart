import 'package:app/widgets/News.dart';
import 'package:app/widgets/MyCredentialWidget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        children: [
          MyCredentialWidget(),
          ArticlesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Mis Credenciales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'Novedades de Ciberseguridad',
          ),
        ],
      ),
    );
  }
}