import 'dart:convert';
import 'dart:ffi';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:senior_project/repository/user_repository.dart';

import '../model/Student.dart';

class addSenior extends ConsumerStatefulWidget {
  final String title;

  addSenior({Key? key, required this.title}) : super(key: key);

  @override
  _AddSeniorState createState() => _AddSeniorState();
}

class _AddSeniorState extends ConsumerState<addSenior> {
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


  bool disableTeamMember = true;
  bool isChecked =false;



  String? _filePathVideo,_filePathPdf;
  final _fullNameController = TextEditingController();
  final _seniorNameController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _teamMemberController = TextEditingController();
  final _teamMemberStudentNumberController = TextEditingController();
  final _masterController = TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    isChecked = ref.watch(userProvider).getTeamMember() == "" ? false: true;
    _seniorNameController.text=ref.watch(userProvider).getSeniorName();
    _studentNumberController.text=ref.watch(userProvider).getStudentNumber();
    _masterController.text=ref.watch(userProvider).getMasterName();
  }
  @override
  Widget build(BuildContext context) {

    //print(ref.watch(userProvider).user.runtimeType);
    _fullNameController.text=ref.watch(userProvider).user!.givenName+ ' ' + ref.watch(userProvider).user!.familyName;


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _seniorNameController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Senior Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _masterController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Master',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _studentNumberController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Student Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _fullNameController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      pickVideoFile();
                    },
                    child: Text('Dosya Seç'),
                  ),
                  Text(_filePathVideo != null ? 'Dosya seçildi' : 'Dosya seçilmedi'),
                  ElevatedButton(
                    onPressed: () {
                      pickPdfFile();
                    },
                    child: Text('Dosya Seç'),

                  ),
                  Text(_filePathPdf != null ? 'Dosya seçildi' : 'Dosya seçilmedi'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  List<String> filePaths = [];
                  filePaths.add(_filePathVideo!);
                  filePaths.add(_filePathPdf!);
                  uploadFiles(ref.watch(userProvider).user!.userUniqueID);
                },
                child: Text('Save'),
              ),
            ],
          ),
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

  /*
  Future<void> saveStudent() async {

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
            'project_name':_projectNameController.text,
            'student_numbers': studentNumbers,
            'department':ref.watch(userProvider).user!.department,
            'full_names':fullNames,
          },
        }),
      );
      print('Response: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Error sending request: $e');
    }

/*
    var response = await http.get(Uri.parse('http://' +
        dotenv.env['LOCAL_IP']! +
        ':' +
        dotenv.env['LOCAL_PORT']! +
        '/app/students?department='));
        */



  }
*/
  Future<void> pickVideoFile() async {
    // Video ve PDF dosyaları için filtre uygulayarak dosya seçiciyi aç
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp4',
      ], // Burada video ve pdf dosya türlerini belirtiyoruz
    );

    if (result != null) {
      // Kullanıcı bir dosya seçti
      PlatformFile file = result.files.first;
      setState(() {
        _filePathVideo = file.path; // Seçilen dosyanın yolunu kaydet
      });
    } else {
      // Kullanıcı dosya seçme işlemini iptal etti
      print('Kullanıcı dosya seçiminden vazgeçti.');
    }
  }

  Future<void> pickPdfFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf'
      ],
    );

    if (result != null) {

      PlatformFile file = result.files.first;
      setState(() {
        _filePathPdf = file.path;
      });
    } else {
      // Kullanıcı dosya seçme işlemini iptal etti
      print('Kullanıcı dosya seçiminden vazgeçti.');
    }
  }


  Future<void> uploadFiles(String userId) async {
    var uri = Uri.parse('http://${dotenv.env['LOCAL_IP']}:${dotenv.env['LOCAL_PORT']}/app/senior');
    var request = http.MultipartRequest('POST', uri);
    print('ıd : ${ref.watch(userProvider).user!.userUniqueID}');
    // Kullanıcı ID'sini istek gövdesine ekleyin
    request.fields['userUniqueID'] = userId;
    request.fields['master'] = _masterController.text;
    request.fields['department'] = ref.watch(userProvider).user!.department;
    request.fields['projectName'] = _seniorNameController.text;
    request.fields['studentNumber'] = _studentNumberController.text;
    request.fields['teamMemberStudentNumber'] = _teamMemberStudentNumberController.text;
    request.fields['seniorName'] = _seniorNameController.text;


    if (_filePathVideo != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        _filePathVideo!,
      ));
    }
    if (_filePathPdf != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'pdf',
        _filePathPdf!,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ref.watch(userProvider).setSubmitted();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Senior saved successfully."), backgroundColor: Colors.green),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save senior."), backgroundColor: Colors.red),
      );
    }

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // This will pop the current screen off the navigation stack after 3 seconds
    });
  }
}



