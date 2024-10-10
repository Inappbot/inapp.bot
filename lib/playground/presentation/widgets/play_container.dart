import 'package:flutter/material.dart';

class PlayContainer extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onTap;

  PlayContainer({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: _playContainerDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageContainer(imageUrl),
                _buildTitleContainer(title),
              ],
            ),
          ),
          if (title == "Data Plus Mode") _buildRagText(),
          if (title == "Index Mode") _buildRagText(),
        ],
      ),
    );
  }

  final _playContainerDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(155, 155, 155, 0.239),
        offset: Offset(0, 1),
        blurRadius: 2,
      ),
    ],
    color: const Color.fromRGBO(255, 255, 255, 1),
    border:
        Border.all(color: const Color.fromARGB(255, 245, 245, 245), width: 0.5),
  );

  Widget _buildImageContainer(String imageUrl) {
    return Hero(
      tag: imageUrl,
      transitionOnUserGestures: true,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleContainer(String title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          title,
          style: _titleTextStyle,
        ),
      ),
    );
  }

  Widget _buildRagText() {
    return Positioned(
      top: 10,
      right: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: const Color.fromARGB(194, 45, 45, 45),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          "RAG",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  final _titleTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(214, 51, 51, 51),
    fontFamily: 'Poppins',
  );
}
