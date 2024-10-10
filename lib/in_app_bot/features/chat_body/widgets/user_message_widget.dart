import 'package:flutter/material.dart';

class UserMessageWidget extends StatelessWidget {
  const UserMessageWidget({
    Key? key,
    required this.msg,
    required this.chatIndex,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;
  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    final isRightAligned = chatIndex == 0;
    final screenSize = MediaQuery.of(context).size.width;
    final leftMargin = isRightAligned ? screenSize * 0.25 : 10.0;
    final rightMargin = isRightAligned ? 10.0 : screenSize * 0.25;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Align(
        alignment:
            isRightAligned ? Alignment.centerRight : Alignment.centerLeft,
        child: _buildMessageContainer(isRightAligned, leftMargin, rightMargin),
      ),
    );
  }

  Widget _buildMessageContainer(
      bool isRightAligned, double leftMargin, double rightMargin) {
    return Container(
      margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: _buildContainerDecoration(isRightAligned),
      child: Text(
        msg.trim(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          fontSize: 16,
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration(bool isRightAligned) {
    final containerColor =
        isRightAligned ? const Color(0xCA2195F3) : Colors.grey[200]!;
    return BoxDecoration(
      color: containerColor,
      borderRadius: _buildBorderRadius(isRightAligned),
      boxShadow: _buildBoxShadow(),
    );
  }

  BorderRadius _buildBorderRadius(bool isRightAligned) {
    return BorderRadius.only(
      topLeft: const Radius.circular(15),
      topRight: const Radius.circular(15),
      bottomLeft:
          isRightAligned ? const Radius.circular(15) : const Radius.circular(5),
      bottomRight:
          isRightAligned ? const Radius.circular(5) : const Radius.circular(15),
    );
  }

  List<BoxShadow> _buildBoxShadow() {
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 0.5,
        blurRadius: 1.0,
        offset: const Offset(0, 1),
      ),
    ];
  }
}
