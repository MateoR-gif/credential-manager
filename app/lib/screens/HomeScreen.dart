import 'package:app/services/FirebaseAuthSevice.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/News.dart';
import 'package:app/widgets/MyCredentialWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final FireBaseAuthService _auth = FireBaseAuthService();
  int _selectedPageIndex = 0;

  // Método para cerrar sesión
  void _logout() {
    _auth.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Título de la App'),
        automaticallyImplyLeading: false, // Evitar que aparezca la flecha de regreso
        actions: [
          // Botón para cerrar sesión
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
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
        items: const [
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
