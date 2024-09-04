import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/utils/animation_constant.dart';
import 'package:note_app/view/notes_screen/notes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5)).then(
      (value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NotesScreen(),
            ));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Lottie.asset(AnimationConstant.SPLASH_NOTE)),
    );
  }
}
