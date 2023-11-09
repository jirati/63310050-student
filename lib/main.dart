import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    name: 'my_flutter_app',
    options: FirebaseOptions(
      apiKey: "AIzaSyA45xToDcCR4db3AQ2I9mz7XaxVR6rdq_E",
      authDomain: "student-list-1507a.firebaseapp.com",
      projectId: "student-list-1507a",
      storageBucket: "student-list-1507a.appspot.com",
      messagingSenderId: "1020608351939",
      appId: "1:1020608351939:web:3b6a9faf422eba924c9c76",
      measurementId: "G-NWGR31L8EN"
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter Web App',
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StudentListPage();
          }
          if (snapshot.hasError) {
            return Text('Error initializing Firebase');
          }
          return CircularProgressIndicator(); // Show a loading indicator while Firebase initializes
        },
      ),
    );
  }
}

class StudentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: Column(
        children: [
          StudentList(),
          StudentForm(),
        ],
      ),
    );
  }
}

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  DatabaseReference? databaseReference; // Declare as nullable
  DataSnapshot? dataSnapshot;

  @override
  void initState() {
    super.initState();
    fetchData();
  }
Future<void> fetchData() async {
  if (Firebase.apps.isNotEmpty) {
    // Firebase has been initialized
    
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("student");
      
      DatabaseEvent event = await databaseReference.once();
      if (event.snapshot != null) {
        print("have snapshot");
        DataSnapshot snapshot = event.snapshot;
        setState(() {
          dataSnapshot = snapshot;
        });
      } else {
        // Handle the case when there is no snapshot
        print('ไม่มีข้อมูล');
      }
    } catch (error) {
      // Handle errors when fetching data
      print('เกิดข้อผิดพลาดในการดึงข้อมูล: $error');
    }
  } else {
    print('Firebase has not been initialized yet.');
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (dataSnapshot != null)
          Text('Data: ${dataSnapshot!.value}')
        else
          Text('Loading data...'),
        ElevatedButton(
          onPressed: fetchData,
          child: Text('Refresh Data'),
        ),
      ],
    );
  }
}

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  DatabaseReference? databaseReference; // Declare as nullable

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _idController,
            decoration: InputDecoration(labelText: 'Student ID'),
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Student Name'),
          ),
          TextField(
            controller: _majorController,
            decoration: InputDecoration(labelText: 'Student Major'),
          ),
          TextField(
            controller: _facultyController,
            decoration: InputDecoration(labelText: 'Student Faculty'),
          ),
          TextField(
            controller: _gpaController,
            decoration: InputDecoration(labelText: 'Student GPA'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = _idController.text;
              final name = _nameController.text;
              final major = _majorController.text;
              final faculty = _facultyController.text;
              final gpa = _gpaController.text;

              if (Firebase.apps.isNotEmpty) {
                databaseReference = FirebaseDatabase.instance.reference();
                databaseReference!.child(id).set({
                  'studentName': name,
                  'studentMajor': major,
                  'studentFaculty': faculty,
                  'studentGPA': gpa,
                });
              } else {
                print('Firebase has not been initialized yet.');
              }
            },
            child: Text('บันทึก'), // Save
          ),
        ],
      ),
    );
  }
}
