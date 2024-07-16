import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/appBar.dart';
import '../../models/app_users.dart';
import '../../models/loading.dart';
import '../../models/screenSizeFit.dart';
import '../../models/shared_code.dart';
import 'package:http/http.dart' as http;
import '../personal_screen/personal_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminPageUnMentoredPatients extends StatefulWidget {
  const AdminPageUnMentoredPatients({Key? key}) : super(key: key);

  @override
  State<AdminPageUnMentoredPatients> createState() =>
      _AdminPageUnMentoredPatientsState();
}

class _AdminPageUnMentoredPatientsState
    extends State<AdminPageUnMentoredPatients> {
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
    myfuture = getUnMentoredMentees();
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
                            AppLocalizations.of(context)!.unmentored_petients,
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
                                SizedBox(
                                  height: 10,
                                ),
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
                                                    .no_unmentored_users))
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

  Future<List<AppUserView>> getUnMentoredMentees() async {
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
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/mentees/no_mentor"),
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
                "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                    user_id +
                    "/mentees"),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              user: tapped_user,
                              mentor: true,
                              mentor_id: user_id,
                              is_mentor_to_user: false,
                            )),
                  );
                },
                child: Text(AppLocalizations.of(context)!.more_info)),
            SizedBox(width: 50),
            TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddPermisions(tapped_user, context),
                  );
                },
                child: Text(AppLocalizations.of(context)!.give_mentor)),
          ],
        ),
      ],
    );
  }

  Widget AddPermisions(AppUserView user, BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.give_mentor_confirm(user.name),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
      alignment: Alignment.center,
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.no),
          onPressed: () {
            Navigator.of(context).pop(); // dismiss dialog
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.yes),
          onPressed: () {
            Navigator.of(context).pop(); // dismiss dialog
            add_permision(tapped_user.id!);
          },
        ),
      ],
    );
  }

  Future<Object> add_permision(String user_id) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.put(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                user_id +
                "/premissions"),
        body: json.encode({"isMentor": true}),
        headers: requestHeaders);
    return response;
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
                            is_mentor_to_user: false,
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
