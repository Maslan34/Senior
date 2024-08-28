import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/pages/additional/seniorNotSubmitted.dart';
import 'package:senior_project/pages/loginPage.dart';
import 'package:senior_project/pages/createSenior.dart';
import 'package:senior_project/pages/myStudents.dart';
import 'package:senior_project/pages/notficationsPage.dart';
import 'package:senior_project/pages/thesisPage.dart';
import 'package:senior_project/pages/settingsPage.dart';
import 'package:senior_project/pages/additional/seniorSubmitted.dart';

/// MODELS

/// MODELS

import 'package:http/http.dart' as http;
import 'package:senior_project/repository/user_repository.dart';
import 'package:senior_project/repository/thesis_repository.dart';

import '../addJury.dart';
import '../addSenior.dart';
import '../analyse.dart';
import '../committeeVote.dart';
import '../mySenior.dart';

class app_drawer extends ConsumerWidget {
  const app_drawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            // Diğer öğeler ve çıkış butonu arasındaki boşluk için
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        'lib/assets/images/kbu.png',
                      ),
                      maxRadius: 35,
                      minRadius: 10,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Text("Welcome Back " +
                            ref.watch(userProvider).user!.givenName),
                        Text("Total:100 Accepted:50 Declined:50 "),
                      ],
                    ))
                  ]),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Flow'),
                  leading: Icon(Icons.home),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.notifications_on_sharp),
                  title: Text('Notifications'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => notificationsPage(
                                title: "Notifications"))); // Drawer'ı kapat
                  },
                ),
                if (ref.watch(userProvider).user!.role == 2)
                ListTile(
                  title: Text('Add Senior'),
                  leading: Icon(Icons.add),
                  onTap: () {
                    Navigator.pop(context); // Drawer'ı kapatır


                    if (ref.watch(userProvider).isSubmitted()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => seniorSubmitted()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => addSenior(title: "Add Senior")),
                      );
                    }
                  },
                ),
                if (ref.watch(userProvider).user!.role == 3)
                  ListTile(
                    title: Text('Create Senior'),
                    leading: Icon(Icons.add),
                    onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    createSenior(title: "Create Senior")));
                    },
                  ),
                if (ref.watch(userProvider).user!.role == 3)
                  ListTile(
                    title: Text('My Students '),
                    leading: Icon(Icons.people),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  myStudents(title: "My Students")));
                    },
                  ),
                if (ref.watch(userProvider).user!.role == 2)
                  ListTile(
                    title: Text('My Senior'),
                    leading: Icon(Icons.search_sharp),
                    onTap: () {
                      Navigator.pop(context); // Drawer'ı kapatır

                      if (true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => mySenior()),
                        );
                      } else {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => seniorNotSubmitted()),
                        );
                      }
                    },
                  ),

                if (ref.watch(userProvider).user!.role == 3)
                  ListTile(
                    title: Text('Analyse Senior'),
                    leading: Icon(Icons.search),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  analyseSenior(title: "Analyse Senior")));
                    },
                  ),
                if (ref.watch(userProvider).user!.role == 3)
                  ListTile(
                    title: Text('Committee Vote'),
                    leading: Icon(
                      CupertinoIcons.person_3_fill,
                      size: 24.0,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              committeeVote(title: "Committee Vote")));
                    },
                  ),
                if (ref.watch(userProvider).user!.role == -1)
                  ListTile(
                    title: Text('Add Jury '),
                    leading: Icon(Icons.people),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  addJury()));
                    },
                  ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                settingPage(title: "Settings")));
                  },
                ),
                // Burada diğer öğeler olabilir
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              ref.watch(userProvider).logout();

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => loginPage(title: "Login")));
              // Drawer'ı kapat
            },
          ),
        ],
      ),
    );
  }
}
