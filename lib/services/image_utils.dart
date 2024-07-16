import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Utils {
  Utils._();

  /// Open image gallery and pick an image
  static Future<XFile?> pickImageFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  /// Pick Image From Gallery and return a File
  static Future<File?> cropSelectedImage(
      String filePath, BuildContext context) async {
    print("enters crop");
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          viewPort:
              const CroppieViewPort(width: 360, height: 200, type: 'rectangle'),
          enableResize: true,
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    if (croppedImage != null) {
      print("cropped set true");
      return File(croppedImage.path);
    } else
      return null;
  }

// ///post function straight to Firestore (will change soon)
//   static Future post({required File? image}) async{
//     if (image==null) return;
//     //Upload to Firebase
//   final _firebaseStorage = FirebaseStorage.instance;
//       var snapshot = await _firebaseStorage.ref()
//           .child('images/imageName')
//           .putFile(file).onComplete;
//       var downloadUrl = await snapshot.ref.getDownloadURL();
//       setState(() {
//         imageUrl = downloadUrl;
//       });
//     }
//   }
// uploadImage() async {
//   final _firebaseStorage = FirebaseStorage.instance;
//   final _imagePicker = ImagePicker();
//   PickedFile image;
//   //Check Permissions
}
