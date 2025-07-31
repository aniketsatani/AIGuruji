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

    List<Map<String, dynamic>> lastMessages = await getLast10Messages();

      List<Map<String, dynamic>> chatHistory = [];

      if (lastMessages.isNotEmpty) {
        chatHistory = lastMessages.map((msg) {
          return {
            "role": msg['role'],
            "content": msg['content'],
          };
        }).toList().reversed.toList();
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
        final data = jsonDecode(response.body);

        print('hello response data body --- ${data}');

        await messageRef.add({
          'role': 'ai',
          'content': data['response'],
          'time': DateTime.now(),
        });
      }
      isAILoading.value = false;
    } catch (e, t) {
      isAILoading.value = false;
      print('Error : ${e}\nTrace : ${t}');
    }
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

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }
}
