import 'package:app/controllers/UserController.dart';
import 'package:app/models/MyUser.dart';
import 'package:app/services/FirebaseAuthSevice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  // Controladores de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FireBaseAuthService _auth = FireBaseAuthService();
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
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

  void _signUp(BuildContext context) async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? userFirebase = await _auth.signUpWithEmailAndPassword(email, password);
    if(userFirebase != null){
      MyUser myUser = MyUser(id: userFirebase.uid, name: name, email: email, password: password);
      await _userController.createUser(myUser);
      _showSuccessDialog(context);
    }else{
      //Logica por si no
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
                Navigator.of(context).pop(); // Cerrar la alerta
                Navigator.pushReplacementNamed(context, '/login'); // Redirigir al login
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
