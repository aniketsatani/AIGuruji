import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {
  final SpeechToText speech = SpeechToText();

  RxBool isListening = false.obs;
  RxBool isAvailable = false.obs;
  RxString recognizedText = ''.obs;
  RxString response = ''.obs;
  RxBool isLoading = false.obs;

  RxBool isProcessing = false.obs;
  RxString centerText = 'What can I help you with?'.obs;  // Changed initial text
  RxBool showResponse = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeSpeech();
  }

  Future<void> initializeSpeech() async {
    try {
      PermissionStatus status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        isAvailable.value = await speech.initialize(
        );
        if (isAvailable.value) {
          centerText.value = 'What can I help you with?';

        }
      }
    } catch (e) {
      print('Error initializing speech: $e');
      isAvailable.value = false;
      centerText.value = 'Error occurred';
    }
  }

  // Start listening for speech
  Future<void> startListening() async {

    showResponse.value = false;
    recognizedText.value = '';
    response.value = '';
    centerText.value = 'I am listening';

    await speech.listen(
      onResult: (result) {
        recognizedText.value = result.recognizedWords;

        // Update center text when user is speaking
        if (result.recognizedWords.isNotEmpty) {
          centerText.value = result.recognizedWords;
        }

        // If speech is final, automatically generate response
        if (result.finalResult) {
          generateResponse(result.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 5),
      listenOptions: SpeechListenOptions(
          listenMode: ListenMode.confirmation,
          partialResults: true
      ),
      localeId: 'en_US',
    );

    isListening.value = true;
  }

  // Stop listening
  Future<void> stopListening() async {
    await speech.stop();
    isListening.value = false;
    centerText.value = 'Tap to start listening';  // Changed this line

  }

  // Generate response based on recognized speech
  Future<void> generateResponse(String spokenText) async {
    if (spokenText.trim().isEmpty) return;

    isLoading.value = true;
    isProcessing.value = true;
    centerText.value = 'Processing...';

    try {
      await Future.delayed(Duration(seconds: 2));

      String generatedResponse = _generateSmartResponse(spokenText);
      response.value = generatedResponse;

      showResponse.value = true;
      centerText.value = 'Talk to interrupt';

    } catch (e) {
      centerText.value = 'Error occurred';
    } finally {
      isLoading.value = false;
      isProcessing.value = false;
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
    showResponse.value = false;
    centerText.value = 'What can I help you with?';
  }

  @override
  void onClose() {
    speech.stop();
    super.onClose();
  }
}