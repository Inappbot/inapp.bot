import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/auth/presentation/screen/components/background_video.dart';
import 'package:in_app_bot/playground/auth/presentation/screen/components/bottom_container.dart';
import 'package:in_app_bot/playground/auth/presentation/screen/widgets/subtitle_widget.dart';
import 'package:in_app_bot/playground/auth/presentation/screen/widgets/title_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundVideo(),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                const TitleWidget(),
                const SizedBox(height: 24),
                const SubTitleWidget(
                    text:
                        'Virtual assistants that seamlessly integrate across all platforms, enhancing the productivity of your apps.'),
                const Spacer(flex: 1),
                const BottomContainerComponent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
