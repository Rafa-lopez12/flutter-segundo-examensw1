import 'package:flutter/material.dart';
import 'package:fluttersw1/models/user.dart';
import 'package:fluttersw1/widgets/user_list_item.dart';


class UserListScreen extends StatelessWidget {
  final List<User> users = [
    User(name: 'Juan Pérez', email: 'juan.perez@example.com'),
    User(name: 'Ana Gómez', email: 'ana.gomez@example.com'),
    User(name: 'Luis Martínez', email: 'luis.martinez@example.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listar Usuarios'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserListItem(user: users[index]);
        },
      ),
    );
  }
}