import 'package:diabeater/models/app_users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<AppUser>>(context);
    print(users.length);
    for (var users in users) {
      print(users.name);
      print(users.mail);
    }
    // print(users.toString()); // here returns [] too.
    return Container();
  }
}
