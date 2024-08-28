import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:senior_project/repository/user_repository.dart';

class createSenior extends ConsumerStatefulWidget {
  final String title;

  createSenior({Key? key, required this.title}) : super(key: key);

  @override
  _AddSeniorState createState() => _AddSeniorState();
}

class _AddSeniorState extends ConsumerState<createSenior> {
  List<String> departments = [
    "Computer Engineering",
    "Biomedical Engineering",
    "Environmental Engineering",
    "Electrical and Electronics Engineering",
    "Industrial Engineering",
    "Civil Engineering",
    "Transportation Engineering",
    "Mechanical Engineering",
    "Automotive Engineering",
    "Railway Systems Engineering",
    "Mechatronics Engineering",
    "Metallurgical and Materials Engineering",
    "Medical Engineering",
    "Software Engineering"
  ];

  String? selectedDepartment;
  String? selectedStudent;
  int? selectedStudentIndex;

  List<Map<String, String>> studentsInfo = [];

  bool isChecked = false;
  bool disableTeamMember = true;
  bool isPdfUploaded =false;
  bool isVideoUploaded =false;


  final _fullNameController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _teamMemberController = TextEditingController();
  final _teamMemberStudentNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              _buildTextField(
                  _projectNameController, "Project Name", "Enter Project Name"),
              SizedBox(height: 20),
              _buildTextField(_studentNumberController, "Student Number",
                  "Enter Student Number"),
              SizedBox(height: 20),
              _buildTextField(_fullNameController, "Full Name",
                  "Enter Student Number"),
              SizedBox(height: 20),

              ListTile(
                leading: Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                title: Text('Team Project?'),
              ),


              Visibility(
                visible: isChecked,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: _teamMemberStudentNumberController,
                        decoration: InputDecoration(
                          labelText: 'Team Member Number ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*
              Visibility(
                visible: isChecked,
                child: DropdownButton<String>(
                  hint: Text('Select a Department'),
                  value: selectedDepartment,
                  onChanged: (newValue) {
                    setState(() {
                      selectedDepartment = newValue;
                      fetchStudents(selectedDepartment!);
                    });
                  },
                  items: departments
                      .map<DropdownMenuItem<String>>((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                ),
              ),
              */
              /*
              Visibility(
                visible: selectedDepartment != null && isChecked,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: DropdownButton<String>(
                    hint: Text('Select a Master'),
                    value: selectedStudent,
                    onChanged: (newValue) {
                      setState(() {
                        selectedStudent = newValue;
                        selectedStudentIndex = studentsInfo.indexWhere(
                            (studentInfo) => studentInfo['fullName'] == newValue);
                        Map<String, String> student  = studentsInfo[selectedStudentIndex!];
                        _teamMemberController.text = student['fullName']!;
                        _teamMemberStudentNumberController.text = "111111";
                        disableTeamMember = false;

                      });
                    },
                    items: studentsInfo.map<DropdownMenuItem<String>>(
                        (Map<String, String> studentInfo) {
                      return DropdownMenuItem<String>(
                        value: studentInfo['fullName'],
                        child: Text(studentInfo['fullName']!),
                      );
                    }).toList(),
                  ),
                ),
              ),
              */
              Visibility(
                visible: isChecked,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: _teamMemberController,
                        enabled: disableTeamMember,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  saveStudent();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  /*
  Future<void> fetchStudents(String department) async {
    var response = await http.get(Uri.parse('http://' +
        dotenv.env['LOCAL_IP']! +
        ':' +
        dotenv.env['LOCAL_PORT']! +
        '/app/students?department=$department'));

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> jsonResponse = json.decode(response.body)['students'];

        studentsInfo = jsonResponse.map<Map<String, String>>((student) {
          return {
            'fullName': '${student['givenName']} ${student['familyName']}',
            'userUniqueID': student['userUniqueID'],
          };
        }).toList();
        selectedStudent = null;
        selectedStudentIndex = null;
      });
    } else {
      // Hata yönetimi
      print("Failed to load masters");
    }
  }
*/
  Future<void> saveStudent() async {

     String  master =ref.watch(userProvider).user!.givenName+' '+ref.watch(userProvider).user!.familyName;
     List<String> studentNumbers=[];
     List<String> fullNames=[];
     studentNumbers.add(_studentNumberController.text);
     fullNames.add(_fullNameController.text);
      if(isChecked && _teamMemberStudentNumberController != null && _teamMemberController != null)
        {
          studentNumbers.add(_teamMemberStudentNumberController.text);
          fullNames.add(_teamMemberController.text);
        }

    try {
      final response = await http.post(
        Uri.parse(
            'http://${dotenv.env['LOCAL_IP']!}:${dotenv.env['LOCAL_PORT']!}/app/saveStudent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'senior': {
            'seniorName':_projectNameController.text,
            'studentNumbers': studentNumbers,
            'department':ref.watch(userProvider).user!.department,
            'fullNames':fullNames,
            'master':master,
            'masterUniqueID':ref.watch(userProvider).user!.userUniqueID
          },
        }),
      );
      /*
      print('Response: ${response.statusCode}');
      print('Response body: ${response.body}');
      */

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Student saved successfully."), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save student."), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
    }

     Future.delayed(Duration(seconds: 3), () {
       Navigator.of(context).pop(); // This will pop the current screen off the navigation stack after 3 seconds
     });

/*
    var response = await http.get(Uri.parse('http://' +
        dotenv.env['LOCAL_IP']! +
        ':' +
        dotenv.env['LOCAL_PORT']! +
        '/app/students?department='));
        */



  }
}
