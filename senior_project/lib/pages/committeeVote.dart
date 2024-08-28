
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




class committeeVote extends StatelessWidget {
  final String title;

  committeeVote({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: FileListScreen());

  }
}

class FileListScreen extends ConsumerWidget {

int grade =0;

  @override
  Widget build(BuildContext context ,WidgetRef ref) {


    Future<List<Senior>> fetchSeniors() async {
      try {
        final response = await http.get(Uri.parse('http://' + dotenv.env['LOCAL_IP']! + ':' + dotenv.env['LOCAL_PORT']! + '/app/committee/${ref.watch(userProvider).user!.userUniqueID}'));

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

    return  FutureBuilder<List<Senior>>(
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
                return Column(
                  children: [
                    ListTile(
                      title: Text('${index + 1}.Senior Name:${senior.seniorName}'),
                      subtitle: Column(
                        children: [
                          Text('Department: ${senior.department } '),
                          Text('Master: ${senior.master} '),
                          Text('Members: ${senior.members.join(", ")} '),
                          Text('Department: ${senior.department}'),
                          Text('Master: ${senior.master} '),
                          Text('Created At: ${senior.createdAt} '),
                        ],
                      ),
                      onTap: () async {
                        final url = 'http://' + dotenv.env['LOCAL_IP']! + ':' + dotenv.env['LOCAL_PORT']! + '/' + senior.seniorPdf;
                        final file = await FileApi.loadNetwork(url);
                        openPDF(context, file);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.video_library,
                            size: 32,

                          ),
                          onPressed: () async {
                            final url = 'http://' + dotenv.env['LOCAL_IP']! + ':' + dotenv.env['LOCAL_PORT']! + '/' + senior.seniorVideo;
                            Uri uri = Uri.parse(url);
                            String filePath = uri.path;
                            String fileName = p.basename(filePath); // URL'den dosya adını elde et
                            final file = await FileApi.downloadVideo(url, fileName);
                            openVideo(context, file);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.how_to_vote,
                            size: 32,
                          ),
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 600,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 64),
                                        child: Text(
                                          'Submit Grade',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Expanded(
                                        child: CupertinoPicker(
                                          itemExtent: 40,
                                          onSelectedItemChanged: (int index) {
                                            grade=index+1;
                                          },
                                          children: List.generate(100, (index) => Text('${index + 1}')),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 64),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            print('http://${dotenv.env['LOCAL_IP']!}:${dotenv.env['LOCAL_PORT']!}/app/vote/${senior.contactStudentId}');
                                            await voteSenior(senior);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('User information updated successfully!'),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Text("Save"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        });
  }



Future<void> voteSenior(Senior senior) async {
  try {
    final response = await http.post(
      Uri.parse('http://${dotenv.env['LOCAL_IP']!}:${dotenv.env['LOCAL_PORT']!}/app/vote/${senior.contactStudentId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'grade': {
          'master': senior.master,
          'point': grade,
        },
      }),
    );
    print('Response: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (e) {
    print('Error sending request: $e');
  }
}



}




void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file))
);

void openVideo(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => VideoPlayerScreen(videoFile: file))
);


