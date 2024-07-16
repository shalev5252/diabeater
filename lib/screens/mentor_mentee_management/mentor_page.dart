import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/appBar.dart';
import '../../models/app_users.dart';
import '../../models/loading.dart';
import '../../models/screenSizeFit.dart';
import '../../models/shared_code.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../personal_screen/personal_page.dart';

class MentorPage extends StatefulWidget {
  const MentorPage({Key? key}) : super(key: key);

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  final user_id = FirebaseAuth.instance.currentUser!.uid;

  // final AuthService _auth = AuthService();
  String authToken = "";
  String mentee_number = "";
  String mentee_mail = "";
  List<AppUserView> listOfMentees = [];
  int selectedTile = -1;

  AppUserView tapped_user =
      AppUserView(mail: "", name: "", phone_number: "", profilePicUrl: "");
  late Future<List<AppUserView>> myfuture;

  @override
  void initState() {
    super.initState();
    myfuture = getMentees();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: FutureBuilder(
            future: myfuture,
            builder: (context, AsyncSnapshot<List<AppUserView>> snapshot) {
              if (snapshot.hasError)
                return Text(AppLocalizations.of(context)!
                    .error(snapshot.error.toString()));
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: aplicationAppBar(),
                  body: Center(
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.your_mentees,
                            style: TextStyle(
                                fontSize: 45, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 6),
                        SingleChildScrollView(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ///add a patient (will show a popup screen to add it)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!
                                            .add_mentee,
                                        style: TextStyle(fontSize: 24)),
                                    SizedBox(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 4),
                                    FloatingActionButton(
                                      onPressed: () {
                                        add_mentee();
                                      },
                                      backgroundColor: chosenBlue,
                                      child: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                ///split the screen, at the right side there will be a list uf patients
                                ///on the left side there is something else
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //   listOfMentees.isEmpty
                                    //       ? Container()
                                    //       : Expanded(
                                    //           flex: 1,
                                    //           child: Container(
                                    //             color: chosenBlue,
                                    //             child: Padding(
                                    //               padding: EdgeInsets.all(10),
                                    //               child:
                                    //                   UserContainer(), //container
                                    //             ),
                                    //           ),
                                    //         ),
                                    //   SizedBox(
                                    //     width: 10,
                                    //   ),
                                    Expanded(
                                      child: Container(
                                        height:
                                            SizeConfig.blockSizeVertical * 50,
                                        width:
                                            SizeConfig.blockSizeHorizontal * 10,
                                        child: listOfMentees.isEmpty
                                            ? Center(
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .you_have_no_mentees))
                                            : ListView.separated(
                                                key: Key(
                                                    selectedTile.toString()),
                                                itemBuilder: (_, index) =>
                                                    patientsView(index, ""),
                                                separatorBuilder: (_, _2) =>
                                                    Divider(),
                                                itemCount: listOfMentees.length,
                                                shrinkWrap: true),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                );
              } else
                return Loading();
            }));
  }

  void add_mentee() {
    int selectedIndex = 0;
    String text_lable = "insert phone number";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Center(
                child: Column(
              children: [
                ToggleSwitch(
                  initialLabelIndex: selectedIndex,
                  totalSwitches: 2,
                  minWidth: 100.0,
                  minHeight: 30.0,
                  fontSize: 20,
                  cornerRadius: 20.0,
                  activeBgColor: [
                    chosenBlue,
                  ],
                  inactiveBgColor: Colors.white,
                  labels: ["Phone", "Mail"],
                  onToggle: (index) {
                    setState(() {
                      selectedIndex = index!;
                      selectedIndex == 0
                          ? text_lable = "insert phone number"
                          : text_lable = "insert email";
                    });
                  },
                ),
                SizedBox(height: 5),
                Text(
                  selectedIndex == 0
                      ? AppLocalizations.of(context)!.enter_phone
                      : AppLocalizations.of(context)!.enter_email,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        child: Column(children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: chosenBlue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: chosenBlue),
                            ),
                            contentPadding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 1),
                            filled: false,
                            hintText: selectedIndex == 0
                                ? "Phone number"
                                : "Email address"),
                        onChanged: (val) {
                          if (selectedIndex == 0) {
                            setState(() => mentee_number = val);
                          } else {
                            setState(() => mentee_mail = val);
                          }
                        },
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                    ]))),
                FloatingActionButton(
                  onPressed: () {
                    if (selectedIndex == 0) {
                      add_mentee_by_phone();
                    } else {
                      add_mentee_by_mail();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                )
              ],
            )),
          );
        }));
      },
    );
  }

  Future<http.Response> add_mentee_by_mail() async {
    String temporal_token =
        await FirebaseAuth.instance.currentUser!.getIdToken();
    setState(() {
      authToken = temporal_token;
    });
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.post(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                user_id +
                "/mentees"),
        body: json.encode({"email": mentee_mail}),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      AlertDialog alert = AlertDialog(
        title: Text(AppLocalizations.of(context)!.success),
        content: Text(AppLocalizations.of(context)!.mentee_added),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () {
              Navigator.of(context).pop(); // dismiss dialog
            },
          ),
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      setState(() {
        listOfMentees +=
            createUserViewList(json.decode("[" + response.body + "]"));
      });
    } else {
      AlertDialog alert = AlertDialog(
        title: Text(AppLocalizations.of(context)!.error_occurred),
        content: Text(response.body),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () {
              Navigator.of(context).pop(); // dismiss dialog
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.try_again),
            onPressed: () {
              Navigator.of(context).pop();
              add_mentee_by_phone(); // dismiss dialog
            },
          ),
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    return response;
  }

  Future<http.Response> add_mentee_by_phone() async {
    String temporal_token =
        await FirebaseAuth.instance.currentUser!.getIdToken();
    setState(() {
      authToken = temporal_token;
    });
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.post(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                user_id +
                "/mentees"),
        body: json.encode({"phone": mentee_number}),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      AlertDialog alert = AlertDialog(
        title: Text(AppLocalizations.of(context)!.success),
        content: Text(AppLocalizations.of(context)!.mentee_added),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () {
              Navigator.of(context).pop(); // dismiss dialog
            },
          ),
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      setState(() {
        listOfMentees +=
            createUserViewList(json.decode("[" + response.body + "]"));
      });
    } else {
      AlertDialog alert = AlertDialog(
        title: Text(AppLocalizations.of(context)!.error_occurred),
        content: Text(response.body),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () {
              Navigator.of(context).pop(); // dismiss dialog
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.try_again),
            onPressed: () {
              Navigator.of(context).pop();
              add_mentee_by_phone(); // dismiss dialog
            },
          ),
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    return response;
  }

  Future<List<AppUserView>> getMentees() async {
    String temporal_token =
        await FirebaseAuth.instance.currentUser!.getIdToken();
    setState(() {
      authToken = temporal_token;
    });
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                user_id +
                "/mentees"),
        headers: requestHeaders);
    setState(() {
      listOfMentees = createUserViewList(json.decode(response.body));
      if (listOfMentees.length > 0) tapped_user = listOfMentees[0];
    });
    return listOfMentees;
  }

  Widget patientsView(int index, String mentors_json) {
    return ExpansionTile(
      key: Key(index.toString()),
      initiallyExpanded: index == selectedTile,
      title: Container(
          alignment: Alignment.center,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(listOfMentees[index].name),
            SizedBox(width: SizeConfig.blockSizeHorizontal * 4),
            ClipOval(
              child: Image.network(listOfMentees[index].profilePicUrl,
                  width: 40, height: 40, fit: BoxFit.cover),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
          ])),
      // subtitle: Text('check user vitals log'),
      onExpansionChanged: (newState) async {
        if (newState)
          setState(() {
            selectedTile = index;
          });
        else
          setState(() {
            selectedTile = -1;
          });
        setState(() {
          tapped_user = listOfMentees[index];
        });
        String temporal_token =
            await FirebaseAuth.instance.currentUser!.getIdToken();
        setState(() {
          authToken = temporal_token;
        });
        Map<String, String> requestHeaders = {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': authToken
        };
        final response = await http.get(
            Uri.parse(
                "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/${user_id}/mentees"),
            headers: requestHeaders);
      },
      children: <Widget>[
        Center(
          child: Text(
            tapped_user.name,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 5),
        Container(
          child: Text(AppLocalizations.of(context)!.email(tapped_user.mail)),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 3,
              right: SizeConfig.blockSizeHorizontal * 3),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 5),
        Container(
          child: Text(
              AppLocalizations.of(context)!.phone(tapped_user.phone_number)),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 3,
              right: SizeConfig.blockSizeHorizontal * 3),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 5),
        Center(
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              user: tapped_user,
                              mentor: true,
                              mentor_id: user_id,
                              is_mentor_to_user: true,
                            )),
                  );
                },
                child: Text(AppLocalizations.of(context)!.more_info))),
      ],
    );
  }

  Widget UserContainer() {
    //to move short_description (description now), review_rating(rating now) and picture to parameters
    return Center(
        child: Container(
      height: SizeConfig.blockSizeVertical * 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0)),
          border: Border.all(color: chosenBlue),
          color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 2),
            Center(
              child: Text(
                tapped_user.name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 4),
            Padding(
              padding: EdgeInsets.only(
                  left: 2, right: SizeConfig.blockSizeHorizontal * 3),
              child: ClipOval(
                child: Image.network(tapped_user.profilePicUrl,
                    width: SizeConfig.blockSizeHorizontal * 20,
                    height: SizeConfig.blockSizeVertical * 20,
                    alignment: Alignment.center,
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            Container(
              child:
                  Text(AppLocalizations.of(context)!.email(tapped_user.mail)),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 3,
                  right: SizeConfig.blockSizeHorizontal * 3),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            Container(
              child: Text(AppLocalizations.of(context)!
                  .phone(tapped_user.phone_number)),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 3,
                  right: SizeConfig.blockSizeHorizontal * 3),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            Center(
                child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            user: tapped_user,
                            mentor: false,
                            mentor_id: user_id,
                            is_mentor_to_user: true,
                          )),
                );
              },
              child: Text(AppLocalizations.of(context)!.more_info),
            )),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            Center(
                child: TextButton(
              onPressed: () {
                String mentee_phone_number =
                    "+972${tapped_user.phone_number.substring(1)}";
                //Uri mentee_phone = Uri.parse("tel:${mentee_phone_number}");
                Uri whatsapp =
                    Uri.parse("https://wa.me/${mentee_phone_number}");
                launchUrl(whatsapp);
              },
              child: Text(AppLocalizations.of(context)!.whatsapp),
            ))
          ],
        ),
      ),
    ));
  }
}

class Alert_ADD extends StatefulWidget {
  const Alert_ADD({Key? key}) : super(key: key);

  @override
  State<Alert_ADD> createState() => _Alert_ADDState();
}

class _Alert_ADDState extends State<Alert_ADD> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
