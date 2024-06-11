import 'package:app/controllers/UserController.dart';
import 'package:app/services/FirebaseAuthSevice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FireBaseAuthService _auth = FireBaseAuthService();
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                signIn(context);
              },
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('¿No tienes una cuenta? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }

  void signIn(BuildContext context) async {
    final String email = emailController.text;
    final String password = passwordController.text;

    User? firebaseUser = await _auth.signInWithEmailAndPassword(email, password);
    if (email.isNotEmpty && password.isNotEmpty && firebaseUser != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Mostrar un diálogo de error si los campos están vacíos
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Por favor, ingresa tu correo electrónico y contraseña.'),
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
}
