import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';



import 'package:senior_project/model/Thesis.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project/model/User.dart';




class dataService{

  Future<void> getThesis(userModel user) async {

    Future<List<thesisModel>> fetchThesis(String userUniqueID) async {
      final response = await http.get(Uri.parse('http://10.0.0.129:8080/app/'+user.userUniqueID));
      final List<dynamic> responseJson = json.decode(response.body)['makale'];
      return responseJson.map((data) => thesisModel.fromJson(data)).toList();
    }

  }

  Future<void> updateUser(userModel user) async {


    var url = Uri.parse('http://10.0.0.129:8080/app/updateUser');
  //print(user.affiliation);
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()), // User nesnesini JSON'a dönüştür
    );

    if (response.statusCode == 200) {
      print("User updated successfully.");
    } else {
      throw Exception('Failed to update user.');
    }
    }




  Future<void> deleteUser(userModel user) async {


    var url = Uri.parse('http://10.0.0.129:8080/app/deleteUser');

    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()), // User nesnesini JSON'a dönüştür
    );

    if (response.statusCode == 200) {
      print("User deleted successfully.");
    } else {
      throw Exception('Failed to delete user.');
    }
  }


  Future<void> makeRead( userModel user) async {


    var url = Uri.parse('http://10.0.0.129:8080/app/makeRead');

    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      print("makeRead  successfully.");
    } else {
      throw Exception('Failed makeRead function.');
    }
  }




  }





final dataServiceProvider = Provider((ref) => dataService());