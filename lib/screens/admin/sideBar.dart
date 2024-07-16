import 'dart:io';
import 'package:diabeater/screens/mentor_mentee_management/admin_page.dart';
import 'package:diabeater/screens/mentor_mentee_management/mentor_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../home/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../models/app_users.dart';
import '../../models/screenSizeFit.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../mentor_mentee_management/admin_mentors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideBar extends StatefulWidget {
  final AppUser userInfo;

  const SideBar({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String background_picUrl = "";
  String profile_picUrl = "";

  //'https://firebasestorage.googleapis.com/v0/b/diabeater-77bc9.appspot.com/o/images%2F1abb14d4-9212-4717-a9f6-1b7b68e115a4?alt=media&token=8a6618c5-5949-46ee-a283-0f9322a39ea6';
  String authToken = '';
  User? user;
  final user_id = FirebaseAuth.instance.currentUser!.uid;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    background_picUrl = widget.userInfo.backgroundPicUrl;
    profile_picUrl = widget.userInfo.profilePicUrl;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(children: [
        UserAccountsDrawerHeader(
            accountName: Text(widget.userInfo.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            accountEmail: Text(widget.userInfo.mail,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            currentAccountPicture: CircleAvatar(
                child: ClipOval(
                    child: Image.network(profile_picUrl,
                        width: 90, height: 90, fit: BoxFit.cover))),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(background_picUrl), fit: BoxFit.fill),
            ) //DecorationImage(image: Image.network('https://firebasestorage.googleapis.com/v0/b/diabeater-77bc9.appspot.com/o/images%2F18e09194-eea3-4b51-ac18-5233bfc2cb36?alt=media&token=c7d767fe-c2d7-4895-83e8-8df0a90933c2',fit: BoxFit.fill).image,)),
            //decoration: BoxDecoration(image: DecorationImage(image: Image.network("https://firebasestorage.googleapis.com/v0/b/diabeater-77bc9.appspot.com/o/images%2Ff412751d-8f71-49d8-8a61-d3574572b90a?alt=media&token=8399a3c4-1fb7-49fe-8ab7-58bb1733e7dc").image,fit: BoxFit.fill)),

            ),
        ListTile(
            leading: Icon(Icons.picture_in_picture_alt_sharp),
            title: Text(AppLocalizations.of(context)!.change_background),
            onTap: () => selectPhoto(true)),
        ListTile(
            leading: Icon(Icons.picture_in_picture_alt_sharp),
            title: Text(AppLocalizations.of(context)!.change_profile),
            onTap: () => selectPhoto(false)),
        widget.userInfo.mentor ? Divider() : Container(), //here is a divider
        mentorVsMentee(),
        widget.userInfo.admin ? Divider() : Container(), //here is a divider
        adminUnmentoredPatients(),
        adminMentors(),
        Expanded(child: Container()),
        ListTile(
          leading: Icon(Icons.arrow_back),
          title: Text(AppLocalizations.of(context)!.logout),
          onTap: () async {
            await _auth.signOut();
            // Remove any route in the stack
            Navigator.of(context).popUntil((route) => false);
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const DiabeaterOnboarding()),
            );
          },
        )
      ]),
    );
  }

  ListTile mentorVsMentee() {
    if (widget.userInfo.mentor == true) {
      return ListTile(
          leading: Icon(Icons.person_add),
          title: Text(AppLocalizations.of(context)!.mentee_management),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MentorPage()));
          });
    }
    return ListTile();
  }

  ListTile adminMentors() {
    if (widget.userInfo.admin == true) {
      return ListTile(
          leading: Icon(Icons.person_add),
          title: Text(AppLocalizations.of(context)!.mentor_management),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminPageMentors()));
          });
    }
    return ListTile();
  }

  ListTile adminUnmentoredPatients() {
    if (widget.userInfo.admin == true) {
      return ListTile(
          leading: Icon(Icons.person_off),
          title: Text(AppLocalizations.of(context)!.unmentored_petients),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminPageUnMentoredPatients()));
          });
    }
    return ListTile();
  }

  Future selectPhoto(bool is_background) async {
    showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      leading: Icon(Icons.camera),
                      title: Text(AppLocalizations.of(context)!.camera),
                      onTap: () {
                        Navigator.of(context).pop();
                        pickImage(ImageSource.camera, is_background);
                      }),
                  ListTile(
                      leading: Icon(Icons.filter),
                      title: Text(AppLocalizations.of(context)!.pick_gallery),
                      onTap: () {
                        Navigator.of(context).pop();
                        pickImage(ImageSource.gallery, is_background);
                      }),
                ],
              ),
              onClosing: () {},
            ));
  }

  Future pickImage(ImageSource source, bool is_background) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) return;
    //File? file = await Utils.cropSelectedImage(pickedFile.path,context);
    //var file = await ImageCropper().cropImage(sourcePath: pickedFile.path, aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    //if (file == null) return;
    // File? file2 = await compressImage(pickedFile.path,35);
    // if (file2 == null) return;
    _uploadFile(pickedFile, is_background);
  }

  // Future<File?> compressImage(String path, int quality) async{
  //   final newPath = p.join((await getTemporaryDirectory()).path, '${DateTime.now()}.${p.extension(path)}');
  //   final result = await FlutterImageCompress.compressAndGetFile(path, newPath,quality: quality);
  //   return result;
  // }
  Future _uploadFile(XFile pickedFile, bool is_background) async {
    if (!kIsWeb) {
      final ref = FirebaseStorage.instance.ref().child('images').child(
          '${DateTime.now().toIso8601String() + p.basename(pickedFile.path)}');

      final result = await ref.putFile(File(pickedFile.path));
      final fileUrl = await result.ref.getDownloadURL();
      setState(() {
        widget.userInfo.backgroundPicUrl = fileUrl;
      });
    }
    if (kIsWeb) {
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child('images/${p.basename(pickedFile.path)}');
      await _reference
          .putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        try {
          await _reference.getDownloadURL().then((value) {
            DatabaseService(uid: user_id)
                .updateUserbackgroundPic(value, is_background);
            setState(() {
              if (is_background)
                background_picUrl = value;
              else
                profile_picUrl = value;
            });
          });
        } catch (e) {
          return null;
        }
      });
    }
  }
}
