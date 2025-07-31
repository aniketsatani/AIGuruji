import 'package:aiguruji/Constant/constant.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

RxBool isListening = false.obs;
RxString centerText = 'What can I help you with?'.obs;

class SpeechController extends GetxController {
  final SpeechToText speech = SpeechToText();

  RxBool isAvailable = false.obs;
  RxString recognizedText = ''.obs;
  RxString response = ''.obs;
  RxBool showResponse = false.obs;
  RxBool isLastResponse = false.obs;

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
            }
          },
          onError: errorListener);

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
        isLastResponse.value = true;


        if (result.recognizedWords.isNotEmpty) {
          centerText.value = result.recognizedWords;
        }

        if (result.finalResult) {
          isLastResponse.value = true;

          isListening.value = false;
          print('hello is isListening.value ERROR ---- ${isListening.value}');
          print('hello is isLastResponse.value ERROR ---- ${isLastResponse.value}');
          generateResponse(result.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 100),
      pauseFor: Duration(seconds: 100),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        cancelOnError: true,
        partialResults: true,
      ),
    );
    isListening.value = true;
    print('hello is isListening.value ERROR BEFORE ---- ${isListening.value}');

    errorListener;
  }

  errorListener(SpeechRecognitionError error) {
    isListening.value = false;
    centerText.value = 'Tap to start listening';

  }

  Future<void> generateResponse(String spokenText) async {
    if (spokenText.trim().isEmpty) return;

    centerText.value = 'Thinking.....';

    try {
      await Future.delayed(Duration(seconds: 4)); // Simulated delay

      String generatedResponse = _generateSmartResponse(spokenText);
      response.value = generatedResponse;

      showResponse.value = true;
      isLastResponse.value = false;
    } catch (e) {
      centerText.value = 'Error occurred';
    }
  }


  Future<void> callApi() async {

  }

  String _generateSmartResponse(String input) {
    String lowerInput = input.toLowerCase();

    if (lowerInput.contains('hello') || lowerInput.contains('hi')) {
      return "Hi there! How can I help?";
    } else if (lowerInput.contains('weather')) {
      return "Check your weather app for updates.";
    } else if (lowerInput.contains('time')) {
      return "It's ${DateFormat('hh:mm a').format(DateTime.now())} right now.";
    } else if (lowerInput.contains('how are you')) {
      return "I'm great! Hope you're doing well too.";
    } else if (lowerInput.contains('your name')) {
      return "I'm your smart assistant.";
    } else if (lowerInput.contains('help')) {
      return "Ask me anything. I'm here to help!";
    } else if (lowerInput.contains('thank you') || lowerInput.contains('thanks')) {
      return "You're welcome! Happy to help.";
    } else if (lowerInput.contains('joke')) {
      return "Why did the tomato blush? It saw salad.";
    } else if (lowerInput.contains('good morning')) {
      return "Good morning! Have a great day.";
    } else if (lowerInput.contains('good night')) {
      return "Good night! Sweet dreams.";
    } else if (lowerInput.contains('motivate') || lowerInput.contains('motivation')) {
      return "Keep going, you're doing great!";
    } else if (lowerInput.contains('remind') || lowerInput.contains('reminder')) {
      return "Sorry, I can't set reminders yet.";
    } else if (lowerInput.contains('tell me something')) {
      return "Octopuses have three hearts!";
    } else if (lowerInput.contains('who are you')) {
      return "Just your AI buddy, always here.";
    } else if (lowerInput.contains('i am sad') || lowerInput.contains('feeling down')) {
      return "You're not alone. I'm here for you.";
    } else if (lowerInput.contains('what should i eat')) {
      return "Try something healthy and tasty!";
    } else if (lowerInput.contains('music')) {
      return "Open your music app and vibe!";
    } else if (lowerInput.contains('my name')) {
      return "Your name is ${name.value}. Nice to meet you 🤩";
    } else {
      return "I heard: \"$input\". Tell me more!";
    }
  }

  void clearData() {
    recognizedText.value = '';
    response.value = '';
    showResponse.value = false;
    isListening.value = false;
    centerText.value = 'What can I help you with?';
  }

  @override
  void onClose() {
    speech.cancel();
    super.onClose();
  }
}
