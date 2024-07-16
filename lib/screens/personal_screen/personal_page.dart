import 'dart:convert';
import 'package:diabeater/models/app_users.dart';
import 'package:diabeater/models/shared_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_goal.dart';
import '../../widgets/appBar.dart';
import '../../models/screenSizeFit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../tasks/tasks.dart';

class ProfilePage extends StatefulWidget {
  final AppUserView user;
  final bool mentor;
  final String mentor_id;
  final bool is_mentor_to_user;

  const ProfilePage(
      {Key? key,
      required this.user,
      required this.mentor,
      required this.mentor_id,
      required this.is_mentor_to_user})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String authToken = "";
  Map<String, userGoal> newuserGoalList = new Map();
  late Future<Map<String, userGoal>> myfuture;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myfuture = getGoals(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: myfuture,
            builder: (context, AsyncSnapshot<Map<String, userGoal>> snapshot) {
              return Scaffold(
                appBar: aplicationAppBar(),
                body: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: _TopPortion(
                            profile_url: widget.user.profilePicUrl)),
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "${widget.user.name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              // const _ProfileInfoRow(),
                              // const SizedBox(height: 10),
                              ExpansionTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .user_contact_info,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      widget.user.name,
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
                                  SizedBox(
                                      height: SizeConfig.blockSizeVertical * 5),
                                  Container(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .email(widget.user.mail),
                                        textAlign: TextAlign.center),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left:
                                            SizeConfig.blockSizeHorizontal * 3,
                                        right:
                                            SizeConfig.blockSizeHorizontal * 3),
                                  ),
                                  SizedBox(
                                      height: SizeConfig.blockSizeVertical * 5),
                                  Container(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .phone(widget.user.phone_number),
                                        textAlign: TextAlign.center),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left:
                                            SizeConfig.blockSizeHorizontal * 3,
                                        right:
                                            SizeConfig.blockSizeHorizontal * 3),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                              widget.mentor
                                  ? ExpansionTile(
                                      title: Text(
                                        AppLocalizations.of(context)!
                                            .user_goals,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      children: <Widget>[
                                        for (MapEntry<String, userGoal> todoo
                                            in newuserGoalList.entries)
                                          ToDoItem(
                                              todo: todoo.value,
                                              goalId: todoo.key,
                                              onToDoChanged: () {},
                                              onDeleteItem: (String gid) =>
                                                  deleteGoal(gid)),
                                        Center(
                                            child:
                                                FloatingActionButton.extended(
                                                    onPressed: () {
                                                      reg_task();
                                                    },
                                                    label: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .add_goal))),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(height: 16),

                              FloatingActionButton.extended(
                                onPressed: () {
                                  String mentee_phone_number =
                                      "+972${widget.user.phone_number.substring(1)}";
                                  //Uri mentee_phone = Uri.parse("tel:${mentee_phone_number}");
                                  Uri whatsapp = Uri.parse(
                                      "https://wa.me/${mentee_phone_number}");
                                  launchUrl(whatsapp);
                                },
                                heroTag: 'message',
                                elevation: 0,
                                backgroundColor: Colors.greenAccent,
                                label: Text(
                                    AppLocalizations.of(context)!.whatsapp),
                                icon: const Icon(Icons.message_rounded),
                              ),
                              SizedBox(height: 80),
                              widget.mentor && widget.is_mentor_to_user
                                  ? FloatingActionButton.extended(
                                      heroTag: 'remove',
                                      elevation: 0,
                                      backgroundColor: Colors.redAccent,
                                      label: Text(AppLocalizations.of(context)!
                                          .remove_mentee),
                                      onPressed: () => {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AboutWidget(
                                                  widget.user, context),
                                            ),
                                          })
                                  : Container(),
                              SizedBox(height: 10)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  Future<http.Response> addGoal(
      String goal_name, String goal_desc, String userId) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': authToken
    };
    DateTime now = new DateTime.now();
    userGoal tempToSend = userGoal(
      Goal_description: goal_desc,
      Goal_name: goal_name,
      Goal_progress: 7,
      Goal_target: 7,
      Goal_last_date: "",
    );
    final response = await http.post(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                userId +
                "/goals"),
        body: json.encode({"data": tempToSend.toJson()}),
        headers: requestHeaders);
    Map<String, String> requestHeaders2 = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response2 = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                userId +
                "/goals"),
        headers: requestHeaders2);
    setState(() {
      newuserGoalList = createNewGoalList(json.decode(response2.body));
    });
    // _nameController.clear();
    // _descController.clear();
    return response;
  }

  void reg_task() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.add_goal),
              content: Column(children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: 'Name your goal', border: InputBorder.none),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                        hintText: 'describe your goal',
                        border: InputBorder.none),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.add_goal,
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      addGoal(_nameController.text, _descController.text,
                          widget.user.id!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: chosenBlue,
                    ),
                  ),
                ),
              ]),
            ));
  }

  Future<Map<String, userGoal>> getGoals(AppUserView user) async {
    String tempToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    setState(() {
      authToken = tempToken;
    });
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                user.id! +
                "/goals"),
        headers: requestHeaders);

    setState(() {
      // userGoalList = createGoalList(json.decode(response.body));
      newuserGoalList = createNewGoalList(json.decode(response.body));
    });
    return createNewGoalList(json.decode(response.body));
  }

  Future<http.Response> removeGoal(String gid) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.delete(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                widget.user.id! +
                "/goals/" +
                gid),
        headers: requestHeaders);

    Map<String, String> requestHeaders2 = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response2 = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                widget.user.id! +
                "/goals"),
        headers: requestHeaders2);
    setState(() {
      newuserGoalList = createNewGoalList(json.decode(response2.body));
    });
    return response;
  }

  void deleteGoal(String gid) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.delete_goal_confirm,
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
                    removeGoal(gid);
                  },
                )
              ],
            ));
  }

  Widget AboutWidget(AppUserView user, BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.remove_mentee_confirm(user.name),
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
            remove_mentee(user.id!);
          },
        ),
      ],
    );
  }

  remove_mentee(String mentee_id) async {
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
    final response = await http.delete(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/${widget.mentor_id}/mentees/${mentee_id}"),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      AlertDialog alert = AlertDialog(
        title: Text(AppLocalizations.of(context)!.success),
        content: Text(response.body),
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
              remove_mentee(mentee_id); // dismiss dialog
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
  }
}

class _TopPortion extends StatefulWidget {
  final String profile_url;

  const _TopPortion({Key? key, required this.profile_url}) : super(key: key);

  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.white, chosenBlue]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.profile_url)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
