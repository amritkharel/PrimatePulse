import 'dart:typed_data';
import 'package:final_app/components/rounded_button.dart';
import 'package:final_app/screens/profile.dart';
import 'package:final_app/screens/welcome_screen.dart';
import 'package:final_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants/constants.dart';
import 'package:final_app/resources/add_data.dart';

class ProfileScreen extends StatefulWidget {
  final String? initialName;
  final String? initialBiography;
  final String? initialImageUrl;

  ProfileScreen({this.initialName, this.initialBiography, this.initialImageUrl});

  static const id = "profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String ? imageUrl;
  Uint8List? _image;
  bool update = false;
  String ? userId;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfile() async {
    setState(() {
      showSpinner = true;
    });
    String resp = await StoreData().saveData(
      uid: userId!,
      name: usernameController.text,
      bio: bioController.text,
      file: _image!,
    );
    usernameController.clear();
    bioController.clear();
    setState(() {
      showSpinner = false;
    });
    Navigator.pushNamed(context, ProfileViewScreen.id);
  }

  void updateProfile() async {
    setState(() {
      showSpinner = true;
    });
    String resp = await StoreData().updateData(
      uid: userId!,
      name: usernameController.text,
      bio: bioController.text,
      file: _image!,
    );
    usernameController.clear();
    bioController.clear();
    setState(() {
      showSpinner = false;
    });
    Navigator.pushNamed(context, ProfileViewScreen.id);
  }
  void updateProfileWithoutImage() async {
    setState(() {
      showSpinner = true;
    });
    String resp = await StoreData().updateDataWithoutImage(
      uid: userId!,
      name: usernameController.text,
      bio: bioController.text,
    );
    usernameController.clear();
    bioController.clear();
    setState(() {
      showSpinner = false;
    });
    Navigator.pushNamed(context, ProfileViewScreen.id);
  }

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
    if(widget.initialName != null){
      update = true;
    }
    usernameController.text = widget.initialName ?? "";
    bioController.text = widget.initialBiography ?? "";
    imageUrl = widget.initialImageUrl ?? "https://flyinryanhawks.org/wp-content/uploads/2016/08/profile-placeholder.png";
    print(widget.initialImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: Container(
          decoration: backgroundDecoration,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                          radius: 60.0,
                          backgroundImage: MemoryImage(_image!),
                        )
                            : CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                            imageUrl!
                              ),
                        ),
                        Positioned(
                          bottom: -10.0,
                          left: 70.0,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 40.0),
                    child: TextField(
                      controller: usernameController,
                      textAlign: TextAlign.center,
                      decoration: textFieldProperty.copyWith(
                        hintText: "Enter a Nickname You like",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 40.0),
                    child: TextField(
                      controller: bioController,
                      textAlign: TextAlign.center,
                      decoration: textFieldProperty.copyWith(
                        hintText: "Write Something about you",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  RoundedButton(
                    "Save",
                    WelcomeScreen.id,
                    customOnPressed: !update ? saveProfile : _image != null ?updateProfile : updateProfileWithoutImage,
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
