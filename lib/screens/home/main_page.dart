import 'package:diabeater/models/app_users.dart';
import 'package:diabeater/models/screenSizeFit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final String postsURL =
    "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app";

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool mentor_switch = true;
  var firebaseUser = FirebaseAuth.instance.currentUser!;
  final current_user = FirebaseAuth.instance;
  String? name = FirebaseAuth.instance.currentUser?.email;
  AppUser? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 243, 247, 255),
      body: new SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Text(
              AppLocalizations.of(context)!.welcome,
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
