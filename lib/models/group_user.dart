class groupUser {
  final String name;
  final String mail;
  final String phone;
  String profilePicUrl;

  groupUser(
      { required this.name, required this.mail, required this.phone, required this.profilePicUrl});


  /*Map<String, Object?> toJson() {
    return {
      'title': title,
      'date': date.toString(),
      'done': done,
      'color': event_color,
    };
  }*/

  factory groupUser.fromJson(Map<String, dynamic> json) {
    return groupUser(
      name: json['name'] as String,
      mail: json['mail'] as String,
      phone: json['phone'] as String,
      profilePicUrl: json['profilePicUrl'] as String,
    );
  }
}

List<groupUser> createGroupList(List<dynamic> eventList){
  List<groupUser> myGroup = [];
  myGroup = eventList.map<groupUser>((json) => groupUser.fromJson(json)).toList();
  return myGroup;
}

