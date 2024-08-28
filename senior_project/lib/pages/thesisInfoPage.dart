import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/pages/additional/app_drawer.dart';
import 'package:senior_project/repository/thesis_repository.dart';

import 'package:senior_project/model/Thesis.dart' as thModel;
import 'package:lottie/lottie.dart';

class thesisInfoPage extends ConsumerStatefulWidget {
  const thesisInfoPage({Key? key, required this.thesis}) : super(key: key);

  final thModel.thesisModel thesis;

  @override
  _thesisPageState createState() => _thesisPageState();
}

class _thesisPageState extends ConsumerState<thesisInfoPage> {
  late int _currentStep;
  late int _MainStep;
  late String title;
  late String content;
  late String status;

  double offset1 = -40;
  Color color = Colors.green;

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
  void initState() {
    status = widget.thesis.status;
    if (widget.thesis.status == "pending") {
      _currentStep = 0;
      _MainStep = 0;
    } else if (widget.thesis.status == "approval") {
      _currentStep = 1;
      _MainStep = 1;
    } else {
      _currentStep = 2;
      _MainStep = 2;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<thModel.thesisModel> allThesis = ref.watch(thesisProvider).thesis;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Thesis"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.9)

            // Arka plan resminizin yolu
            ),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: Theme(
                data: ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: color, // Aktif adımın rengi ve düğmeler
                    onPrimary:
                        Colors.white, // Aktif adımın üzerindeki metin rengi
                    // Diğer renkler...
                  ),
                ),
                child: Stepper(
                  steps: [
                    Step(
                      isActive: _currentStep == 0,
                      title: Text("Pending"),
                      content: Text(_currentStep == _MainStep
                          ? "Your thesis is currently in the 'Sending' stage. This status indicates that your thesis has been successfully submitted to the relevant academic department and the review process has begun."
                          : "You are not at this stage right now"),
                    ),
                    Step(
                        isActive: _currentStep == 1,
                        title: Text("Approval"),
                        content: Text(_currentStep == _MainStep
                            ? "Your thesis has reached the 'Approval' stage. This signifies that after thorough review and evaluation, your thesis has been found to comply with the academic standards and criteria set by your institution."
                            : "You are not at this stage right now")),
                    Step(
                        isActive: _currentStep == 2,
                        title: Text("Finish"),
                        content: Text(_currentStep == _MainStep
                            ? "The evaluation process of your thesis is over "
                            : "You are not at this stage right now"))
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
                          padding: EdgeInsets.only(left: 8.0,top:16),
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text('Next'), // İleri butonunun metni
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0,top:16),
                          child: ElevatedButton(
                            onPressed: details.onStepCancel,
                            child: Text('Back'), // Geri butonunun metni
                          ),
                        ),
                      ],
                    );
                  },
                  onStepContinue: () {
                    if (_currentStep != 2) {
                      setState(() {
                        if (_currentStep != 2) {
                          _currentStep++;
                          if (_currentStep != _MainStep)
                            color = Colors.red;
                          else
                            color = Colors.green;
                        }
                      });
                    }
                  },
                  onStepCancel: () {
                    setState(() {
                      if (_currentStep != 0) {
                        _currentStep--;
                        if (_currentStep != _MainStep)
                          color = Colors.red;
                        else
                          color = Colors.green;
                      }
                    });
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
                                colors: [Colors.black, Colors.transparent],
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
                                  child: Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
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
                                                        'Seen Able Editors: $index'),
                                                    ...widget
                                                        .thesis.seenAbleEditors
                                                        .map((editor) =>
                                                            Text(editor))
                                                        .toList(),
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
                                                    Text(
                                                        'Seen Able Refree: $index'),
                                                    ...widget
                                                        .thesis.seenAbleRefree
                                                        .map((refree) => Text(
                                                            refree.nameSurname))
                                                        .toList(),
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
                                                    Text(
                                                        'Refree Notes: $index'),
                                                    ...widget
                                                        .thesis.seenAbleRefree
                                                        .map((refree) => Text(
                                                            refree.nameSurname))
                                                        .toList(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 5),
                    Stack(children: [
                      ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [Colors.black38, Colors.transparent],
                              stops: [0.0, 0.5],
                            ).createShader(bounds);
                          },
                          child: PhysicalModel(
                              shadowColor: Colors.grey.shade800,
                              elevation: 80,
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(45),
                              child: Container(
                                  width: 300,
                                  height: 230,
                                  child: PageView.builder(
                                      scrollDirection: Axis.vertical,
                                      controller: pageDetailController,
                                      itemCount: 8,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index == 0) {
                                          return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Title:" +
                                                        widget.thesis.title),
                                                    Text("Subject:" +
                                                        widget.thesis.subject),
                                                  ],
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Author:" +
                                                          widget.thesis
                                                              .authorName),
                                                      Text("Status:" +
                                                          widget.thesis.status),
                                                    ]),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Content:" +
                                                        widget.thesis
                                                                .makaleIcerigi[
                                                            'articletype']),
                                                    Text(widget.thesis
                                                                .pdfThesis !=
                                                            null
                                                        ? "Pdf:Loaded"
                                                        : "Pdf:Not Loaded"),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "Number of Revision: " +
                                                            widget.thesis
                                                                .revisionCount
                                                                .toString()),
                                                    Text("Active: " +
                                                        (widget.thesis.active ==
                                                                "1"
                                                            ? "Yes"
                                                            : "No")),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Created at:" +
                                                        widget.thesis.createdAt
                                                            .toString()
                                                            .substring(
                                                                0,
                                                                widget.thesis
                                                                        .createdAt
                                                                        .toString()
                                                                        .length -
                                                                    1)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Updated at:" +
                                                        widget.thesis.updatedAt
                                                            .toString()
                                                            .substring(
                                                                0,
                                                                widget.thesis
                                                                        .updatedAt
                                                                        .toString()
                                                                        .length -
                                                                    1)),
                                                  ],
                                                )
                                              ]

                                              // drawer: AppDrawer(user: "Muharrem"));  // `AppDrawer` widget'ı burada tanımlı değil, bu yüzden yorum satırı haline getirildi.
                                              );
                                        }
                                      }))))
                    ]),
                    Divider(thickness: 10),
                    Stack(children: [
                      ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [Colors.black38, Colors.transparent],
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
                                          return Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Thesis"),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 32.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(widget
                                                          .thesis.makaleIcerigi[
                                                      'textAreaThesis']),
                                                ],
                                              ),
                                            )
                                          ]

                                              // drawer: AppDrawer(user: "Muharrem"));  // `AppDrawer` widget'ı burada tanımlı değil, bu yüzden yorum satırı haline getirildi.
                                              );
                                        }
                                      }))))
                    ])
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      drawer: app_drawer(),
    );
  }
}

LottieBuilder makeAnimation(double degree) {
  if (degree < 0)
    return Lottie.asset("lib/assets/snowy.json");
  else if (degree > 0 && degree < 10)
    return Lottie.asset("lib/assets/rainy.json");
  else if (degree > 10 && degree < 20)
    return Lottie.asset("lib/assets/cloudly.json");
  else
    return Lottie.asset("lib/assets/sunny.json");
}
