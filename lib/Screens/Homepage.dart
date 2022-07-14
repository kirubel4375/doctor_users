import 'package:doctor_users/Widgets/ContactPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Functions/firebase_auth.dart';
import '../Widgets/HomePageBody.dart';
import '../Widgets/ProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Doctors"),
          actions: [
            IconButton(
              onPressed: ()async{
                await context.read<AuthenticationService>().signOut();
                
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          currentIndex: _currentIndex,
          elevation: 0.0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "My Patients",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
        body: _currentIndex == 0
            ? const SingleChildScrollView(child: HomePageBody())
            : _currentIndex == 1
                ? const ContactPage()
                : const ProfilePage(),
      ),
    );
  }
}
