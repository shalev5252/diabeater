import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:diabeater/models/loading.dart';
import 'package:diabeater/models/shared_code.dart';
import 'package:diabeater/screens/admin/sideBar.dart';
import 'package:diabeater/screens/article_page/article_page.dart';
import 'package:diabeater/screens/calendar/calendar.dart';
import 'package:diabeater/screens/recepie_page/recipe_page.dart';
import 'package:diabeater/screens/tasks/tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/appBar.dart';
import '../../models/app_users.dart';
import '../../models/screenSizeFit.dart';
import '../../services/auth.dart';
import '../mentor_mentee_management/mentee_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool loading = true;
  bool mentor_switch = true;
  var firebaseUser = FirebaseAuth.instance.currentUser!;
  final current_user = FirebaseAuth.instance;
  late Future myFuture = getFuture();
  final user_id = FirebaseAuth.instance.currentUser!.uid;

  //late final Future<String> _value;
  @override
  void initState() {
    super.initState();
    myFuture = getFuture();
  }

  int index = 2;
  final AuthService _auth = AuthService();
  var screens = [
    ArticlePage(),
    RecipePage(),
    GoalsPage(),
    CalendarPage(),
    MenteePage(),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user_id)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError)
            return Text(
                AppLocalizations.of(context)!.error('${snapshot.error}'));
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              drawer: SideBar(userInfo: fromJson(data)),
              appBar: aplicationAppBar(),
              body: screens[index],
              bottomNavigationBar: CurvedNavigationBar(
                index: index,
                items: curvedNavBarWidgets(data),
                color: chosenBlue,
                backgroundColor: Colors.transparent,
                buttonBackgroundColor: Colors.blueAccent,
                onTap: (index) {
                  setState(() => this.index = index);
                },
              ),
            );
          }
          return Loading();
        },
      ),
      // body: FutureBuilder(
      //   future: myFuture,
      //   builder: (BuildContext context, snapshot) {
      //     if (snapshot.hasError) return Text('Error = ${snapshot.error}');
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Loading();
      //     }
      //     if(snapshot.hasData){
      //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
      //       return Scaffold(
      //         drawer: SideBar(userInfo: fromJson(data)),
      //         appBar: AppBar(
      //           automaticallyImplyLeading: true,
      //           backgroundColor: chosenBlue,
      //           title: Image.asset(
      //             'assets/white_empty_logo.png',
      //             height: 50,
      //             width: 50,
      //           ),
      //           actions: <Widget>[
      //             TextButton.icon(
      //                 onPressed: () async {
      //                   await _auth.signOut();
      //                   // Remove any route in the stack
      //                   Navigator.of(context).popUntil((route) => false);
      //                   Navigator.push(
      //                     context,
      //                     CupertinoPageRoute(builder: (context) => const DiabeaterOnboarding()),
      //                   );
      //                 },
      //                 icon: const Icon(Icons.person, color: Colors.white,),
      //                 label: const Text('logout',style: TextStyle(color: Colors.white),)),
      //           ],
      //         ),
      //         body: screens[index],
      //         bottomNavigationBar: CurvedNavigationBar(
      //           index: index,
      //           items: curvedNavBarWidgets(data),
      //           color: chosenBlue,
      //           backgroundColor: Colors.transparent,
      //           onTap: (index){print("size of screens: ${screens.length}");
      //             setState(() => this.index = index);},
      //         ),
      //       );
      //     }
      //     return Text("error");
      //   },
      // ),
    );
  }

  List<Widget> curvedNavBarWidgets(Map<String, dynamic> data) {
    List<Widget> listOfWidgets = [
      Icon(
        Icons.article,
        color: Colors.white,
        size: 30,
      ),
      Icon(
        Icons.restaurant,
        color: Colors.white,
        size: 30,
      ),
      Icon(
        Icons.home,
        color: Colors.white,
        size: 30,
      ),
      Icon(
        Icons.calendar_month,
        color: Colors.white,
        size: 30,
      ),
      Icon(
        Icons.person,
        color: Colors.white,
        size: 30,
      ),
    ];

    return listOfWidgets;
  }

  Future getFuture() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(current_user.currentUser!.uid)
        .get();
  }
}
