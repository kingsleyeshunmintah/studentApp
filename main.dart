import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'student_info.dart';
import 'course_dashboard.dart';

void main() {
  runApp(CombinedApp());
}

class CombinedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student & Course Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}


///  SPLASH SCREEN

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("loggedInEmail");

    await Future.delayed(Duration(seconds: 2));

    if (email != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudentHomePageAutoLogin(email: email),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Colors.greenAccent),
            SizedBox(height: 20),
            Text("UENR Student & Course Manager",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.greenAccent),
          ],
        ),
      ),
    );
  }
}


///  MAIN MENU

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main Menu")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Student Information Manager"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StudentLoginPage()));
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Course Dashboard"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CourseHomePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
