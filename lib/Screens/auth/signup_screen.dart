// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../components/help.button.dart';
import '../../constants/colors.dart';
import '../../utils.dart';
import '../../homepage/home_page.dart';
import 'login_screen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _usersCollection = FirebaseFirestore.instance.collection('users');

  bool _isLoading = false;

  File? _pickedImage;

  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image, String userId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('$userId.jpg');
    await ref.putFile(image);
    final imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  Future<File> _createDefaultImage() async {
    final appDir = await getApplicationDocumentsDirectory();
    final defaultImage = File('${appDir.path}/default_profile.jpg');
    await defaultImage.writeAsBytes(
        (await rootBundle.load('assets/images/default_profile.jpg'))
            .buffer
            .asUint8List());
    return defaultImage;
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      String profilePictureUrl =
          'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352064-stock-illustration-default-placeholder-profile-icon.jpg'; // Replace with your default profile picture URL

      // Upload the profile picture to Firebase Storage
      if (_profileImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${userCredential.user!.uid}.jpg');
        await storageRef.putFile(_profileImage!);
        profilePictureUrl = await storageRef.getDownloadURL();
      }

      // Save user information in Firestore
      final user = {
        'email': _emailController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'username': _usernameController.text,
        'profilePictureUrl': profilePictureUrl,
      };

      await _usersCollection.doc(userCredential.user!.uid).set(user);

      if (userCredential.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              firebaseSession: userCredential.user!.uid, session: '',
              // Pass the Myfxbook session ID here, if available
            ),
          ),
          (Route<dynamic> route) =>
              false, // This will remove all previous routes from the stack
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to register. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/dark_back.png"), fit: BoxFit.cover)),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/tradestack.png",
                    width: 100,
                    alignment: Alignment.center,
                  ),
                  Material(
                    child: SizedBox(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          "Sign Up",
                                          style: SafeGoogleFont(
                                            'Roboto',
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            height: 1.5,
                                            color: GlobalColors.secondaryColor,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: _firstNameController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter your first name';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                labelText: 'First Name',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _lastNameController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter your last name';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                labelText: 'Last Name',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _usernameController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter a username';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Username',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Password',
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        GlobalColors.thirdColor
                                                            .withOpacity(0.7)),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    side: BorderSide(
                                                        color: GlobalColors
                                                            .thirdColor),
                                                  ),
                                                ),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(
                                                  const Size(
                                                      double.infinity, 40),
                                                ),
                                              ),
                                              onPressed: _isLoading
                                                  ? null
                                                  : _pickImage,
                                              child: _isLoading
                                                  ? const CircularProgressIndicator()
                                                  : const Text(
                                                      'Upload Profile Picture (Optional)'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(GlobalColors
                                                            .secondaryColor
                                                            .withOpacity(0.7)),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    side: BorderSide(
                                                        color: GlobalColors
                                                            .secondaryColor),
                                                  ),
                                                ),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(
                                                  const Size(
                                                      double.infinity, 40),
                                                ),
                                              ),
                                              onPressed:
                                                  _isLoading ? null : _register,
                                              child: _isLoading
                                                  ? const CircularProgressIndicator()
                                                  : const Text('Register'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "OR",
                                        style: SafeGoogleFont(
                                          'Roboto',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          height: 1.5,
                                          color: GlobalColors.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(GlobalColors
                                                            .secondaryColor
                                                            .withOpacity(0.7)),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    side: BorderSide(
                                                        color: GlobalColors
                                                            .secondaryColor),
                                                  ),
                                                ),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(
                                                  const Size(
                                                      double.infinity, 40),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          (const LoginPage())),
                                                );
                                              },
                                              child:
                                                  const Text('Back to Login'),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: HelpButton(
                                                textColor: Colors.white,
                                                backgroundColor:
                                                    GlobalColors.primaryColor,
                                                height: 40,
                                                borderColor:
                                                    GlobalColors.primaryColor,
                                                text: "Send Money",
                                                isIcon: true,
                                                icon: Icons.question_mark,
                                                // icon: icon)
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
