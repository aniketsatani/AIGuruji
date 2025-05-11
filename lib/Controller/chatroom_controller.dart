import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatroomController extends GetxController {
  final TextEditingController textController = TextEditingController();

  final ScrollController scrollController = ScrollController();


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

    final url = Uri.parse('https://e4df-150-107-232-24.ngrok-free.app/text');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'X-API-Key': 'XCoderInfotechBaba'},
      body: jsonEncode({
        "session_id": chatroomId,
        "text": text,
        "language": "en",
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final String replyText = data['response_text'];
      final String? audioUrl = data['response_audio_url'];

      print('Reply: $replyText');
      print('Audio URL: $audioUrl');

      await messageRef.add({
        'sender': 'ai',
        'response_text': replyText,
        'response_audio_url': audioUrl,
        'timestamp': DateTime.now(),
      });
    } else {
      print('Error: ${response.statusCode}\nBody: ${response.body}');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
