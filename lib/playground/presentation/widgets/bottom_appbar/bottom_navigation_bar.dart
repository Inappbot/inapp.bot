import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/presentation/widgets/bottom_appbar/bottom_navigation_bar_button.dart';

Container buildBottomNavigationBar() {
  double height = Platform.isAndroid ? 60 : 90;
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: const Color.fromARGB(0, 255, 255, 255),
      boxShadow: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 1).withOpacity(0.2),
          spreadRadius: 0,
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: const BottomAppBar(
      color: Colors.white,
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          BottomNavigationBarButton(
            icon: Icons.people,
            buttonType: BottomNavButton.community,
          ),
          SizedBox(width: 48),
          BottomNavigationBarButton(
            icon: Icons.person,
            buttonType: BottomNavButton.account,
          ),
        ],
      ),
    ),
  );
}
