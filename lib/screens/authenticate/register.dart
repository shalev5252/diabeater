import 'package:diabeater/models/screenSizeFit.dart';
import 'package:diabeater/models/user_model.dart';
import 'package:diabeater/models/shared_code.dart';
import 'package:diabeater/screens/auth_wrapper.dart';
import 'package:flutter/material.dart';
import '../../models/loading.dart';
import '../../services/auth.dart';
import 'package:intl/intl.dart';
import 'authenticate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isLoggedIn = false;

  bool is_mentor = false;
  String email = '';
  String password = '';
  String validate_password = '';
  String name = '';
  String phone = '';
  DateTime? birthday;

  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double container_height = SizeConfig.blockSizeVertical * 8;
    double container_width = SizeConfig.blockSizeHorizontal * 90;
    double size_box_height = SizeConfig.blockSizeVertical * 2;

    return loading
        ? Loading()
        : isLoggedIn
            ? const AuthenticationWrapper()
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: chosenBlue,
                  centerTitle: true,
                  title: Text(
                    AppLocalizations.of(context)!.register_with_email,
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
                        // LanguageWidget(),

                        SizedBox(height: size_box_height),
                        SizedBox(
                          height: container_height,
                          width: container_width,
                          child: TextFormField(
                            decoration:
                                buildInputDecoration(container_width, 'name'),
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                          ),
                        ),
                        SizedBox(height: size_box_height),

                        SizedBox(
                          height: container_height,
                          width: container_width,
                          child: TextFormField(
                              decoration: buildInputDecoration(
                                  container_width, 'email'),
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              }),
                        ),
                        SizedBox(height: size_box_height),
                        SizedBox(
                          height: container_height,
                          width: container_width,
                          child: TextFormField(
                            decoration: buildInputDecoration(
                                container_width, 'Phone number'),
                            validator: (val) => val!.length != 10
                                ? 'phone number has to be 10 numbers'
                                : null,
                            obscureText: false,
                            onChanged: (val) {
                              setState(() => phone = val);
                            },
                          ),
                        ),
                        SizedBox(height: size_box_height),
                        SizedBox(
                          height: container_height,
                          width: container_width,
                          child: TextField(
                            controller:
                                dateinput, //editing controller of this TextField
                            decoration: buildInputDecoration(
                                container_width, 'Date of birth'),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
//pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);

                                setState(() {
                                  birthday = pickedDate;
                                  dateinput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ),
                        ),
                        SizedBox(height: size_box_height),
                        SizedBox(
                          height: container_height,
                          width: container_width,
                          child: TextFormField(
                            decoration: buildInputDecoration(
                                container_width, 'Password'),
                            validator: (val) => val!.length < 6
                                ? 'Enter a password 6+ chars long'
                                : null,
                            obscureText: true,
                            textAlign: TextAlign.right,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                        ),
                        SizedBox(height: size_box_height),
                        SizedBox(
                          height: container_height,
                          width: container_width,
                          child: TextFormField(
                            decoration: buildInputDecoration(
                                container_width, 'Verify Password'),
                            validator: (val) => val != password
                                ? 'Passwords has to be the same'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => validate_password = val);
                            },
                          ),
                        ),

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
                                  heroTag: "btn2",
                                  backgroundColor: chosenBlue,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => loading = true);
                                      UserModel result = await _auth
                                          .RegisterWithEmailAndPassword(email,
                                              password, name, phone, birthday!);
                                      if (result.error == true) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text(result.userId!),
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
                                        setState(() {
                                          loading = false;
                                        });
                                      } else {
                                        setState(() {
                                          loading = false;
                                          isLoggedIn = true;
                                        });
                                      }
                                    }
                                  },
                                  label: Text(
                                    AppLocalizations.of(context)!.signup,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          // middle
                          padding:
                              const EdgeInsets.fromLTRB(35.0, 1.0, 35.0, 1.0),
                          child: Row(children: [
                            Center(
                                child: Text(
                                    AppLocalizations.of(context)!.already_have,
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
                                      heroTag: "btn1",
                                      backgroundColor: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
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
                                          fontWeight: FontWeight.bold,
                                          color: chosenBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

  InputDecoration buildInputDecoration(double container_width, String field) {
    return InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: chosenBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: chosenBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: chosenBlue),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: chosenBlue),
        ),
        contentPadding: EdgeInsets.only(
            left: container_width * 0.05, right: container_width * 0.005 + 5),
        filled: false,
        border: InputBorder.none,
        fillColor: Colors.white,
        labelText: field);
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: chosenBlue,
      title: Image.asset(
        'assets/white_empty_logo.png',
        height: 50,
        width: 50,
      ),
      actions: <Widget>[
        // LanguagePickerWidget(),
        TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(
              AppLocalizations.of(context)!.connect,
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
