// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pitch_detector_service.dart';
import 'ball_controller.dart';
import 'spike_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late BallController _ballController;
  final PitchDetectorService _pitchService = PitchDetectorService();

  @override
  void initState() {
    super.initState();
    _ballController = BallController(this);
    _requestMicrophonePermission();
  }

  @override
  void dispose() {
    _pitchService.stopListening();
    _ballController.dispose();
    super.dispose();
  }

  Future<void> _requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      _startPitchDetection();
    }
  }

  void _startPitchDetection() {
    _pitchService.startListening(
      (frequency) {
        _ballController.updatePosition(frequency);
      },
      () {
        _ballController.resume();
      },
    ).catchError((error) {
      // Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _ballController,
        builder: (context, child) {
          return Stack(
            children: [
              // Background
              Container(
                color: Colors.black,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 150,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              // Score
              Positioned(
                top: 20,
                right: 20,
                child: Text(
                  'Score: ${_ballController.score}',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              // Top Score
              Positioned(
                top: 20,
                left: 20,
                child: Text(
                  'Top: ${_ballController.topScore}',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              // Lives
              Positioned(
                bottom: 20,
                left: screenWidth / 2 - 60,
                child: Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.favorite,
                      color: index < _ballController.lives
                          ? Colors.red
                          : Colors.black,
                    );
                  }),
                ),
              ),
              // Obstacles
              ..._ballController.obstacles.map((obstacle) {
                return Positioned(
                  left: obstacle.xPosition * screenWidth,
                  top: obstacle.fromCeiling
                      ? 0
                      : (1.0 - obstacle.height) * (screenHeight - 150),
                  bottom: obstacle.fromCeiling
                      ? (1.0 - obstacle.height) * (screenHeight - 150)
                      : null,
                  child: CustomPaint(
                    size: Size(20, obstacle.height * (screenHeight - 150)),
                    painter: SpikePainter(fromCeiling: obstacle.fromCeiling),
                  ),
                );
              }),
              // Ball
              Positioned(
                left: screenWidth * 0.2 - 25, // Start the ball more on the left
                top: _ballController.verticalPosition * (screenHeight - 200),
                child: const BallWidget(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BallWidget extends StatelessWidget {
  const BallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }
}
