class AppUser {
  String mail;
  String name;
  String phone_number;
  bool mentor;
  DateTime? birthday;
  String backgroundPicUrl = 'https://firebasestorage.googleapis.com/v0/b/diabeater-77bc9.appspot.com/o/images%2F1abb14d4-9212-4717-a9f6-1b7b68e115a4?alt=media&token=8a6618c5-5949-46ee-a283-0f9322a39ea6';
  String profilePicUrl = 'https://firebasestorage.googleapis.com/v0/b/diabeater-77bc9.appspot.com/o/setup_images%2Ffd58d853-b2d5-4520-bc5f-fc05f5a90fc7?alt=media&token=2c34d72c-1297-438f-ae33-be25ea119844';
  bool admin = false;

  AppUser({required this.mail,required this.name,required this.phone_number,required this.mentor, this.birthday});

  AppUser.withoutBirthDay({required this.mail,required this.name,required this.phone_number,required this.mentor}){
    this.birthday=null;
  }
  AppUser.fromServer(this.mail,this.name,this.phone_number,this.mentor,this.backgroundPicUrl,this.profilePicUrl,this.birthday,this.admin);

  AppUser.admin(this.mail,this.name,this.phone_number,this.mentor,this.backgroundPicUrl,this.profilePicUrl,this.birthday,this.admin);

  Map<String, Object?> toJson() {
    return {
      'mail': mail,
      'name': name,
      'birthday': birthday!=null ? birthday.toString() :'',
      'phone':phone_number,
      'isMentor': mentor,
      'backgroundPicUrl': backgroundPicUrl,
      'profilePicUrl':profilePicUrl,
    };
  }
}

AppUser fromJson(Map<String, Object?> json) {
  if (json.containsKey("isAdmin")){
    return AppUser.admin(
        json['mail'] as String,
        json['name'] as String,
        json['phone'] as String,
        json['isMentor'] as bool,
        json['backgroundPicUrl'] as String,
        json['profilePicUrl'] as String,
        DateTime.now(), ///todo fix it
        json['isAdmin'] as bool,
    );
  }

  return AppUser.fromServer(
      json['mail'] as String,
      json['name'] as String,
      json['phone'] as String,
      json['isMentor'] as bool,
      json['backgroundPicUrl'] as String,
      json['profilePicUrl'] as String,
      DateTime.parse(json['birthday'] as String),
      false
  );
}

//Todo check if works
List<AppUser> createUserList(List<dynamic> userList){
  List<AppUser> my_users = [];
  my_users = userList.map<AppUser>((json) => fromJson(json)).toList();
  return my_users;
}

class AppUserView {
  String mail = "";
  String name = "";
  String phone_number = "";
  String profilePicUrl = "";
  String? id = "";

  AppUserView(
      {required this.mail, required this.name, required this.phone_number, required this.profilePicUrl, this.id});

}
AppUserView fromJsonV(Map<String, Object> json) {
  if(json['uid'] == null)
    {
      return AppUserView(
          mail: json['mail'] as String,
          name:json['name'] as String,
          phone_number:json['phone'] as String,
          profilePicUrl:json['profilePicUrl'] as String,
          id: "",
      );
    }
  return AppUserView(
    mail: json['mail'] as String,
    name:json['name'] as String,
    phone_number:json['phone'] as String,
    profilePicUrl:json['profilePicUrl'] as String,
    id: json['uid'] as String,
  );
}


AppUserView fromJsonV2(Map<String, Object> json,String uid) {
    return AppUserView(
      mail: json['mail'] as String,
      name:json['name'] as String,
      phone_number:json['phone'] as String,
      profilePicUrl:json['profilePicUrl'] as String,
      id: uid,
    );
}

List<AppUserView> createUserViewList(List<dynamic> userList) {
  List<AppUserView> my_users = [];
  my_users = userList.map<AppUserView>((json) => fromJsonV2(Map.from(json["data"]),json["uid"])).toList();
  return my_users;
}

List<AppUserView> userInfoToList(List<dynamic> userList) {
  List<AppUserView> my_users = [];
  my_users = userList.map<AppUserView>((json) => fromJsonV2(Map.from(json),json["uid"])).toList();
  return my_users;
}