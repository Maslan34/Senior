import 'package:flutter/material.dart';
import 'package:senior_project/pages/additional/seniorNotSubmitted.dart';
import 'package:senior_project/pages/createSenior.dart';
import 'package:senior_project/pages/additional/seniorSubmitted.dart';
import 'package:senior_project/pages/analyse.dart';
import 'package:senior_project/pages/loginPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
    await dotenv.load(fileName: "lib/assets/.env");
    runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home:  mainPage(),
    );
  }
}

class mainPage extends StatefulWidget {
  const mainPage({super.key});


  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {

  @override
  Widget build(BuildContext context) {

    return loginPage(title: "Senior App");
  }
}
