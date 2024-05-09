import 'package:flutter/material.dart';

class MyAssociatedUsersScreen extends StatefulWidget {
  final String categoryName;

  MyAssociatedUsersScreen(this.categoryName);

  @override
  _MyAssociatedUsersScreenState createState() => _MyAssociatedUsersScreenState();
}

class _MyAssociatedUsersScreenState extends State<MyAssociatedUsersScreen> {
  List<String> users = [];

  void addUser() {
    setState(() {
      users.add('Nuevo Usuario');
    });
  }

  void removeUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios Asociados - ${widget.categoryName}'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            title: Text(users[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => removeUser(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        child: Icon(Icons.add),
      ),
    );
  }
}