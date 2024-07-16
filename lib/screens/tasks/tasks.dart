import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/shared_code.dart';
import '../../models/user_goal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  int streak_count = 5;
  String authToken = "";
  final _todoController = TextEditingController();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  Map<String, userGoal> newuserGoalList = new Map();
  List<userGoal> userGoalList = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;
  late Future<Map<String, userGoal>> myfuture;

  @override
  void initState() {
    super.initState();
    myfuture = getGoals();
  }

  Future<Map<String, userGoal>> getGoals() async {
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
                userId +
                "/goals"),
        headers: requestHeaders);
    setState(() {
      // userGoalList = createGoalList(json.decode(response.body));
      newuserGoalList = createNewGoalList(json.decode(response.body));
    });

    return createNewGoalList(json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: myfuture,
          builder: (context, AsyncSnapshot<Map<String, userGoal>> snapshot) {
            return Scaffold(
                body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 0, bottom: 20),
                                child: Column(
                                  children: [
                                    SizedBox(height: 2),
                                    Text(
                                      AppLocalizations.of(context)!.welcome,
                                      style: TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 30),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .todays_goals,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                            for (MapEntry<String, userGoal> todoo
                                in newuserGoalList.entries)
                              ToDoItem(
                                todo: todoo.value,
                                goalId: todoo.key,
                                onToDoChanged:
                                    (userGoal goal, String gid, bool done) {
                                  doneGoal(goal, gid, done);
                                },
                                onDeleteItem: (String gid) {
                                  deleteGoal(gid);
                                },
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 20,
                      ), //Container(
                      //   margin: EdgeInsets.only(
                      //     bottom: 20,
                      //     right: 20,
                      //     left: 20,
                      //   ),
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 20,
                      //     vertical: 5,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     boxShadow: const [
                      //       BoxShadow(
                      //         color: Colors.grey,
                      //         offset: Offset(0.0, 0.0),
                      //         blurRadius: 10.0,
                      //         spreadRadius: 0.0,
                      //       ),
                      //     ],
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: SizedBox(height: 20, ),//TextField(
                      //   //   readOnly: true,
                      //   //   controller: _todoController,
                      //   //   decoration: InputDecoration(
                      //   //       hintText: 'Add a new todo item',
                      //   //       border: InputBorder.none),
                      //   // ),
                      // ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                      ),
                      child: ElevatedButton(
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                        onPressed: () {
                          reg_task();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: chosenBlue,
                          shape: CircleBorder(),
                          minimumSize: Size(60, 60),
                          elevation: 10,
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ));
          } // bottomNavigationBar: DiabeaterNavigationBar(),
          ),
    );
  }

  void reg_task() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.add_goal),
            insetPadding: EdgeInsets.all(30),
            content: SizedBox(
              height: 225,
              child: Column(children: [
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
                    child: SizedBox(
                      width: 0.55 * MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintText: 'Name your goal',
                            border: InputBorder.none),
                      ),
                    )),
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
                  child: SizedBox(
                    width: 0.55 * MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: _descController,
                      decoration: InputDecoration(
                          hintText: 'describe your goal',
                          border: InputBorder.none),
                    ),
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
                      addGoal(_nameController.text, _descController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: chosenBlue,
                    ),
                  ),
                ),
              ]),
            )));
  }

  Future<Object> addGoal(String goal_name, String goal_desc) async {
    if (goal_name.isNotEmpty) {
      Map<String, String> requestHeaders = {
        'accept': 'application/json',
        'Content-type': 'application/json',
        'Authorization': authToken
      };
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
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
                  FirebaseAuth.instance.currentUser!.uid +
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
        // userGoalList = createGoalList(json.decode(response.body));
        newuserGoalList = createNewGoalList(json.decode(response2.body));
      });
      _nameController.clear();
      _descController.clear();
      return response;
    }
    return Null;
  }

  Future<Object> doneGoal(userGoal goal, String gid, bool done) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': authToken
    };
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    userGoal tempToSend = userGoal(
      Goal_description: goal.Goal_description,
      Goal_name: goal.Goal_name,
      Goal_progress: goal.Goal_progress,
      Goal_target: goal.Goal_target,
      Goal_last_date: (done) ? "" : date.toString(),
    );
    final response = await http.put(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                FirebaseAuth.instance.currentUser!.uid +
                "/goals/" +
                gid),
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
      // userGoalList = createGoalList(json.decode(response.body));
      newuserGoalList = createNewGoalList(json.decode(response2.body));
    });
    _nameController.clear();
    _descController.clear();
    return response;
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
                FirebaseAuth.instance.currentUser!.uid +
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
                userId +
                "/goals"),
        headers: requestHeaders2);

    setState(() {
      // userGoalList = createGoalList(json.decode(response.body));
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
}

// class TaskItem extends Stat

// import '../model/todo.dart';
// class ToDo {
//   String? id;
//   String? todoText;
//   bool isDone;
//
//   ToDo({
//     required this.id,
//     required this.todoText,
//     this.isDone = false,
//   });
//
//   static List<ToDo> todoList() {
//     return [
//       ToDo(id: '01', todoText: 'Morning Excercise', isDone: true ),
//       ToDo(id: '02', todoText: 'Buy Groceries', isDone: true ),
//       ToDo(id: '03', todoText: 'Check Emails', ),
//       ToDo(id: '04', todoText: 'Team Meeting', ),
//       ToDo(id: '05', todoText: 'Work on mobile apps for 2 hour', ),
//       ToDo(id: '06', todoText: 'Dinner with Jenny', ),
//     ];
//   }
// }

const Color tdRed = Color(0xFFDA4040);
const Color tdBlue = Color(0xFF5F52EE);

const Color tdBlack = Color(0xFF3A3A3A);
const Color tdGrey = Color(0xFF717171);

const Color tdBGColor = Color(0xFFEEEFF5);

class ToDoItem extends StatefulWidget {
  final userGoal todo;
  final String goalId;
  final onToDoChanged;
  final onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.goalId,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  DateTime now2 = new DateTime.now();
  bool done = false;

  @override
  void initState() {
    super.initState();
    DateTime date2 = new DateTime(now2.year, now2.month, now2.day);
    done = widget.todo.Goal_last_date == date2.toString();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now2 = new DateTime.now();
    DateTime date2 = new DateTime(now2.year, now2.month, now2.day);

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(children: [
        ListTile(
          onTap: () {
            if (done) {
              widget.onToDoChanged(widget.todo, widget.goalId, true);
              setState(() {
                done = false;
              });
            } else {
              widget.onToDoChanged(widget.todo, widget.goalId, false);
              setState(() {
                done = true;
              });
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          tileColor: Colors.white,
          leading: Icon(
            done ? Icons.check_box : Icons.check_box_outline_blank,
            color: tdBlue,
          ),
          title: Text(
            widget.todo.Goal_name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: tdBlack,
              decoration: (widget.todo.Goal_last_date == date2.toString())
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: Text(
            widget.todo.Goal_description,
            style: TextStyle(
              fontSize: 16,
              color: tdBlack,
            ),
          ),

          // TODO: option for progress bar
          // subtitle: Container(
          //     width: 330,
          //     child: ClipRRect(
          //         borderRadius: BorderRadius.all(
          //             Radius.circular(10)),
          //         child: LinearProgressIndicator(
          //           value: 5 / widget.todo.Goal_target,
          //           backgroundColor: Colors.grey[300],
          //           color: chosenBlue,
          //           valueColor:
          //           AlwaysStoppedAnimation<Color>(
          //               Colors.blue),
          //           minHeight: 10,
          //         ))),

          trailing: Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.symmetric(vertical: 1),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: tdRed,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              color: Colors.white,
              iconSize: 18,
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.onDeleteItem(widget.goalId);
              },
            ),
          ),
        ),
      ]),
    );
  }
}

class Food extends StatefulWidget {
  const Food({
    super.key,
    required this.imageLink,
    required this.pressed,
    required this.onPressed,
  });

  final Function onPressed;
  final String imageLink;
  final int pressed;

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  late int pressed;

  @override
  void initState() {
    super.initState();
    pressed = widget.pressed;
  }

  @override
  Widget build(BuildContext context) {
    if (pressed == 0) {
      return (TextButton(
          onPressed: (() => {
                setState(() {
                  pressed = 1 - pressed;
                }),
                widget.onPressed()
              }),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            //color: Colors.blue,
            child: Image.asset(
              widget.imageLink,
              height: 130,
              width: 130,
              fit: BoxFit.fill,
              opacity: const AlwaysStoppedAnimation(50),
            ),
          )));
    } else {
      return (Stack(children: [
        Opacity(
            opacity: 0.45,
            child: TextButton(
                onPressed: (() => {
                      setState(() {
                        pressed = 1 - pressed;
                      }),
                      widget.onPressed()
                    }),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  //color: Colors.blue,
                  child: Image.asset(
                    widget.imageLink,
                    height: 130,
                    width: 130,
                    fit: BoxFit.fill,
                    opacity: const AlwaysStoppedAnimation(50),
                  ),
                ))),
        /* Positioned(
            left: 20,
            bottom: 10,
            child: Image.asset(
              'blue_blur.jpg',
              height: 70,
              width: 70,
              opacity: const AlwaysStoppedAnimation(50),
            ),
        )*/
      ]));
    }
  }
}

Widget goal() {
  int numPressed = 2;

  return Center(child: (Goal(numPressed: numPressed)));
}

class Goal extends StatefulWidget {
  const Goal({
    Key? key,
    required this.numPressed,
  }) : super(key: key);

  final int numPressed;

  @override
  State<Goal> createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  @override
  late int numPressed;

  void initState() {
    // TODO: implement initState
    numPressed = widget.numPressed;
    super.initState();
  }

  void onPressed() {
    setState(() {
      numPressed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double goalWidth = 500;
    return Stack(children: [
      const SizedBox(
        height: 40,
      ),
      Container(
        height: 240,
        width: goalWidth,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            //width: double.infinity,
            padding: const EdgeInsets.only(left: 0, right: 0, top: 40),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Food(
                  imageLink: 'assets/running_img.jpg',
                  pressed: 0,
                  onPressed: onPressed,
                ),
                Food(
                  imageLink: 'assets/insulin.jpg',
                  pressed: 0,
                  onPressed: onPressed,
                ),
                Food(
                  imageLink: 'assets/lifting_weights.jpg',
                  pressed: 0,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Positioned(
          top: 220,
          child: Container(
              width: goalWidth,
              child: LinearProgressIndicator(
                value: numPressed.toDouble() / 3,
                minHeight: 12,
              ))),
      const SizedBox(
        height: 30,
      ),
      Positioned(
        left: 13,
        top: 7,
        child: Text(
          AppLocalizations.of(context)!.todays_goals2,
          style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.w100),
        ),
      ),
    ]);
  }
}

////////////////////////
class WeeklyGoal extends StatefulWidget {
  const WeeklyGoal({
    Key? key,
    required this.finishDate,
  }) : super(key: key);

  final DateTime finishDate;

  @override
  State<WeeklyGoal> createState() => _WeeklyGoalState();
}

class _WeeklyGoalState extends State<WeeklyGoal> {
  @override
  late int daysLeft;
  late int amount;
  late Timer timer;

  void initState() {
    // TODO: implement initState
    daysLeft = widget.finishDate.day - DateTime.now().day;
    amount = 0;
    super.initState();
  }

  void updateTime() {
    setState(() {
      daysLeft = widget.finishDate.day - DateTime.now().day;
    });
  }

  void updateAmount() {
    setState(() {
      if (amount < 10) {
        amount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double goalSize = MediaQuery.of(context).size.height * 0.15;
    return TextButton(
        onPressed: updateAmount,
        child: Container(
          height: goalSize,
          child: Column(children: [
            const SizedBox(
              height: 4,
            ),
            const Text(
              "Working out at the gym",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
                width: 350,
                child: LinearProgressIndicator(
                  value: amount.toDouble() / 10,
                  minHeight: 20,
                )),
            const SizedBox(
              height: 10,
            ),
            Text('$amount / 10'),
            Text('$daysLeft days left'),
          ]),
        ));
  }
}
