import 'dart:convert';

import 'package:aiguruji/Constant/constant.dart';
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
    try {
      isAILoading.value = true;
      scrollToBottom();
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
      final url = Uri.parse('https://9d80-163-53-179-211.ngrok-free.app/text');
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
        await messageRef.add({
          'sender': 'ai',
          'response_text': data['response_text'],
          'response_audio_url': data['response_audio_url'],
          'timestamp': DateTime.now(),
        });
        isAILoading.value = false;
      } else {
        isAILoading.value = false;
        print('Error: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e, t) {
      isAILoading.value = false;
      print('Error : ${e}\nTrace : ${t}');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
