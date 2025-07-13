import 'package:aiguruji/Controller/speech_controller.dart';
import 'package:aiguruji/UI/speech_bgvideo_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpeechScreen extends StatelessWidget {
  final SpeechController controller = Get.put(SpeechController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Video Background
          VideoBackground(),

          // Main Content
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.white, size: 28),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),

              // Center Display Area
              Expanded(
                child: Center(
                  child: // Center Text or Response
                      Obx(() => AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: controller.showResponse.value
                                ? ResponseDisplay()
                                : CenterTextDisplay(),
                          )),
                ),
              ),

              // Bottom Control Area
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Main Control Button
                        Obx(() => FloatingActionButton.extended(
                              onPressed: controller.isAvailable.value
                                  ? (controller.isListening.value
                                      ? controller.startListening
                                      :
                              controller.startListening)
                                  : null,
                              backgroundColor: _getButtonColor().withOpacity(0.8),
                              icon: Icon(
                                _getButtonIcon(),
                                color: Colors.white,
                              ),
                              label: Text(
                                _getButtonText(),
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget CenterTextDisplay() {
    return Text(
      controller.centerText.value,
      key: ValueKey('center_text'),
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 3,
            color: Colors.black.withOpacity(0.7),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget ResponseDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: ValueKey('response_display'),
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            controller.response.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Talk to interrupt',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Color _getButtonColor() {
   // if (controller.isListening.value) return Colors.red;
    return Colors.blue;
  }

  IconData _getButtonIcon() {
    //if (controller.isListening.value) return Icons.stop;
    return Icons.mic;
  }

  String _getButtonText() {
   // if (controller.isListening.value) return 'Stop';
    return 'Start';
  }
}
