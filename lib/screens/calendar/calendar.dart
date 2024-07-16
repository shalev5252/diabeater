import 'dart:convert';
import 'package:diabeater/models/shared_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/app_users.dart';
import '../../models/screenSizeFit.dart';
import 'package:http/http.dart' as http;
import '../../models/user_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime today = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  TextEditingController hour_input = TextEditingController();

  // List<userEvent> userEventsList = [];
  // month event list
  List<List<userEvent>> monthEventsList =
      List<List<userEvent>>.generate(31, (index) => []);
  List<AppUserView> menteeList = [];
  String new_event_title = '';
  String authToken = '';
  AppUserView? currentUser = null;
  bool isCalendarVisible = true;

  Future<void> _onDaySelected(DateTime day, DateTime focusedDay) async {
    String authTokenTemp =
        await FirebaseAuth.instance.currentUser!.getIdToken();
    getEvents();
    getMentees();
    setState(() {
      today = day;
      authToken = authTokenTemp;
    });
  }

  @override
  void initState() {
    hour_input.text = "";

    //set the initial value of text field
    set_auth();
    super.initState();
  }

  Widget group_index_show(
      int index, List<bool> groupChecked, Function(int, bool) checkGroup) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(menteeList[index].profilePicUrl)),
          SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
          Text(menteeList[index].name),
          Spacer(),
          Checkbox(
            value: groupChecked[index],
            onChanged: (bool? value) {
              checkGroup(index, value!);
            },
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }

  Widget self_index_show() {
    if (currentUser == null) {
      return Container();
    }
    return Container(
        alignment: Alignment.center,
        child: Container(
          // decoration: BoxDecoration(
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 0.5,
          //       blurRadius: 0.5,
          //       offset: Offset(0, 0.5), // changes position of shadow
          //     ),
          //   ],
          // ),
          // foregroundDecoration: BoxDecoration(
          //   color: Colors.blueGrey,
          //   backgroundBlendMode: BlendMode.saturation,
          // ),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(currentUser!.profilePicUrl)),
              SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
              Text(currentUser!.name + " (Self)"),
              Spacer(),
              Checkbox(
                fillColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                value: true,
                onChanged: (bool? value) {},
                shape: CircleBorder(),
              ),
            ],
          ),
        ));
  }

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      //should be scrollable
      body: ListView(
          // allow scrolling until the end of the page
          controller: _controller,
          children: [
            // add option to slide calendar up so

            Container(
              width: SizeConfig.screenWidth * 90,
              child: TableCalendar(
                rowHeight: SizeConfig.blockSizeVertical * 6,
                headerStyle: HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2022, 12, 28),
                lastDay: DateTime.utc(2040, 12, 28),
                onDaySelected: _onDaySelected,
              ),
            ),
            // add Divider inside a button
            // TextButton(onPressed: () => {setState(()=>{isCalendarVisible = !isCalendarVisible})}, child: Divider()),
            // SizedBox(height: SizeConfig.blockSizeVertical * 1),
            Row(children: [
              Expanded(
                  child: Center(
                      child: Text(
                today.toString().split(" ")[0],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ))),
              Container(
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeVertical * 5,
                  child: FloatingActionButton(
                    onPressed: () {
                      getMentees();
                      reg_event();
                    },
                    backgroundColor: chosenBlue,
                    child: const Icon(Icons.add),
                  )),
              SizedBox(width: SizeConfig.blockSizeHorizontal * 3)
            ]),
            Center(
              child: Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  width: SizeConfig.blockSizeHorizontal * 100,
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) => event_index_show(index),
                      separatorBuilder: (_, _2) => Divider(),
                      itemCount: monthEventsList[today.day].length < 0
                          ? 0
                          : monthEventsList[today.day].length)),
            ),
          ]),
    );
  }

  void reg_event() {
    showDialog(
        context: context,
        builder: (context) {
          List<bool> groupChecked =
              List<bool>.generate(menteeList.length, (index) => false);
          return StatefulBuilder(builder: (context, setState) {
            void checkGroup(int index, bool value) {
              setState(() {
                groupChecked[index] = value;
              });
            }

            return AlertDialog(
                scrollable: true,
                title: Center(
                    child: Text(
                  today.toString().split(" ")[0],
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
                content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        child: Column(
                      children: <Widget>[
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
                                  left: SizeConfig.blockSizeHorizontal * 2),
                              filled: false,
                              hintText: 'Event'),
                          onChanged: (val) {
                            setState(() => new_event_title = val);
                          },
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 2),
                        TextField(
                          controller: hour_input,
                          onTap: () async {
                            pickTime();
                          },
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
                                  left: SizeConfig.blockSizeHorizontal * 2),
                              filled: false,
                              hintText: ' pick time'),
                          readOnly: true,
                        ),
                        SizedBox(height: 10),
                        self_index_show(), // TODO: wait for currentUser
                        SizedBox(height: 10),
                        (menteeList.length > 0)
                            ? Center(
                                child: Container(
                                    // TODO: check menteeList before entering this page
                                    height: SizeConfig.blockSizeVertical * 20,
                                    width: SizeConfig.blockSizeHorizontal * 70,
                                    child: ListView.separated(
                                        itemBuilder: (_, index) =>
                                            group_index_show(index,
                                                groupChecked, checkGroup),
                                        separatorBuilder: (_, _2) => Divider(),
                                        itemCount: menteeList.length)))
                            : Center()
                      ],
                    ))),
                actions: [
                  // add new event button
                  FloatingActionButton(
                    onPressed: () async {
                      userEvent e = userEvent(
                          title: new_event_title,
                          date: today,
                          done: false,
                          event_color: "red",
                          id: "");
                      List<String?> group =
                          menteeList.map((mentee) => mentee.id).toList();
                      await addEvent(e, group, groupChecked);
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.add),
                  )
                ]);
          });
        });
  }

  Future<TimeOfDay?> pickTime() async {
    TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: today.hour, minute: today.minute));
    if (time != null) {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');

      String formattedTime = "$hours : $minutes";
      setState(() {
        hour_input.text = formattedTime; //set output date to TextField value.
      });
    } else {
      setState(() {
        hour_input.text = ""; //set output date to TextField value.
      });
    }
    return time;
  }

  Future<http.Response> addEvent(
      userEvent new_event, List<String?> group, List<bool> groupChecked) async {
    List<String> selfId = [FirebaseAuth.instance.currentUser!.uid];
    List<String?> fullGroup =
        group.where((event) => groupChecked[group.indexOf(event)]).toList();
    fullGroup.addAll(selfId);
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.post(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/events"),
        body: json.encode({"data": new_event.toJson(), "group": fullGroup}),
        headers: requestHeaders);
    new_event.id = jsonDecode(response.body)["eid"];
    setState(() {
      monthEventsList[today.day].add(new_event);
    });
    return response;
  }

  Future<http.Response> getEvents() async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                FirebaseAuth.instance.currentUser!.uid +
                "/events?date=" +
                today.toString()),
        // body: json.encode({"date": today.toString()}),
        headers: requestHeaders);

    // get the list of events for the whole month
    final monthResponse = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                FirebaseAuth.instance.currentUser!.uid +
                "/events?month=" +
                today.toString().split(" ")[0].split("-")[1]),
        headers: requestHeaders);

    // set month events
    setState(() {
      monthEventsList =
          createMonthEventList(json.decode(monthResponse.body)["events"]);
    });
    return response;
  }

  Future<http.Response> done_change(bool val, userEvent event) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.put(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/events/" +
                event.id),
        body: json.encode({
          "data": {"done": val}
        }),
        headers: requestHeaders);

    setState(() {
      event.setDone(val);
    });
    return response;
  }

  Future<http.Response> remove_event(userEvent event) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.delete(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/events/" +
                event.id),
        headers: requestHeaders);

    setState(() {
      monthEventsList[today.day].remove(event);
    });
    return response;
  }

  Widget event_index_show(int index) {
    bool isExpanded = false;
    bool goDown = false;
    return StatefulBuilder(builder: (context, setState) {
      if (goDown) {
        // TODO: jump only after new container is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
        setState(() {
          goDown = false;
        });
      }
      return Container(
          alignment: Alignment.center,
          child: Column(children: [
            Row(
              children: [
                TextButton(
                  child: Text(isExpanded ? '|' : '>'),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                      goDown = true;
                    });
                  },
                ),
                Checkbox(
                  value: monthEventsList[today.day][index].done,
                  onChanged: (bool? value) {
                    done_change(
                        value!,
                        monthEventsList[today.day]
                            [index]); // make async for backend consistency
                  },
                  shape: CircleBorder(),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                Text(monthEventsList[today.day][index].title),
                Spacer(),
                IconButton(
                    onPressed: () {
                      remove_event(monthEventsList[today.day][index]);
                    },
                    icon: Icon(Icons.delete)),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
              ],
            ),
            Visibility(
              visible: isExpanded,
              child: Column(
                children: [
                  // Additional content here
                  // Add more widgets as needed
                ],
              ),
            ),
            SizedBox(height: 8.0),
            // show event's group if isExpanded

            isExpanded
                ? event_group_index_show(
                    getGroup(monthEventsList[today.day][index].id.toString()))
                : Container(),
          ]));
    });
  }

  Widget event_group_index_show(
      Future<List<AppUserView>> lst) // show group members
  {
    return FutureBuilder<List<AppUserView>>(
      future: lst,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // ListTile with left margin
              return Container(
                //add left margin
                margin: EdgeInsets.only(left: 20),
                // add vertical line on left side
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      //random color
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                child: ListTile(
                  // contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  // a title in the left with the user name
                  title: Text(
                    snapshot.data![index].name,
                    textAlign: TextAlign.left,
                  ),
                  // a subtitle with the user email
                  // subtitle: Text(snapshot.data![index].mail, textAlign: TextAlign.left,),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<http.Response> getMentees() async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                FirebaseAuth.instance.currentUser!.uid +
                "/mentees"),
        // body: json.encode({"date": today.toString()}),
        headers: requestHeaders);

    setState(() {
      menteeList = createUserViewList(json.decode(response.body));
    });

    final userResponse = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/users/" +
                FirebaseAuth.instance.currentUser!.uid),
        headers: requestHeaders);

    setState(() {
      currentUser = fromJsonV(Map.from(json.decode(userResponse.body)));
    });
    return response;
  }

  Future<List<AppUserView>> getGroup(String eid) async {
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/events/" +
                eid +
                "/group"),
        headers: requestHeaders);
    return userInfoToList(json.decode(response.body));
  }

  void set_auth() async {
    String TauthToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    setState(() {
      authToken = TauthToken;
    });
    getEvents();
    getMentees();
  }
}
