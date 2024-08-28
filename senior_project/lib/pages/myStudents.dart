import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_project/repository/user_repository.dart';
import '../model/Senior.dart';
import '../model/Student.dart';


class myStudents extends ConsumerStatefulWidget {
  final String title;

  myStudents({Key? key, required this.title}) : super(key: key);

  @override
  ConsumerState<myStudents> createState() => _AnalyseSeniorState();
}

class _AnalyseSeniorState extends ConsumerState<myStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FileListScreen(),
    );
  }
}

class FileListScreen extends ConsumerStatefulWidget {
  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends ConsumerState<FileListScreen> {
  int grade = 0;
  String contactStudentId = "";
  Map<int, bool> _expandedStateMap = {};

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> fetchStudents() async {
      try {
        final response = await http.get(Uri.parse('http://' +
            dotenv.env['LOCAL_IP']! +
            ':' +
            dotenv.env['LOCAL_PORT']! +
            '/app/fetchStudents/${ref.watch(userProvider).user!.userUniqueID}'));

        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body)['students'];
          return  jsonResponse;
        } else {
          print('Server Error: ${response.body}');
          throw Exception('Failed to load seniors');
        }
      } catch (e) {
        print('Error: $e');
        throw Exception('Failed to load seniors');
      }
    }

    return FutureBuilder<List<dynamic>>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('An error occurred'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              print(snapshot.data);
              var student = snapshot.data![index];
              _expandedStateMap.putIfAbsent(index, () => false);
              return Padding(
                padding: const EdgeInsets.only(top: 36.0),
                child: ExpansionPanelList(
                    expansionCallback: (int panelIndex, bool isExpanded) {
                      setState(() {
                        _expandedStateMap[index] = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _expandedStateMap[index] =
                                !(_expandedStateMap[index] ?? false);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'lib/assets/images/thesisBackground.jpg'),
                                      fit: BoxFit.cover,
                                      opacity: 0.9)

                                // Arka plan resminizin yolu
                              ),
                              child: SizedBox(
                                height: 75,
                                child: Column(
                                  children: [
                                    Text("${index + 1}.${student['seniorFullName']}"),
                                    Text(
                                        ': ${student['teamMember'] ?? "Personal Project"}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        body: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'lib/assets/images/thesis.jpg'),
                                      fit: BoxFit.cover,
                                      opacity: 0.9)

                                // Arka plan resminizin yolu
                              ),
                              child: SizedBox(
                                height: 500,
                                child: Column(
                                  children: [
                                    ListTile(
                                        title: Text("${student['seniorFullName']}"),
                                        subtitle: Text("Project Submitted: ${student['isSubmitted'] == false ? "No" : "Yes"}"),
                                        trailing: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: InkWell(
                                                onTap: () {},
                                                child: const Icon(Icons.delete),
                                              )),
                                        ),
                                        onTap: () {

                                        }),
                                    Text("Senior Name: ${student['seniorName']}"),

                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(

                                          icon: Icon(

                                            Icons.video_library,
                                            size: 32,
                                          ),
                                          onPressed: student['isSubmitted'] == true ?  () async {
                                          } :null ,
                                        ),
                                        IconButton(
                                          icon: Icon(

                                            Icons.picture_as_pdf_sharp,
                                            size: 32,
                                          ),
                                          onPressed: student['isSubmitted'] == true ? () async {
                                            final url = 'http://' +
                                                dotenv.env['LOCAL_IP']! +
                                                ':' +
                                                dotenv.env['LOCAL_PORT']! +
                                                '/' ;

                                          } : null ,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        isExpanded: _expandedStateMap[index]!,
                      )
                    ].toList()),
              );
            },
          );
        }
      },
    );
  }

}

