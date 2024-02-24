import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'emotion_detector.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const EmotionDetector(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Emotion detector',
            style: GoogleFonts.labrada(
              color: Colors.white,
              fontSize: 35,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Powered by Rahma Ayman',
            style: GoogleFonts.labrada(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Loading....',
            style: GoogleFonts.labrada(
              color: Colors.white,
              fontSize: 30,
              letterSpacing: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Center(
            child: SpinKitChasingDots(
              color: Colors.white,
              duration: Duration(seconds: 3),
            ),
          ),
        ],
      ),
    );
  }
}
