import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Obstacle {
  double xPosition;
  double height;
  bool fromCeiling;
  Obstacle(
      {required this.xPosition,
      required this.height,
      this.fromCeiling = false});
}

class BallController extends ChangeNotifier {
  double verticalPosition = 0.5;
  double velocity = 0.0;
  double gravity = 0.0004;
  late Ticker _ticker;
  double obstacleSpeed = 0.0015;
  double maxObstacleSpeed = 0.0060;
  List<Obstacle> obstacles = [];
  final Random _random = Random();
  bool _isPaused = false;
  double speedIncreaseRate = 0.000005;
  int lives = 5;
  int score = 0;
  int topScore = 0;
  bool isRapidSuccession = false;

  BallController(TickerProvider tickerProvider) {
    _ticker = tickerProvider.createTicker(_tick)..start();

    // Initialize obstacles
    _spawnObstacle();
  }

  void _tick(Duration elapsed) {
    if (_isPaused) {
      resume();
      return;
    }

    // Apply gravity
    velocity += gravity;
    verticalPosition += velocity;
    verticalPosition = verticalPosition.clamp(0.0, 1.0);

    // Move obstacles
    for (var obstacle in obstacles) {
      obstacle.xPosition -= obstacleSpeed;
    }

    // Remove off-screen obstacles and spawn new ones
    if (obstacles.isNotEmpty && obstacles.first.xPosition < -0.1) {
      obstacles.removeAt(0);
      score++;
      if (score > topScore) {
        topScore = score;
      }
    }
    if (obstacles.isEmpty || obstacles.last.xPosition < 0.3) {
      // Occasionally create a rapid succession of spikes
      if (_random.nextDouble() < 0.1 && !isRapidSuccession) {
        _spawnRapidSuccession();
      } else {
        _spawnObstacle();
      }
    }

    // Increase game speed
    if (obstacleSpeed < maxObstacleSpeed) {
      obstacleSpeed += speedIncreaseRate;
    }

    // Check for collisions
    _checkCollisions();

    notifyListeners();
  }

  void _spawnObstacle() {
    double height = 0.3 + _random.nextDouble() * 0.4; // Random height
    bool fromCeiling = _random
        .nextBool(); // Randomly decide if the obstacle is from the ceiling
    obstacles.add(
        Obstacle(xPosition: 1.0, height: height, fromCeiling: fromCeiling));
  }

  void _spawnRapidSuccession() {
    isRapidSuccession = true;
    for (int i = 0; i < 20; i++) {
      double height = 0.2 + _random.nextDouble() * 0.002; // Random height
      bool fromCeiling = i % 2 == 0; // Alternate between ceiling and floor
      obstacles.add(Obstacle(
          xPosition: 1.0 + i * 0.1, height: height, fromCeiling: fromCeiling));
    }
    isRapidSuccession = false;
  }

  void _checkCollisions() {
    for (var obstacle in obstacles) {
      if (_isCollidingWith(obstacle)) {
        // Decrease lives and reset position
        lives--;
        if (lives <= 0) {
          _resetGame();
        } else {
          // Move obstacles further right to let the user try again
          for (var obs in obstacles) {
            obs.xPosition += 0.3;
          }
        }
        break;
      }
    }
  }

  bool _isCollidingWith(Obstacle obstacle) {
    const ballX = 0.2; // Start the ball more on the left
    const ballSize = 0.05;

    // Check horizontal collision
    if (obstacle.xPosition < ballX + ballSize &&
        obstacle.xPosition + 0.05 > ballX - ballSize) {
      // Check vertical collision
      if (obstacle.fromCeiling) {
        if (verticalPosition - ballSize < obstacle.height) {
          return true;
        }
      } else {
        if (verticalPosition + ballSize > 1.0 - obstacle.height) {
          return true;
        }
      }
    }
    return false;
  }

  void updatePosition(double frequency) {
    const minFrequency = 164.81;
    const maxFrequency = 553.25;

    double normalizedPosition =
        (frequency - minFrequency) / (maxFrequency - minFrequency);
    normalizedPosition = normalizedPosition.clamp(0.0, 1.0);
    double targetPosition = 1.0 - normalizedPosition;

    // Calculate the velocity needed to reach the target position
    if (targetPosition < verticalPosition) {
      velocity = -sqrt(2 * gravity * (verticalPosition - targetPosition));
    } else {
      velocity = 0.0;
    }

    notifyListeners();
  }

  void pause() {
    _isPaused = true;
    notifyListeners();
  }

  void resume() {
    _isPaused = false;
    notifyListeners();
  }

  void _resetGame() {
    verticalPosition = 0.5;
    velocity = 0.0;
    obstacleSpeed = 0.0015;
    obstacles.clear();
    _spawnObstacle();
    lives = 5;
    score = 0;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
