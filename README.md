# Pitch Control Game

## Overview
The Pitch Control Game is an innovative Flutter-based mobile application that leverages pitch detection to create an interactive and engaging gaming experience. This project showcases the integration of audio capture and pitch detection to control game actions using the player's voice.

## Key Features
- **Pitch Detection**: The game uses `FlutterAudioCapture` and `PitchDetector` to detect the pitch of the player's voice. This allows the game to respond to vocal inputs, making the gameplay experience unique and interactive.
- **Voice-Controlled Gameplay**: Players can start and restart the game by making a sound. This eliminates the need for traditional touch controls and adds a novel twist to the gaming experience.
- **Dynamic Obstacles**: The game features obstacles that appear in rapid succession, requiring players to navigate carefully using their voice. This adds a layer of challenge and excitement to the gameplay.
- **Score Tracking**: The game keeps track of the player's score and top score, providing a competitive element that encourages players to improve their performance.
- **User Interface**: The game boasts a clean and intuitive user interface, ensuring that players can easily understand and enjoy the game.

## How It Works
- **Starting the Game**: The game begins when the player makes any sound. The pitch detection system captures the sound and starts the game.
- **Navigating Obstacles**: Players use their voice to control the ball and navigate through obstacles. The pitch of the player's voice determines the movement of the ball.
- **Game Over and Restart**: When the player loses all lives, the game transitions to the game over screen. To restart the game, the player simply makes any sound, and the game begins anew.

## Technical Details
- **Flutter Framework**: The game is built using the Flutter framework, which allows for cross-platform development and a smooth user experience.
- **Audio Capture**: The app uses `FlutterAudioCapture` to capture audio input from the player's device.
- **Pitch Detection**: The captured audio is processed using `PitchDetector` to determine the pitch of the player's voice.
- **State Management**: The game uses state management techniques to handle game states, such as starting, pausing, and restarting the game.

## Installation and Usage
To run this project locally, follow these steps:

1. **Clone the repository**:
    ```sh
    git clone <repository-url>
    ```
2. **Install dependencies**:
    ```sh
    flutter pub get
    ```
3. **Run the app**:
    ```sh
    flutter run
    ```

## APK Download
You can download the latest APK file from the `build` folder.
Link to apk: `/build/app/outpts/flutter-apk/app-release.apk`.