import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStatusPage extends StatefulWidget {
  @override
  _AddStatusPageState createState() => _AddStatusPageState();
}

class _AddStatusPageState extends State<AddStatusPage> {
  final _captionController = TextEditingController();

  Future<void> _uploadImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('status/${DateTime.now().toString()}');
      final uploadTask = storageRef.putFile(File(pickedFile.path));

      // Get image URL from Firebase Storage
      final taskSnapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Save image URL and caption to Firestore
      await FirebaseFirestore.instance.collection('status').add({
        'imageUrl': imageUrl,
        'caption': _captionController.text,
        'createdAt': DateTime.now(),
      });

      // Navigate back to the status display page
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Status'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _uploadImage();
            },
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey,
              child: Icon(
                Icons.camera_alt,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: 'Enter caption (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
