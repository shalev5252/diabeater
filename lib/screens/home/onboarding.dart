import 'dart:async';

import 'package:diabeater/localization/Localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/screenSizeFit.dart';
import '../../models/shared_code.dart';
import '../../models/user_model.dart';
import '../../services/auth.dart';
import '../admin/bottomnavbar.dart';
import '../authenticate/authenticate.dart';

class DiabeaterOnboarding extends StatefulWidget {
  const DiabeaterOnboarding({Key? key}) : super(key: key);

  @override
  State<DiabeaterOnboarding> createState() => _DiabeaterOnboardingState();
}

class _DiabeaterOnboardingState extends State<DiabeaterOnboarding> {
  late StreamSubscription<User?> user;

  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is not signed in!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diabeater',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        supportedLocales: Internationalization.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: FirebaseAuth.instance.currentUser == null
            ? DiabeaterOnboardingStateful()
            : BottomNavBar(),
      ),
    );
  }
}

class DiabeaterOnboardingStateful extends StatefulWidget {
  const DiabeaterOnboardingStateful({Key? key}) : super(key: key);

  @override
  State<DiabeaterOnboardingStateful> createState() =>
      _DiabeaterOnboardingStatefulState();
}

class _DiabeaterOnboardingStatefulState
    extends State<DiabeaterOnboardingStateful> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: Column(children: <Widget>[
          // LanguagePickerWidget(),
          SizedBox(height: SizeConfig.blockSizeVertical * 10),
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Image.asset(
              'assets/blue_logo.png',
              height: SizeConfig.blockSizeVertical * 60,
              width: SizeConfig.blockSizeHorizontal * 90,
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                    width: SizeConfig.blockSizeHorizontal * 25,
                    height: SizeConfig.blockSizeVertical * 10,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 500,
                      child: FittedBox(
                        child: FloatingActionButton.extended(
                          heroTag: "btn1",
                          key: Key("btn_login"),
                          backgroundColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Authenticate(isSignIn: true)),
                            );
                          },
                          label: Text(
                            AppLocalizations.of(context)!.login,
                            style: TextStyle(
                                color: chosenBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                  width: SizeConfig.blockSizeHorizontal * 25,
                  height: SizeConfig.blockSizeVertical * 10,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 500,
                    child: FittedBox(
                      child: FloatingActionButton.extended(
                        heroTag: "btn2",
                        key: Key("btn_signup"),
                        backgroundColor: chosenBlue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Authenticate(isSignIn: false)),
                          );
                        },
                        label: Text(
                          AppLocalizations.of(context)!.signup,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
      backgroundColor: Colors.white,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
