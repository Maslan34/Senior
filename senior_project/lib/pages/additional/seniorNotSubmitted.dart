import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class seniorNotSubmitted extends StatelessWidget {
  const seniorNotSubmitted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Geri tuşu işlevi
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/assets/animation/notSubmit.json',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              "You have not submitted your senior!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}