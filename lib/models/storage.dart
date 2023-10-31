import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      if (await file.exists()) {
        await storage.ref('mattbarber_image/$fileName').putFile(file);
      } else {
        print("Path not exist");
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> downloadURL(String imageName) async {
    String downloadUrl =
        await storage.ref('mattbarber_image/$imageName').getDownloadURL();

    return downloadUrl;
  }
}
