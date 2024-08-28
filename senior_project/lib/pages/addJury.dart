import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:senior_project/repository/user_repository.dart';

class addJury extends ConsumerStatefulWidget {


  addJury({Key? key}) : super(key: key);

  @override
  _AddSeniorState createState() => _AddSeniorState();
}

class _AddSeniorState extends ConsumerState<addJury> {
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


  final _juryNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Jury"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              _buildTextField(
                  _juryNameController, "Jury Full Name", "Enter Jury Name"),
              SizedBox(height: 20),
              DropdownButton<String>(
                hint: Text('Select a Department'),
                value: selectedDepartment,
                onChanged: (newValue) {
                  setState(() {
                    selectedDepartment = newValue;
                  });
                },
                items: departments.map<DropdownMenuItem<String>>((String department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),




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


              ElevatedButton(
                onPressed: () {
                  saveJury();
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
  Future<void> saveJury() async {

    if (selectedDepartment == null  || _juryNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields."), backgroundColor: Colors.red),
      );
      return;
    }

    //print(_juryNameController.text);
    //print(selectedDepartment);

    try {
      final response = await http.post(
        Uri.parse('http://${dotenv.env['LOCAL_IP']!}:${dotenv.env['LOCAL_PORT']!}/app/saveJury'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'jury': {
            'juryName': _juryNameController.text,
            'department': selectedDepartment,
          },
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Jury saved successfully."), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save jury."), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
    }

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }
}
