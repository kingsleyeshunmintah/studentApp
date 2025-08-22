import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// STUDENT MODEL

class Student {
  final String name;
  final String email;
  final String password;
  final String imageUrl;

  Student(
      {required this.name,
        required this.email,
        required this.password,
        required this.imageUrl});
}

// Global list to store students
List<Student> students = [];


/// STUDENT REGISTRATION

class StudentRegisterPage extends StatefulWidget {
  @override
  _StudentRegisterPageState createState() => _StudentRegisterPageState();
}

class _StudentRegisterPageState extends State<StudentRegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final imageController = TextEditingController();
  String message = "";

  void _register() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String imageUrl = imageController.text.trim();

    if (name.isEmpty || !email.contains("@") || password.length < 6) {
      setState(() => message = "Invalid details! Check inputs.");
      return;
    }

    students.add(Student(
        name: name, email: email, password: password, imageUrl: imageUrl));

    setState(() => message = "Registration successful! Go to login.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Student")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            TextField(controller: imageController, decoration: InputDecoration(labelText: "Profile Image URL")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: Text("Register")),
            SizedBox(height: 10),
            Text(message, style: TextStyle(color: Colors.greenAccent)),
          ],
        ),
      ),
    );
  }
}

/// STUDENT LOGIN

class StudentLoginPage extends StatefulWidget {
  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = "";

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    Student? foundStudent = students.firstWhere(
            (s) => s.email == email && s.password == password,
        orElse: () => Student(name: "", email: "", password: "", imageUrl: ""));

    if (foundStudent.email.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("loggedInEmail", foundStudent.email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => StudentHomePage(
                name: foundStudent.name,
                email: foundStudent.email,
                imageUrl: foundStudent.imageUrl)),
      );
    } else {
      setState(() => errorMessage = "Invalid credentials!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Login")),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StudentRegisterPage()));
              },
              child: Text("Create an Account"),
            )
          ],
        ),
      ),
    );
  }
}


/// STUDENT HOME

class StudentHomePage extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;

  StudentHomePage(
      {required this.name, required this.email, required this.imageUrl});

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("loggedInEmail");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => StudentLoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Info Manager"),
        actions: [
          IconButton(onPressed: () => _logout(context), icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              "https://tse3.mm.bing.net/th/id/OIP.1ws48BTU05guhTXbcpqrIAHaFj?rs=1&pid=ImgDetMain&o=7&rm=3",
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 50),
            SizedBox(height: 10),
            Text("Name: $name", style: TextStyle(fontSize: 20)),
            Text("Email: $email", style: TextStyle(fontSize: 16)),
            Text("University of Energy & Natural Resources",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

/// Helper for splash auto-login
class StudentHomePageAutoLogin extends StatelessWidget {
  final String email;
  StudentHomePageAutoLogin({required this.email});

  @override
  Widget build(BuildContext context) {
    final student = students.firstWhere((s) => s.email == email,
        orElse: () => Student(
            name: "Unknown", email: email, password: "", imageUrl: ""));
    return StudentHomePage(
        name: student.name, email: student.email, imageUrl: student.imageUrl);
  }
}
