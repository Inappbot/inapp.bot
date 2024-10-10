import 'package:flutter/material.dart';

class AssitantResponseWidget extends StatelessWidget {
  final List<Widget> messageParts;
  final int index;

  const AssitantResponseWidget({
    Key? key,
    required this.messageParts,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        key: ValueKey('message-$index'),
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200]!,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(5),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 212, 212, 212).withOpacity(0.2),
                spreadRadius: 0.5,
                blurRadius: 1.0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: messageParts,
          ),
        ),
      ),
    );
  }
}
