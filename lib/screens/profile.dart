import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/constants/constants.dart';
import 'package:final_app/screens/login_screen.dart';
import 'package:final_app/screens/profile_screen.dart';
import 'package:final_app/screens/welcome_screen.dart';
import 'package:final_app/utils/ProductProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/rounded_button.dart';

class ProfileViewScreen extends ConsumerStatefulWidget {
  const ProfileViewScreen({super.key});
  static const id = "profile_view_screen";
  @override
  ConsumerState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends ConsumerState<ProfileViewScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late final String? uid;
  Map<String, dynamic>? profileData;

  logOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isCartDataFetched');
    prefs.remove('isFavoriteDataFetched');
    prefs.remove("userId");
    prefs.remove("isLoggedIn");
    ref.watch(productProvider.notifier).clearCartState();
    // ref.watch(favoriteProvider.notifier).clearFavorite();
    Navigator.pushNamed(context, WelcomeScreen.id);
  }

  Future<String?> getUid() async {
    if (_auth.currentUser != null) {
      uid = _auth.currentUser?.uid;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("userId");
      if (userId != null) {
        return userId;
      } else {
        Navigator.pushNamed(context, LoginScreen.id);
      }
    }
    return uid;
  }

  Future<void> getUserProfileData() async {
    try {
      final DocumentSnapshot profileSnapshot =
          await _firestore.collection('userProfile').doc(uid).get();
      if (profileSnapshot.exists) {
        profileData = profileSnapshot.data() as Map<String, dynamic>;
      } else {
        print("Profile of a user is not found");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUid().then((_) {
      getUserProfileData().then((_) {
        setState(() {}); // Trigger a rebuild when data is available.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'User Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
      ),
      body: profileData == null
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Show a loading indicator while fetching data
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 80.0,
                            backgroundColor: Colors.grey,
                          ),
                          CircleAvatar(
                            radius: 75.0,
                            backgroundImage: NetworkImage(profileData?[
                                    'imageUrl'] ??
                                "https://flyinryanhawks.org/wp-content/uploads/2016/08/profile-placeholder.png"),
                          ),
                          Positioned(
                            top: 5.0,
                            left: 114.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      initialName: profileData?['name'],
                                      initialBiography:
                                          profileData?['biography'],
                                      initialImageUrl: profileData?[
                                          'imageUrl'], // Assuming the image data is stored as a List<int> in Firestore// Pass the initial image data here if available, or null if not
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.colorize_outlined,
                                size: 40.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        profileData?['name'] ?? "Name Goes Here",
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        profileData?['biography'] ?? "Biography Goes Here",
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      RoundedButton(
                        "Logout",
                        WelcomeScreen.id,
                        customOnPressed: logOut,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
