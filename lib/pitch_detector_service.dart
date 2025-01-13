// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';

class PitchDetectorService {
  final FlutterAudioCapture _audioCapture = FlutterAudioCapture();
  final PitchDetector _pitchDetector = PitchDetector();
  late Function(double) onPitchDetected;
  late Function() onSoundDetected;
  bool _soundDetected = false;

  /// Start listening for audio and detecting pitch
  Future<void> startListening(
      Function(double) onPitch, Function() onSound) async {
    onPitchDetected = onPitch;
    onSoundDetected = onSound;
    print('Listening for pitch...');

    try {
      // Initialize the audio capture
      await _audioCapture.init();

      await _audioCapture.start(
        (Float32List audioData) async {
          // Validate audio data
          if (audioData.isEmpty) {
            print('Received empty audio data');
            return;
          }

          // Ensure the audio data length matches the buffer size
          if (audioData.length != 7056) {
            print('Invalid audio buffer size: ${audioData.length}');
            return;
          }

          // Detect pitch from the audio data
          try {
            final pitchResultFuture =
                _pitchDetector.getPitchFromFloatBuffer(audioData.toList());
            final pitchResult = await pitchResultFuture;
            if (pitchResult.pitch > 0) {
              onPitchDetected(pitchResult.pitch);
              if (!_soundDetected) {
                _soundDetected = true;
                onSoundDetected();
              }
            }
          } catch (e) {
            print('Error detecting pitch: $e');
          }
        },
        (Object error) {
          print('Error capturing audio: $error');
        },
        sampleRate: 44100,
        bufferSize: 7056, // Adjust buffer size if needed
        androidAudioSource: ANDROID_AUDIOSRC_MIC,
      );
    } catch (e) {
      print('Error starting audio capture: $e');
    }
  }

  /// Stop audio capture
  Future<void> stopListening() async {
    try {
      await _audioCapture.stop();
    } catch (e) {
      print('Error stopping audio capture: $e');
    }
  }
}
