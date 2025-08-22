import 'package:flutter/material.dart';
import 'student_info.dart'; // To reuse Student + students list

class CourseHomePage extends StatefulWidget {
  @override
  _CourseHomePageState createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  int _currentIndex = 0;
  String selectedCategory = "None";
  bool _enrollPressed = false;

  final List<Map<String, String>> courses = [
    {"name": "Flutter Development", "instructor": "Mr. Botchway"},
    {"name": "Web Development", "instructor": "Dr. Eshun"},
    {"name": "Database Systems", "instructor": "Mr. Opoku"},
    {"name": "Networking", "instructor": "Mr. Ayitey"},
    {"name": "Cyber Security", "instructor": "Mr. Jacob"},
  ];

  Widget _getBody() {
    if (_currentIndex == 0) {
      return Center(child: Text("Home", style: TextStyle(fontSize: 24)));
    } else if (_currentIndex == 1) {
      return ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.book),
            title: Text(courses[index]["name"]!),
            subtitle: Text("Instructor: ${courses[index]["instructor"]}"),
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(students[index].imageUrl),
            ),
            title: Text(students[index].name),
            subtitle: Text(students[index].email),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Course Dashboard")),
      body: Column(
        children: [
          Expanded(child: _getBody()),
          if (_currentIndex == 1) ...[
            SizedBox(height: 10),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _enrollPressed ? 200 : 120,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _enrollPressed = !_enrollPressed;
                  });
                },
                child: Text("Enroll"),
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedCategory == "None" ? null : selectedCategory,
              hint: Text("Select Category"),
              items: ["Science", "Arts", "Technology"]
                  .map((cat) =>
                  DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            Text("Selected: $selectedCategory",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
          ]
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profiles"),
        ],
      ),
    );
  }
}
