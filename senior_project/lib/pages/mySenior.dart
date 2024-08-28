import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/pages/additional/app_drawer.dart';
import 'package:senior_project/pages/additional/seniorNotSubmitted.dart';
import '../tools/file_api.dart';
import 'package:senior_project/model/Thesis.dart' as thModel;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/Senior.dart';
import '../repository/user_repository.dart';
import 'additional/PDFViewerPage.dart';
import 'additional/VideoPlayerScreen.dart';
import 'package:path/path.dart' as p;

class mySenior extends ConsumerStatefulWidget {
  const mySenior({Key? key}) : super(key: key);

  @override
  _mySeniorState createState() => _mySeniorState();
}

class _mySeniorState extends ConsumerState<mySenior> {
  int _currentStep =0 ;
   int _mainStep = 0 ;
  double offset1 = -40;
  Color color = Colors.green;
  @override


  void initState() {
    super.initState();
    // FutureBuilder'dan gelen veriyi kullanarak gerekli atamaları yapın
    fetchSenior().then((senior) {
      if (senior.isMasterGraded) {
        setState(() {
          _currentStep = 1;
          _mainStep = 1;
        });
      }
      else{
        _currentStep = 0;
        _mainStep = 0;
      }
    });
  }
  int currentDetailPageIndex = 0;
  final pageDetailController = PageController(initialPage: 0);

  Future<void> _dialogBuilder(BuildContext context, allThesis, deletedItem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text("This thesis will be removed. Are you sure ?"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete'),
              onPressed: () {
                allThesis.removeWhere((thModel.thesisModel currentItem) =>
                deletedItem == currentItem);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("My Senior"),
      ),
      body: FutureBuilder<Senior>(
          future: fetchSenior(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return  seniorNotSubmitted();
            } else {
              Senior senior = snapshot.data!;
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/images/background.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.9),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: Theme(
                        data: ThemeData(
                          colorScheme: ColorScheme.light(
                            primary: color, // Aktif adımın rengi ve düğmeler
                            onPrimary: Colors.white,
                          ),
                        ),
                        child: Stepper(
                          steps: [
                            Step(
                              isActive: _currentStep == 0,
                              title: Text("Master Voting"),
                              content: Text(_currentStep == _mainStep
                                  ? "Your senior project has not been scored by your master. It is waiting to be scored by your master."
                                  : "You have passed this stage"),
                            ),
                            Step(
                              isActive: _currentStep == 1,
                              title: Text("Committee Voting"),
                              content: Text(_currentStep == _mainStep
                                  ? "Your senior project has been scored by your master. It is expected to be scored by all committee members."
                                  : "You are not at this stage right now"),
                            ),
                            Step(
                              isActive: _currentStep == 2,
                              title: Text("Finish"),
                              content: Text(_currentStep == _mainStep
                                  ? "The evaluation process of your senior is over"
                                  : "You are not at this stage right now"),
                            )
                          ],
                          onStepTapped: (int index) {
                            setState(() {
                              _currentStep = index;
                            });
                          },
                          currentStep: _currentStep,
                          controlsBuilder:
                              (BuildContext context, ControlsDetails details) {
                            return Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                  EdgeInsets.only(left: 8.0, top: 16),
                                  child: ElevatedButton(
                                    onPressed: details.onStepContinue,
                                    child: Text('Next'),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.only(left: 8.0, top: 16),
                                  child: ElevatedButton(
                                    onPressed: details.onStepCancel,
                                    child: Text('Back'),
                                  ),
                                ),
                              ],
                            );
                          },
                          onStepContinue: () {
                            if (_currentStep != 2) {
                              setState(() {
                                  _currentStep++;
                                  if (_currentStep <= _mainStep)
                                    color = Colors.green;
                                  else
                                    color = Colors.red;

                              });
                            }
                          },
                          onStepCancel: () {
                            setState(() {
                                _currentStep--;
                                if (_currentStep <= _mainStep)
                                  color = Colors.green;
                                else
                                  color = Colors.red;

                            }
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Divider(thickness: 5),
                            Stack(
                              children: [
                                Opacity(
                                  opacity: 0.1,
                                  child: Container(
                                    width: 350,
                                    height: 250,
                                  ),
                                ),
                                Positioned(
                                  top: 25,
                                  left: 50,
                                  width: 250,
                                  height: 200,
                                  child: ShaderMask(
                                    blendMode: BlendMode.srcATop,
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                        stops: [0.0, 0.0],
                                      ).createShader(bounds);
                                    },
                                    child: PhysicalModel(
                                      shadowColor: Colors.grey.shade800,
                                      elevation: 50,
                                      color: Colors.white30,
                                      borderRadius: BorderRadius.circular(45),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: PageView.builder(
                                          itemCount: 3,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            if (index == 0) {
                                              return Container(
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Text(
                                                          'Master:${senior.master}'),
                                                      Text(
                                                          'Members:${senior.members}'),
                                                      Text(
                                                          'Name:${senior.seniorName}'),
                                                      Text(
                                                          'Created At:${senior.createdAt}'),
                                                      Text(
                                                          senior.finalGrade != -1
                                                              ? 'Final Grade: ${senior.finalGrade} '
                                                              : "Not Graded Yet"
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else if (index == 1) {
                                              return Container(
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
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
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(Icons.picture_as_pdf,
                                                          size: 32,

                                                        ),
                                                        onPressed: () async {
                                                          final url = 'http://' + dotenv.env['LOCAL_IP']! + ':' + dotenv.env['LOCAL_PORT']! + '/' + senior.seniorPdf;
                                                          final file = await FileApi.loadNetwork(url);
                                                          openPDF(context, file);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 10),
                            Stack(
                              children: [
                                ShaderMask(
                                  blendMode: BlendMode.srcATop,
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      colors: [
                                        Colors.black38,
                                        Colors.transparent
                                      ],
                                      stops: [0.0, 0.5],
                                    ).createShader(bounds);
                                  },
                                  child: PhysicalModel(
                                    shadowColor: Colors.grey.shade800,
                                    elevation: 80,
                                    color: Colors.white38,
                                    borderRadius: BorderRadius.circular(45),
                                    child: Container(
                                      width: 375,
                                      height: 230,
                                      child: PageView.builder(
                                        scrollDirection: Axis.vertical,
                                        controller: pageDetailController,
                                        itemCount: 8,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == 0) {
                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text("Comments"),
                                                  ],
                                                ),
                                                for (var comment in senior.comment)
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 32.0),

                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [

                                                        Text('${comment['master']+": "+(comment['comment'] !="" ? comment['comment'] : "Master Not Committed Anything")}'),

                                                    ],
                                                  ),


                                                )
                                              ],
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 10),
                            Stack(
                              children: [
                                ShaderMask(
                                  blendMode: BlendMode.srcATop,
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      colors: [
                                        Colors.black38,
                                        Colors.transparent
                                      ],
                                      stops: [0.0, 0.5],
                                    ).createShader(bounds);
                                  },
                                  child: PhysicalModel(
                                    shadowColor: Colors.grey.shade800,
                                    elevation: 80,
                                    color: Colors.white38,
                                    borderRadius: BorderRadius.circular(45),
                                    child: Container(
                                      width: 375,
                                      height: 230,
                                      child: PageView.builder(
                                        scrollDirection: Axis.vertical,
                                        controller: pageDetailController,
                                        itemCount: 8,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == 0) {
                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text("Grades"),
                                                  ],
                                                ),
                                                for (var grade in senior.grade)
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 32.0),

                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [

                                                        Text('${grade['master']+": "+grade['point'].toString()}'),

                                                      ],
                                                    ),


                                                  )
                                              ],
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
      drawer: app_drawer(),
    );
  }

  Future<Senior> fetchSenior() async {
    try {
      final response = await http.get(Uri.parse('http://' +
          dotenv.env['LOCAL_IP']! +
          ':' +
          dotenv.env['LOCAL_PORT']! +
          '/app/fetchSenior/${ref.watch(userProvider).user!.userUniqueID}'));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body)['senior'];
        print(jsonResponse);
        return Senior.fromJson(jsonResponse);
      } else {
        print('Server Error: ${response.body}');
        throw Exception('Failed to load seniors');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load seniors');
    }
  }
}

void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file))
);

void openVideo(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => VideoPlayerScreen(videoFile: file))
);
