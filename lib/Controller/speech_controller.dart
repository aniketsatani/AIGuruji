import 'dart:convert';

import 'package:aiguruji/Constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

RxBool isListening = false.obs;
RxString centerText = 'What can I help you with?'.obs;

class SpeechController extends GetxController {
  final SpeechToText speech = SpeechToText();

  final FlutterTts flutterTts = FlutterTts();


  RxBool isAvailable = false.obs;
  RxString recognizedText = ''.obs;
  RxString responseAI = ''.obs;
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
    await stopSpeech();
    //await initializeSpeech();
    showResponse.value = false;
    recognizedText.value = '';
    responseAI.value = '';
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
     // await Future.delayed(Duration(seconds: 4)); // Simulated delay

      await sendMessage(chatroomId: chatRoomId.value, text: spokenText.trim());

       //String generatedResponse = _generateSmartResponse(spokenText);
       //responseAI.value = generatedResponse;

      showResponse.value = true;
      isLastResponse.value = false;
    } catch (e) {
      centerText.value = 'Error occurred';
    }
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


  Future<void> sendMessage({
    required String chatroomId,
    required String text,
  }) async {
    try {
      isAILoading.value = true;
      //scrollToBottom();

      List<Map<String, dynamic>> lastMessages = await getLast10Messages();

      List<Map<String, dynamic>> chatHistory = [];

      if (lastMessages.isNotEmpty) {
        chatHistory = lastMessages
            .map((msg) {
          return {
            "role": msg['role'],
            "content": msg['content'],
          };
        })
            .toList()
            .reversed
            .toList();
      }

      print('hello data history --- ${chatHistory}');

      final firestore = FirebaseFirestore.instance;
      final chatRoomRef =
      firestore.collection('Chats').doc(userId).collection('ChatRoom').doc(chatroomId);

      if (isNewRoom.value == true) {
        await chatRoomRef.set({
          'createdAt': DateTime.now(),
          'firstMessage': text,
        }, SetOptions(merge: true));
      }

      final messageRef = chatRoomRef.collection('Messages');

      // Store user message
      await messageRef.add({
        'role': 'user',
        'content': text,
        'time': DateTime.now(),
      });

      isNewRoom.value = false;

      // Store AI message
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'X-API-KEY': apiKey},
        body: jsonEncode({
          "session_id": chatroomId,
          "message": text,
          "chat_history": chatHistory,
        }),
      );
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        print(jsonData['response']);

        responseAI.value = jsonData['response'];
        speakTextToSpeech(responseAI.value);

        await messageRef.add({
          'role': 'ai',
          'content': jsonData['response'],
          'time': DateTime.now(),
        });
      }
      isAILoading.value = false;
    } catch (e, t) {
      isAILoading.value = false;
      print('Error : ${e}\nTrace : ${t}');
    }
  }

  Future<void> speakTextToSpeech(String text) async {
    await flutterTts.setLanguage("en-US");
    //await flutterTts.setPitch(1.0);
    //await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  Future<void> stopSpeech() async {
    await flutterTts.stop();
  }

  Future<List<Map<String, dynamic>>> getLast10Messages() async {
    final firestore = FirebaseFirestore.instance;

    final messagesRef = firestore
        .collection('Chats')
        .doc(userId)
        .collection('ChatRoom')
        .doc(chatRoomId.value)
        .collection('Messages');

    final snapshot = await messagesRef
        .orderBy('time', descending: true) // latest first
        .limit(10)
        .get();

    // If no data, return empty list
    if (snapshot.docs.isEmpty) {
      return [];
    }

    // Return the data
    return snapshot.docs.map((doc) => doc.data()).toList();
  }


  Future<void> clearData() async {
    recognizedText.value = '';
    responseAI.value = '';
    showResponse.value = false;
    isListening.value = false;
    centerText.value = 'What can I help you with?';
    await stopSpeech();
  }

  @override
  void onClose() {
    speech.cancel();
    super.onClose();
  }
}
