import 'package:diabeater/models/app_users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final brews = Provider.of<List<AppUser>>(context);
    print(brews.length);
    brews.forEach((brew) {
      print(brew.name);
      print(brew.mail);
    });
    // print(brews.toString()); // here returns [] too.
    return Container();
  }
}
