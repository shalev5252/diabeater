class Pair<T1, T2> {
   T1 a;
   T2 b;

  Pair(this.a, this.b);
}

class userGoal {
  final String Goal_description;
  final String Goal_name; //needs to be string
  final int Goal_progress;
  final int Goal_target;
  final String Goal_last_date;
  bool reached;

  userGoal(
      { required this.Goal_description, required this.Goal_name, required this.Goal_progress, required this.Goal_target, required this.Goal_last_date, this.reached = false });

  void done_change(bool val) {
    if (reached != null) {
      this.reached = val;
    }
    else {
      this.reached = val;
    }
  }

  Map<String, Object?> toJson() {
    return {
      'description': Goal_description.toString(),
      'name': Goal_name.toString(),
      'progress': Goal_progress,
      'target': Goal_target,
      'date': Goal_last_date.toString(),
    };
  }

  factory userGoal.fromJson(Map<String, dynamic> json) {
    if(json['date'] == null){
      json['date'] = "";
    };
    return userGoal(
      Goal_description: json['description'] as String,
      Goal_name: json['name'] as String,
      Goal_progress: json['progress'] as int,
      Goal_target: json['target'] as int,
      Goal_last_date: json['date'] as String,
    );
  }


}
String gidfromJson(Map<String, dynamic> json) {
  return json['gid'] as String;
}
List<userGoal> createGoalList(List<dynamic> goalList){
  List<userGoal> myGoals = [];
  myGoals = goalList.map<userGoal>((json) => userGoal.fromJson(json["data"])).toList();
  return myGoals;
}

Map<String,userGoal> createNewGoalList(List<dynamic> goalList){
  Map<String,userGoal> goal_dictionary = new Map();
  for (Map<String, dynamic> json in goalList){
    String key = gidfromJson(json);
    userGoal value = userGoal.fromJson(json["data"]);
    goal_dictionary.putIfAbsent(key, () => value);
  }

  return goal_dictionary;
}

