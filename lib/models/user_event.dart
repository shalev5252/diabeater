class userEvent {
  final String title;
  final DateTime date; //needs to be string
  bool done;
  String? event_color; //check if needed
  String id;

  userEvent(
      { required this.id, required this.title, required this.date, this.done = false, this.event_color});

  void setDone(bool val) {
    this.done = val;
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'date': date.toString(),
      'done': done,
      'color': event_color,
    };
  }

  factory userEvent.fromJson(Map<String, dynamic> json) {
     return userEvent(
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      done: json['done'] as bool,
      event_color: json['color'] as String,
       id: json['id'] as String,
    );
  }
}
  List<userEvent> createEventList(List<dynamic> eventList){
    List<userEvent> myEvents = [];
    myEvents = eventList.map<userEvent>((json) => userEvent.fromJson(json)).toList();
    return myEvents;
  }
  List<List<userEvent>> createMonthEventList(List<dynamic> eventList){
    List<List<userEvent>> myEvents = [];
    // divide the eventList to lists by month
    // create a list of lists with 31 lists
    List<List<userEvent>> monthEvents = List<List<userEvent>>.generate(31, (index) => []);
    for (dynamic event in eventList){
      int dayOfMonth = DateTime.parse(event['date']).day;
      monthEvents[dayOfMonth].add(userEvent.fromJson(event));
    }
    return monthEvents;
  }
