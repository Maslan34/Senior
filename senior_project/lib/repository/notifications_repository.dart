import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/model/Notifications.dart';

import '../service/data_service.dart';

class notifications_repository extends ChangeNotifier{


  late List<Notifications>notifications= [];





}


final notificationProvider = ChangeNotifierProvider((ref) => notifications_repository());

