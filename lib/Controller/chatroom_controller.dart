import 'dart:convert';

import 'package:aiguruji/Constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatroomController extends GetxController {
  final TextEditingController textController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  void fetchChatRoomsAndMessages() async {
    try {
      // Step 1: Get all chatRoom documents
      final chatRoomsSnapshot = await FirebaseFirestore.instance
          .collection('chatUser')
          .doc(userId)
          .collection('chatRoom')
          .get();
      print('❌ No chat rooms found for user: $userId');

      print('✅ Total ChatRooms: ${chatRoomsSnapshot.docs}');
      print('👉 ChatRoom IDs: ${chatRoomsSnapshot.docs.map((e) => e.id).toList()}');

      // Step 2: For each chatRoom, get the latest message
      for (var chatRoomDoc in chatRoomsSnapshot.docs) {
        final chatRoomId = chatRoomDoc.id;

        print('\n🔍 Fetching latest message for ChatRoom ID: $chatRoomId');

        final messagesSnapshot = await FirebaseFirestore.instance
            .collection('chatUser')
            .doc(userId)
            .collection('chatRoom')
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('time', descending: true)
            .limit(1)
            .get();

        if (messagesSnapshot.docs.isEmpty) {
          print('⚠️ No messages found in chatRoom: ${messagesSnapshot.docs.length}');
        } else {
          final latestMessageDoc = messagesSnapshot.docs.first;
          final messageText = latestMessageDoc.data()['text'];
          print('✅ Latest message in $chatRoomId: $messageText');
        }
      }
    } catch (e) {
      print('❌ Error: $e');
    }
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
          .collection('chatUser')
          .doc(userId)
          .collection('chatRoom')
          .doc(chatroomId)
          .collection('messages');

      // Store user message
      await messageRef.add({
        'sender': 'user',
        'text': text,
        'time': DateTime.now(),
      });
      final url = Uri.parse('https://d395-150-107-241-153.ngrok-free.app/text');
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

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
  }
}
