import 'package:flutter/cupertino.dart';
import 'package:senior_project/model/User.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/service/data_service.dart';

import '../model/Master.dart';
import '../model/Student.dart';



class user_repository extends ChangeNotifier{


  late  userModel? user;
  final dataService dtService;
  user_repository(this.dtService);


  void setUser(dynamic newUser) {
    if (newUser is Student) {
      this.user = newUser as Student;
    } else if (newUser is Master) {
      this.user = newUser as Master;
    } else {
      this.user = null; // newUser uygun bir tür değilse, user'ı null yapabilirsiniz.
    }
    notifyListeners();
  }
  /*
  void setUser(dynamic newUser) {
    if (user is Student) {
      this.user = user as Student;
    } else if (user is Master) {
      this.user = user as Master;
    }
    notifyListeners();
  }
*/
  bool isSubmitted() {
    if (user is Student) {
      return (user as Student).isSubmitted; // Assuming 'isSubmitted' is a boolean
    }
    return false; // Return false if 'user' is not a 'Student'
  }

  String getSeniorName() {
    if (user is Student) {
      return (user as Student).seniorName;
    }
    return "";
  }

  String getTeamMember() {

    if (user is Student) {
      // Cast user to Student safely
      Student student = user as Student;
      // Check if the teamMember field is null
      if (student.teamMember == null) {
        return "";
      } else {
        // Return the seniorName if teamMember is not null
        // Assuming you wanted to return seniorName, as your original code suggests
        return student.seniorName;
      }
    } else {
      // Return an empty string if user is not a Student
      return "";
    }
  }

  String getStudentNumber() {

    if (user is Student) {
      // Cast user to Student safely
      Student student = user as Student;
      // Check if the teamMember field is null
      if (student.studentNumber == null) {
        return "";
      } else {
        // Return the seniorName if teamMember is not null
        // Assuming you wanted to return seniorName, as your original code suggests
        return student.studentNumber;
      }
    } else {
      // Return an empty string if user is not a Student
      return "";
    }
  }
  String getMasterName() {

    if (user is Student) {
      // Cast user to Student safely
      Student student = user as Student;
      // Check if the teamMember field is null
      if (student.studentNumber == null) {
        return "";
      } else {
        // Return the seniorName if teamMember is not null
        // Assuming you wanted to return seniorName, as your original code suggests
        return student.master;
      }
    } else {
      // Return an empty string if user is not a Student
      return "";
    }
  }

  void setSubmitted() {
    if (user is Student) {
      // Cast user to Student safely
      Student student = user as Student;
      // Check if the teamMember field is null
      if (student.studentNumber == null) {
        return;
      } else {
         student.isSubmitted=true;

      }
    }

  }

  Future<void> updateUser(userModel user) async {
    await dtService.updateUser(user);
  }

  Future<void> deleteUser(userModel user) async {
    await dtService.deleteUser(user);
  }

  Future<void> makeRead(userModel user) async {

    await dtService.makeRead(user);
  }

  void logout(){
    this.user = null;
  }


}


final userProvider = ChangeNotifierProvider((ref) => user_repository(ref.watch(dataServiceProvider)));

