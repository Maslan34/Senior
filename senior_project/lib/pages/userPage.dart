import 'package:flutter/material.dart';
import 'package:senior_project/pages/additional/app_drawer.dart';
import 'package:senior_project/model/User.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senior_project/repository/user_repository.dart';

class userPage extends ConsumerWidget {
  const userPage({super.key, required this.title,required this.user});

  final userModel user;
  final String title;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(child: Text("User")),
      drawer: app_drawer(),
    );
  }
}


