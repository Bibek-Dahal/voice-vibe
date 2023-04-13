import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static Future<String?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      print("pickFile called");
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 3,
      );

// getting a directory path for saving

      if (pickedImage != null) {
        File tmpFile = File(pickedImage.path);
        print(pickedImage.path);
        return pickedImage.path;
      }
      // var myDir = Directory('crud/lib/assets/image');
      // return pickedImage;
      return null;
    } catch (error) {
      print("error: $error");
      // return null;
    }
    return null;
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> showMyDialog(
      BuildContext context, List<Widget> message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(children: message),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showAlertBox(BuildContext context, dynamic error) async {
    if (error is List) {
      // String e = '';
      // for (String err in error) {
      //   e += err;
      // }
      List<Widget> em = [];
      for (String err in error) {
        em.add(Text(err));
      }
      showMyDialog(context, em);
    } else if (error is Map<String, dynamic>) {
      print(error);
      List<Widget> em = [];
      for (String err in error.values.toList()) {
        em.add(Text(err));
      }

      showMyDialog(context, em);
    } else {
      print("inside else");
      showMyDialog(context, [Text(error.message)]);
    }
  }
}
