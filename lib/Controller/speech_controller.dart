import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';

class SpeechController extends GetxController {
  final SpeechToText speech = SpeechToText();

  // Observable variables
  RxBool isListening = false.obs;
  RxBool isAvailable = false.obs;
  RxString recognizedText = ''.obs;
  RxString response = ''.obs;
  RxBool isLoading = false.obs;
  RxDouble confidence = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    initializeSpeech();
  }

  // Initialize speech recognition
  Future<void> initializeSpeech() async {
    try {
      // Request microphone permission
      PermissionStatus status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        bool available = await speech.initialize(
          onStatus: (status) {
            print('Speech status: $status');
            if (status == 'done' || status == 'notListening') {
              stopListening();
            }
          },
          onError: (error) {
            print('Speech error: $error');
            stopListening();
            Get.snackbar(
              'Error',
              'Speech recognition error: ${error.errorMsg}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        );
        isAvailable.value = available;
      } else {
        Get.snackbar(
          'Permission Denied',
          'Microphone permission is required for speech recognition',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error initializing speech: $e');
      isAvailable.value = false;
    }
  }

  // Start listening for speech
  Future<void> startListening() async {
    if (!isAvailable.value) {
      await initializeSpeech();
      if (!isAvailable.value) return;
    }

    recognizedText.value = '';
    response.value = '';
    confidence.value = 0.0;

    await speech.listen(
      onResult: (result) {
        recognizedText.value = result.recognizedWords;
        confidence.value = result.confidence;

        // If speech is final, automatically generate response
        if (result.finalResult) {
          generateResponse(result.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 3),
      listenOptions: SpeechListenOptions(listenMode: ListenMode.confirmation, partialResults: true),
      localeId: 'en_US',
    );

    isListening.value = true;
  }

  // Stop listening
  Future<void> stopListening() async {
    await speech.stop();
    isListening.value = false;
  }

  // Generate response based on recognized speech
  Future<void> generateResponse(String spokenText) async {
    if (spokenText.trim().isEmpty) return;

    isLoading.value = true;

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 3));

      // Generate response based on recognized text
      String generatedResponse = _generateSmartResponse(spokenText);
      response.value = generatedResponse;

      // Show success message
      Get.snackbar(
        'Speech Processed',
        'Response generated successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha:0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate response: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Simple response generation logic
  String _generateSmartResponse(String input) {
    String lowerInput = input.toLowerCase();

    if (lowerInput.contains('hello') || lowerInput.contains('hi')) {
      return "Hello! How can I help you today?";
    } else if (lowerInput.contains('weather')) {
      return "I can't check the weather right now, but you can use a weather app for current conditions.";
    } else if (lowerInput.contains('time')) {
      return "The current time is ${DateTime.now().toString().substring(11, 16)}.";
    } else if (lowerInput.contains('how are you')) {
      return "I'm doing well, thank you for asking! How are you?";
    } else if (lowerInput.contains('what') && lowerInput.contains('name')) {
      return "I'm your voice assistant! You can call me Assistant.";
    } else if (lowerInput.contains('help')) {
      return "I'm here to help! You can ask me questions or have a conversation with me.";
    } else if (lowerInput.contains('thank you') || lowerInput.contains('thanks')) {
      return "You're welcome! Is there anything else I can help you with?";
    } else {
      return "I heard you say: \"$input\". That's interesting! Tell me more about it.";
    }
  }

  // Clear all data
  void clearData() {
    recognizedText.value = '';
    response.value = '';
    confidence.value = 0.0;
  }
}
