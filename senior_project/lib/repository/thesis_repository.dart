import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/model/Thesis.dart';

class thesis_repository extends ChangeNotifier{


  late List<thesisModel>thesis= [];


}


final thesisProvider = ChangeNotifierProvider((ref) => thesis_repository());

