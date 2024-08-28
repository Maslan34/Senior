import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/model/Thesis.dart';
import 'package:senior_project/pages/additional/app_drawer.dart';
import 'package:senior_project/repository/notifications_repository.dart';
import 'package:senior_project/repository/thesis_repository.dart';
import 'package:senior_project/repository/user_repository.dart';
import 'package:senior_project/service/data_service.dart';
import 'package:senior_project/model/User.dart';

import 'loginPage.dart';

class settingPage extends ConsumerStatefulWidget {
  final String title;
  settingPage({Key? key, required this.title}) : super(key: key);

  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends ConsumerState<settingPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _affiliationController = TextEditingController();
  final _emailController = TextEditingController();

  late bool getNotifications;
  late bool beJury;

  late String _selectedValue;

  // Açılır listedeki seçenekler
  final List<String> _options = ['User', 'Editor', 'Jury'];

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final userModel user = ref.read(userProvider).user!;

      // Kullanıcı bilgilerini TextField kontrolcülerine atayın
      _usernameController.text = user.username ?? '';
      _passwordController.text =
          ''; // Güvenlik nedeniyle şifreler genellikle gösterilmez.
      _affiliationController.text = user.affiliation ?? '';
      _emailController.text = user.email ?? '';
      if (user.role == 1) {
        _selectedValue = _options[0];
      } else if (user.role == 2) {
        _selectedValue = _options[1];
      } else
        _selectedValue = _options[2];
/*
      getNotifications = user.getNotifications;
      beJury = user.beJury;
*/
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/settings.jpeg'),
                fit: BoxFit.fill,
                opacity: 0.9)

          // Arka plan resminizin yolu
        ),

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'lib/assets/images/kbu-transparent.png',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Notifications:"),
                  Switch(
                    onChanged: (value) {
                      setState(() {
                        getNotifications = !getNotifications;
                      });
                    },
                    value: getNotifications,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                  Text("Be Jury:"),
                  Switch(
                    onChanged: (value) {
                      setState(() {
                        beJury = !beJury;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Close"),
                              ),
                            ],
                            title: Text("Warning"),
                            content: Text("This Process May Take Time."),
                          ),
                        );
                      });
                    },
                    value: beJury,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text("Username"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 275,
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Bir Şeyler Yazın',
                            prefix: Container(
                              child: Text(
                                  ""), // Kutunun başına özel bir widget ekler
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text("Password"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 275,
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Bir şeyler yazın',
                            prefix: Container(
                              child: Text(""),
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text("Affiliation"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 275,
                        child: TextField(
                          controller: _affiliationController,
                          decoration: InputDecoration(
                            labelText: 'Bir şeyler yazın',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text("Email"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35),
                      child: Container(
                        width: 275,
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Bir şeyler yazın',
                            prefix: Container(
                              child: Text(
                                  ""), // Kutunun başına özel bir widget ekler
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text("Role"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: Container(
                        width: 275,
                        child: DropdownButton<String>(
                          // Seçilen değeri gösterir
                          value: _selectedValue,
                          // Seçeneklerin listesi
                          items: _options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          // Bir seçenek seçildiğinde çağrılacak fonksiyon
                          onChanged: (newValue) {
                            setState(() {
                              _selectedValue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(width: 20),
            ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 400,
                          child: Center(
                            child: ElevatedButton(
                                child: Text("Are You Sure?"),
                                onPressed: () async {
                                  if (validateInput()) {
                                    userModel updatedUser = ref.watch(userProvider).user!;

                                    updatedUser.username = _usernameController.text;
                                    updatedUser.affiliation = _affiliationController.text;
                                     updatedUser.email = _emailController.text;
                                     updatedUser.getNotifications=getNotifications;
                                      updatedUser.getNotifications;
                                    if (_selectedValue == _options[0]) {
                                      updatedUser.role=1;
                                    } else if ( _selectedValue == _options[1]) {
                                      updatedUser.role=2;
                                    } else
                                      updatedUser.role=3;

                                    await ref.read(userProvider).updateUser(updatedUser);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'User information updated successfully!')));
                                  }

                                  Navigator.pop(context);
                                }),
                          ),
                        );
                      });
                },
                child: Text("Save")),
            Padding(
                padding: const EdgeInsets.only(top: 40),
                child: InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 400,
                            child: Center(
                                child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("This action cannot be undone."),
                                  Text("Are you Sure?"),
                                  ElevatedButton(
                                    onPressed: () async {

                                      // Obje Siliniyor
                                      ref.watch(userProvider).deleteUser(ref.watch(userProvider).user!);
                                      // Obje Siliniyor


                                      // Provider objeleri siliniyor
                                      ref.watch(userProvider).dispose();
                                      ref.watch(thesisProvider).dispose();
                                      ref.watch(notificationProvider).dispose();
                                      // Provider objeleri siliniyor

                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => loginPage(title: "Login")),
                                            (Route<dynamic> route) => false,
                                      );
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            )),
                          );
                        });
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.warning),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Container(
                            child: Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 24.0, // Metnin boyutunu belirleyin
                            color: Colors.red, // Metnin rengini belirleyin
                          ),
                        )),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
      drawer: app_drawer(),
    );
  }

  bool validateInput() {
    String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$';
    RegExp regExp = RegExp(emailPattern);

    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username cannot be empty')),
      );
      return false;
    }

    if (_emailController.text.isEmpty ||
        !regExp.hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
      return false;
    }

    if (_affiliationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Affiliation cannot be empty')),
      );
      return false;
    }

    return true;
  }
}
