import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senior_project/model/Student.dart';
import 'dart:ui';
import 'package:senior_project/pages/userPage.dart';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

///PROVIDERS
import 'package:senior_project/repository/thesis_repository.dart';
import 'package:senior_project/repository/user_repository.dart';
import 'package:senior_project/repository/notifications_repository.dart';
///PROVIDERS
///
///MODELS
import 'package:senior_project/model/User.dart';
import 'package:senior_project/model/Thesis.dart' as thModel ;
import 'package:senior_project/model/Notifications.dart'  ;

import '../model/Master.dart';
/// MODELS
class loginPage extends ConsumerStatefulWidget{
  const loginPage({super.key, required this.title});

  final String title;

  @override
  _loginPageState createState() => _loginPageState();

}

class _loginPageState extends ConsumerState<loginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPassVisible = false;

  @override
  void dispose() {
    // Controller dispose edilerek kaynakların serbest bırakılması sağlanır
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 250,
                width: 300,
                child: Image.asset(
                  'lib/assets/images/kbu.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
            Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 96.0),
                    child: const Text(
                      'Karabuk University Senior',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Metni kalın yapar
                        fontStyle: FontStyle.italic, // Metni italik yapar
                        fontSize: 20, // Metin boyutunu ayarlar
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter your username',
                          ),
                        ),
                        TextField(
                            controller: _passwordController,
                            obscureText: !_isPassVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPassVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPassVisible = !_isPassVisible;
                                    });
                                  }),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 64),
                          child: ElevatedButton(
                            onPressed: () {
                              _login();

                            },
                            child: Text('Login'),
                          ),
                        )
                      ],
                    ),
                  )
                ]))
          ],
        ));
  }



  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('http://'+dotenv.env['LOCAL_IP']!+':'+dotenv.env['LOCAL_PORT']!+'/app/loginApp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      if (responseJson['success']) {
        print(responseJson);

        userModel user= userModel.fromJson(responseJson['user']);
        //print('Giriş başarılı.');

        if (user.role == 2) {
          if (user is Student) {
            Student student = Student.fromJson(responseJson['user']);
            ref.watch(userProvider).setUser(student);
          } else {
            // 'user' nesnesi aslında bir Student değil
            print("Error: The user is not a Student.");
          }
        }
        if (user.role == 3) {
          if (user is Student) {
            Master master = Master.fromJson(responseJson['user']);
            ref.watch(userProvider).setUser(master);
          } else {
            // 'user' nesnesi aslında bir Student değil
            print("Error: The user is not a Student.");
          }
        }


        ref.watch(userProvider).user=user;


        final responseFetchData = await http.get(Uri.parse('http://'+dotenv.env['LOCAL_IP']!+':'+dotenv.env['LOCAL_PORT']!+'/app/user/'+user.userUniqueID)); // Buradaki URL, yerel web servisinizin adresi ve isteğinizi yapılan API rotası olmalıdır.

        final List<dynamic> responseFetchJson = json.decode(responseFetchData.body)['articles'];

        List<thModel.thesisModel> allThesis = responseFetchJson.map((data) => thModel.thesisModel.fromJson(data)).toList();

        ref.watch(thesisProvider).thesis=allThesis;

        print(responseJson);
        final List<dynamic> responseFetchJsonNatification = responseJson['user']['notifications'];

        List<Notifications> allNatifications = responseFetchJsonNatification.map((data) => Notifications.fromJson(data)).toList();

        ref.watch(notificationProvider).notifications=allNatifications;


        if (response.statusCode == 200) {
          // Başarılı bir şekilde yanıt alındı.
          print('Response body: ${response.body}');
        } else {
          // Yanıt alınamadı.
          print('Failed to load data. Status code: ${response.statusCode}');
        }
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    userPage(user: user, title: "Flow")));
      } else {
        final snackBar = SnackBar(
          content: Text('Incorrect username or password !'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              _usernameController.text = "";
              _passwordController.text = "";
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      // Sunucu hatası veya başka bir hata
      print('Beklenmeyen bir hata oluştu.');
    }
  }


}

