import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {
  final SpeechToText speech = SpeechToText();

  RxBool isListening = false.obs;
  RxBool isAvailable = false.obs;
  RxString recognizedText = ''.obs;
  RxString response = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isProcessing = false.obs;
  RxString centerText = 'What can I help you with?'.obs;
  RxBool showResponse = false.obs;
  RxBool isRefresh = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeSpeech();
  }

  Future<void> initializeSpeech() async {
    try {
      isAvailable.value = await speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            isListening.value = false;
            showResponse.value = false;

            print('hello status --- $status');
            print('hello showResponse value --- ${showResponse.value}');
            if (showResponse.value == false) {
              centerText.value = 'Tap to start listening';
              isRefresh.value = !isRefresh.value;
            }
          }
        },
        onError: errorListener
      );

      if (isAvailable.value) {
        centerText.value = 'What can I help you with?';
      }
    } catch (e) {
      print('Error initializing speech: $e');
      isAvailable.value = false;
      centerText.value = 'Error occurred Catch';
    }
  }

  Future<void> startListening() async {
    //await initializeSpeech();
    showResponse.value = false;
    recognizedText.value = '';
    response.value = '';
    centerText.value = 'I\'m listening.....';

    await speech.listen(
      onResult: (result) {
        recognizedText.value = result.recognizedWords;

        if (result.recognizedWords.isNotEmpty) {
          centerText.value = result.recognizedWords;
        }

        if (result.finalResult) {
          isListening.value = false;
          generateResponse(result.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 100),
      pauseFor: Duration(seconds: 100),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,cancelOnError: true,
        partialResults: true,
      ),
    );

    errorListener;


    isListening.value = true;
  }

  void errorListener(SpeechRecognitionError error) {
    print('Speech error ------> ${error.errorMsg}');

    isListening.value = false;
    centerText.value = 'Tap to start listening';
    isRefresh.value = !isRefresh.value;
    print('Speech isRefresh ---> ${isRefresh.value}');


  }

  Future<void> stopListening() async {
    await speech.stop();
    isListening.value = false;

    // If no response, reset center text
    if (!showResponse.value) {
      centerText.value = 'Tap to start listening';
    }
  }

  Future<void> generateResponse(String spokenText) async {
    if (spokenText.trim().isEmpty) return;

    isLoading.value = true;
    isProcessing.value = true;
    centerText.value = 'Thinking.....';

    try {
      await Future.delayed(Duration(seconds: 4)); // Simulated delay

      String generatedResponse = _generateSmartResponse(spokenText);
      response.value = generatedResponse;

      showResponse.value = true;
    } catch (e) {
      centerText.value = 'Error occurred';
    } finally {
      isLoading.value = false;
      isProcessing.value = false;
      isListening.value = false;
    }
  }

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
