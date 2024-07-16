import 'package:diabeater/models/user_model.dart';
import 'package:diabeater/screens/auth_wrapper.dart';
import 'package:diabeater/services/auth.dart';
import 'package:flutter/material.dart';
import '../../models/loading.dart';
import '../../models/screenSizeFit.dart';
import '../../models/shared_code.dart';
import 'authenticate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool loggedIn = false;
  String error = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // double container_height = SizeConfig.blockSizeVertical * 7;
    double container_width = SizeConfig.blockSizeHorizontal * 90;
    double size_box_height = SizeConfig.blockSizeVertical * 2;
    return loading
        ? Loading()
        : loggedIn
            ? const AuthenticationWrapper()
            : Scaffold(
                resizeToAvoidBottomInset:
                    false, // fix overflow when keyboard is up
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: chosenBlue,
                  centerTitle: true,
                  title: Text(
                    AppLocalizations.of(context)!.signin_with_email,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: size_box_height,
                      horizontal: SizeConfig.blockSizeHorizontal * 2),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Image.asset(
                            'assets/blue_logo.png',
                            height: SizeConfig.blockSizeVertical * 20,
                            width: SizeConfig.blockSizeHorizontal * 20,
                          ),
                        )),
                        SizedBox(height: size_box_height),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 8,
                          width: container_width,
                          child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 3, color: chosenBlue),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 3, color: chosenBlue),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 3, color: chosenBlue),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 3, color: chosenBlue),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: container_width * 0.05,
                                      right: container_width * 0.005 + 5),
                                  filled: false,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  labelText: 'Email'),
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              }),
                        ),
                        SizedBox(height: size_box_height),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 8,
                          width: container_width,
                          child: TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: chosenBlue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: chosenBlue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: chosenBlue),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: chosenBlue),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: container_width * 0.05,
                                    right: container_width * 0.005 + 5),
                                filled: false,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                labelText: 'Password'),
                            validator: (val) => val!.length < 6
                                ? 'Enter a password 6+ chars long'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 15),
                        Expanded(
                          flex: 2,
                          child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                              width: SizeConfig.blockSizeHorizontal * 35,
                              height: SizeConfig.blockSizeVertical * 10,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 500,
                                child: FittedBox(
                                  child: FloatingActionButton.extended(
                                    heroTag: "btn1",
                                    backgroundColor: Colors.white,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => loading = true);
                                        UserModel result = await _auth
                                            .SignInWithEmailAndPassword(
                                                email, password);
                                        if (result.error) {
                                          setState(() {
                                            error = '${result.userId}';
                                            loading = false;
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text(error),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .ok))
                                                    ],
                                                  ));
                                        } else {
                                          setState(() {
                                            loggedIn = true;
                                            loading = false;
                                          });
                                        }
                                      }
                                    },
                                    label: Text(
                                      AppLocalizations.of(context)!.login,
                                      style: TextStyle(
                                          color: chosenBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                        ),

                        // sign up option
                        // SizedBox(height: SizeConfig.blockSizeVertical * 5),

                        Container(
                          // middle
                          padding:
                              const EdgeInsets.fromLTRB(35.0, 1.0, 35.0, 1.0),
                          child: Row(children: [
                            Center(
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .dont_have_account,
                                    style: TextStyle(fontSize: 16))),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                    1.0, 1.0, 1.0, 1.0),
                                width: SizeConfig.blockSizeHorizontal * 25,
                                height: SizeConfig.blockSizeVertical * 10,
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 100,
                                  child: FittedBox(
                                    child: FloatingActionButton.extended(
                                      heroTag: "btn2",
                                      backgroundColor: chosenBlue,
                                      onPressed: () {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Authenticate(
                                                      isSignIn: false)),
                                        );
                                      },
                                      label: Text(
                                        AppLocalizations.of(context)!.signup,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        // SizedBox(height: SizeConfig.blockSizeVertical * 5),
                      ],
                    ),
                  ),
                ),
              );
  }
}
