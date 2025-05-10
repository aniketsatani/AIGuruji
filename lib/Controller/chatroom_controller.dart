import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatroomController extends GetxController {

  final TextEditingController textController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  List<String> sentences = [
    'Aniket loves clean architecture',
    'Nirmal uses Riverpod daily',
    'Shreyas builds responsive layouts',
    'Flutter boosts developer speed',
    'Firebase handles backend tasks',
    'Debugging is Shreyas\' superpower',
    'AI Guruji solves bugs',
    'Aniket explores new widgets',
    'Nirmal designs elegant UI',
    'Code reviews make apps better',
    'Flutter devs love hot reload',
    'Git keeps code in sync',
    'State management is crucial',
    'Shreyas mentors junior devs',
    'Aniket automates repetitive tasks',
    'Nirmal deploys with confidence',
    'Learning never stops in dev',
    'Flutter connects frontend and backend',
    'Testing makes apps stable',
    'Developers build the future',
  ];


  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }



  Future<void> sendMessage({
    required String userId,
    required String chatroomId,
    required String text,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final messageRef = firestore
        .collection('chat')
        .doc(userId)
        .collection('chatRoom')
        .doc(chatroomId)
        .collection('message');

    // Store user message
    await messageRef.add({
      'sender': 'user',
      'text': text,
      'timestamp': DateTime.now(),
    });

    // // Call your API
    // final response = await http.post(
    //   Uri.parse('http://localhost:8000/text'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({
    //     'session_id': chatroomId,
    //     'text': text,
    //     'language': 'en',
    //   }),
    // );
    //
    // final aiText = jsonDecode(response.body)['response'];

    // Store AI response


    sentences.shuffle();
    String randomSentence = sentences[Random().nextInt(sentences.length)];


    await messageRef.add({
      'sender': 'ai',
      'text': randomSentence,
      'timestamp': DateTime.now(),
    });
  }


  @override
  void onInit() {
    super.onInit();
  }
}