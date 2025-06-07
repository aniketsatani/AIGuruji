import 'package:aiguruji/Controller/speech_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpeechScreen extends StatelessWidget {
  final SpeechController controller = Get.put(SpeechController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Assistant'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: controller.clearData,
            tooltip: 'Clear',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Status Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                controller.isAvailable.value ? Icons.mic : Icons.mic_off,
                                color: controller.isAvailable.value ? Colors.green : Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                controller.isAvailable.value
                                    ? 'Ready to listen'
                                    : 'Speech not available',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: controller.isAvailable.value ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 8),
                      Obx(() => controller.confidence.value > 0
                          ? Text(
                              'Confidence: ${(controller.confidence.value * 100).toStringAsFixed(1)}%',
                              style: TextStyle(color: Colors.grey[600]),
                            )
                          : SizedBox.shrink()),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Speech Input Section
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.record_voice_over, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Your Speech:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Obx(() => SingleChildScrollView(
                                  child: Text(
                                    controller.recognizedText.value.isEmpty
                                        ? 'Tap the microphone button to start speaking...'
                                        : controller.recognizedText.value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: controller.recognizedText.value.isEmpty
                                          ? Colors.grey[600]
                                          : Colors.black,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Response Section
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.chat_bubble_outline, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'Response:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Obx(() => controller.isLoading.value
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.green,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Generating response...',
                                          style: TextStyle(color: Colors.green[700]),
                                        ),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Text(
                                      controller.response.value.isEmpty
                                          ? 'Response will appear here after you speak...'
                                          : controller.response.value,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: controller.response.value.isEmpty
                                            ? Colors.grey[600]
                                            : Colors.black,
                                      ),
                                    ),
                                  )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Start/Stop Button
                  Obx(() => FloatingActionButton.extended(
                        onPressed: controller.isAvailable.value
                            ? (controller.isListening.value
                                ? controller.stopListening
                                : controller.startListening)
                            : null,
                        backgroundColor: controller.isListening.value ? Colors.red : Colors.blue,
                        icon: Icon(
                          controller.isListening.value ? Icons.stop : Icons.mic,
                          color: Colors.white,
                        ),
                        label: Text(
                          controller.isListening.value ? 'Stop' : 'Start',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),

                  // Clear Button
                  FloatingActionButton.extended(
                    onPressed: controller.clearData,
                    backgroundColor: Colors.grey,
                    icon: Icon(Icons.clear, color: Colors.white),
                    label: Text(
                      'Clear',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
