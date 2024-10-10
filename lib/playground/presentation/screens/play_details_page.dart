import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_bot/playground/presentation/widgets/appbar/app_bar_builder.dart';
import 'package:in_app_bot/playground/presentation/widgets/bottom_appbar/bottom_navigation_bar.dart';
import 'package:in_app_bot/playground/presentation/widgets/bottom_appbar/custom_floating_action_button.dart';
import 'package:in_app_bot/playground/presentation/widgets/play_row_widget.dart';

class PlayDetailsPage extends StatelessWidget {
  const PlayDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(221, 1, 3, 20),
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AnimatedAppBar(),
      body: const PlayRowWidget(),
      bottomNavigationBar: buildBottomNavigationBar(),
      floatingActionButton: const MyAppFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
