import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomUserAvatar extends StatelessWidget {
  final String photoURL;
  final double maxRadius;
  final Color backgroundColor;

  const CustomUserAvatar({
    Key? key,
    required this.photoURL,
    this.maxRadius = 40,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: CircleAvatar(
        maxRadius: maxRadius,
        backgroundColor: Colors.grey[300],
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (photoURL.startsWith('https://ui-avatars.com')) {
      return Text(
        photoURL.split('name=')[1][0].toUpperCase(),
        style: TextStyle(
          fontSize: maxRadius,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    } else {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: photoURL,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
          width: maxRadius * 2,
          height: maxRadius * 2,
        ),
      );
    }
  }
}
