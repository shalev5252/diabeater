import 'package:flutter/material.dart';

import '../models/shared_code.dart';

AppBar aplicationAppBar() {
  return AppBar(
    automaticallyImplyLeading: true,
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: chosenBlue,
    actions: <Widget>[
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            'white_empty_logo.png',
            height: 30,
            width: 30,
          ))
    ],
  );
}
