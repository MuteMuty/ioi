import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pitch_detector_service.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PitchDetectorService _pitchService = PitchDetectorService();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      _startListening();
    }
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    _pitchService.startListening(
      (frequency) {},
      () {
        Navigator.pushReplacementNamed(context, '/game');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Pitch Control Game!',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'To play the game, make any sound.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40),
              if (!_isListening)
                const Text(
                  'Listening for your command...',
                  style: TextStyle(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
