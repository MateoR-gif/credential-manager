import 'package:app/controllers/UserController.dart';
import 'package:app/models/MyUser.dart';
import 'package:app/services/FirebaseAuthSevice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FireBaseAuthService _auth = FireBaseAuthService();
  final UserController _userController = UserController();

  bool _isRegistering = false; // Flag to track registration status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: _isRegistering
          ? _buildProgressIndicator()
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Correo electrónico'),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      _signUp(context);
                    },
                    child: Text('Registrarse'),
                  ),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('¿Ya tienes una cuenta? Inicia sesión aquí'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _signUp(BuildContext context) async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validar que los campos no estén vacíos y cumplan con los requisitos mínimos
    if (name.isEmpty || name.length < 3 || !isValidEmail(email) || password.length < 6) {
      _showErrorDialog(context, 'Por favor, verifica los campos y asegúrate de que cumplen con los requisitos mínimos.');
      return;
    }

    setState(() {
      _isRegistering = true; // Set flag to true when registration starts
    });

    User? userFirebase = await _auth.signUpWithEmailAndPassword(email, password);
    if (userFirebase != null) {
      MyUser myUser = MyUser(id: userFirebase.uid, name: name, email: email, password: password);
      await _userController.createUser(myUser);
      _showSuccessDialog(context);
    } else {
      // Handle registration failure
      // You might want to set _isRegistering back to false here
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registro Exitoso'),
          content: Text('¡Tu cuenta ha sido registrada exitosamente!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de Registro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  bool isValidEmail(String email) {
    // Expresión regular para validar un correo electrónico
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }
}
