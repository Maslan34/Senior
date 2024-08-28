import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/pages/additional/PDFViewerPage.dart';
import 'package:senior_project/pages/additional/VideoPlayerScreen.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:convert';

import 'package:senior_project/repository/user_repository.dart';

import '../model/Senior.dart';
import '../tools/file_api.dart';

class analyseSenior extends ConsumerStatefulWidget {
  final String title;

  analyseSenior({Key? key, required this.title}) : super(key: key);

  @override
  ConsumerState<analyseSenior> createState() => _AnalyseSeniorState();
}

class _AnalyseSeniorState extends ConsumerState<analyseSenior> {
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
  PageController pageController = PageController();
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<List<Senior>> fetchSeniors() async {
      try {
        final response = await http.get(Uri.parse('http://' +
            dotenv.env['LOCAL_IP']! +
            ':' +
            dotenv.env['LOCAL_PORT']! +
            '/app/fetchSeniors/${ref.watch(userProvider).user!.userUniqueID}'));

        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body)['seniors'];
          print(jsonResponse);
          return jsonResponse.map((senior) => Senior.fromJson(senior)).toList();
        } else {
          print('Server Error: ${response.body}');
          throw Exception('Failed to load seniors');
        }
      } catch (e) {
        print('Error: $e');
        throw Exception('Failed to load seniors');
      }
    }

    return FutureBuilder<List<Senior>>(
      future: fetchSeniors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('An error occurred'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Senior senior = snapshot.data![index];
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

                                /// Seçilen expandidin idsini burda alınıyor.
                                contactStudentId= snapshot.data![index].contactStudentId;
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
                                    Text("${index + 1}.${senior.seniorName}"),
                                    Text(
                                        'Members: ${senior.members.join(", ")} '),
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
                                        title: Text("${senior.seniorName}"),
                                        subtitle: Text("${senior.members}"),
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
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      analyseSenior(
                                                        title: 'Seniors',
                                                      )));
                                        }),
                                    Text('Department: ${senior.department} '),
                                    Text('Master: ${senior.master} '),
                                    Text(
                                        'Members: ${senior.members.join(", ")} '),
                                    Text('Department: ${senior.department}'),
                                    Text('Master: ${senior.master} '),
                                    Text('Created At: ${senior.createdAt} '),
                                    //Text('Enabled: ${senior.isMasterGraded} '),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.video_library,
                                            size: 32,
                                          ),
                                          onPressed: () async {
                                            final url = 'http://' +
                                                dotenv.env['LOCAL_IP']! +
                                                ':' +
                                                dotenv.env['LOCAL_PORT']! +
                                                '/' +
                                                senior.seniorVideo;
                                            Uri uri = Uri.parse(url);
                                            String filePath = uri.path;
                                            String fileName = p.basename(
                                                filePath); // URL'den dosya adını elde et
                                            final file =
                                                await FileApi.downloadVideo(
                                                    url, fileName);
                                            openVideo(context, file);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.how_to_vote, size: 32),
                                          onPressed: !senior.isMasterGraded
                                              ? () async {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,  // Tam ekran modal için
                                              builder: (context) {
                                                return Container(
                                                  height: MediaQuery.of(context).size.height * 0.75,
                                                  padding: EdgeInsets.all(20),
                                                  child: PageView(
                                                    controller: pageController,
                                                    children: [

                                                      buildGradePage(context, senior),  // Oy verme sayfası
                                                      buildCommentPage(context, senior)  // Yorum yapma sayfası
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                              : null,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.picture_as_pdf_sharp,
                                            size: 32,
                                          ),
                                          onPressed: () async {
                                            final url = 'http://' +
                                                dotenv.env['LOCAL_IP']! +
                                                ':' +
                                                dotenv.env['LOCAL_PORT']! +
                                                '/' +
                                                senior.seniorPdf;
                                            final file =
                                                await FileApi.loadNetwork(url);
                                            openPDF(context, file);
                                          },
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
  Widget buildGradePage(BuildContext context, Senior senior) {
    return Column(
      children: [
        Text('Submit Grade', style: TextStyle(fontSize: 20)),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (int index) {
              grade = index == 0 ? 50 : 50 + index * 5;
            },
            children: List.generate(11, (index) => Text('${50 + index * 5}')),
          ),
        ),
        ElevatedButton(
          child: Text('Next'),
          onPressed: () {
            pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
          },
        ),
      ],
    );
  }

  Widget buildCommentPage(BuildContext context, Senior senior) {
    return Column(
      children: [
        Text('Add Comment', style: TextStyle(fontSize: 20)),
        TextField(
          controller: commentController,
          decoration: InputDecoration(
            labelText: "Comment",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        ElevatedButton(
          child: Text('Save Grade and Comment'),
          onPressed: () async {
            await voteSenior(senior);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Grade and comment saved successfully!')),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
  Future<void> voteSenior(Senior senior) async {

    try {
      final response = await http.post(
        Uri.parse(
            'http://${dotenv.env['LOCAL_IP']!}:${dotenv.env['LOCAL_PORT']!}/app/vote/${ref.watch(userProvider).user!.userUniqueID}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'grade': {'point': grade, 'senior_id': contactStudentId,"comment":commentController.text},
        }),
      );
      print('Response: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Error sending request: $e');
    }
  }
}

void openPDF(BuildContext context, File file) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)));

void openVideo(BuildContext context, File file) =>
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoFile: file)));
