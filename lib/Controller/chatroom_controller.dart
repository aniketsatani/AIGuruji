import 'dart:convert';

import 'package:aiguruji/Constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatroomController extends GetxController {
  final TextEditingController textController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> sendMessage({
    required String chatroomId,
    required String text,
  }) async {
    try {
      isAILoading.value = true;
      scrollToBottom();
      final firestore = FirebaseFirestore.instance;
      final chatRoomRef =
          firestore.collection('Chats').doc(userId).collection('chatRoom').doc(chatroomId);

      if (isNewRoom.value == true) {
        await chatRoomRef.set({
                'createdAt': DateTime.now(),
                'firstMessage': text,
              }, SetOptions(merge: true));
      }

      final messageRef = chatRoomRef.collection('Messages');

      // Store user message
      await messageRef.add({
        'sender': 'user',
        'text': text,
        'time': DateTime.now(),
      });

      isNewRoom.value = false;

      // Store AI message
      final url = Uri.parse('https://dd9d03d45551.ngrok-free.app/text');
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
          'time': DateTime.now(),
        });
      }
      isAILoading.value = false;
    } catch (e, t) {
      isAILoading.value = false;
      print('Error : ${e}\nTrace : ${t}');
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }
}
