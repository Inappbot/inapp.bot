import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/onboarding/domain/entities/second_page_image_entity.dart';
import 'package:in_app_bot/playground/onboarding/domain/usecases/second_page_get_image_usecase.dart';

class AnimatedHandImageWidget extends StatefulWidget {
  final bool showImage2;
  const AnimatedHandImageWidget({Key? key, required this.showImage2})
      : super(key: key);

  @override
  AnimatedHandImageWidgetState createState() => AnimatedHandImageWidgetState();
}

class AnimatedHandImageWidgetState extends State<AnimatedHandImageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _rotationAnimation = Tween<double>(
    begin: 0.05,
    end: 0.3,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  final GetImageUseCase _getImageUseCase = GetImageUseCase();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.showImage2,
      child: AnimatedOpacity(
        opacity: widget.showImage2 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: _buildRotatingImage(context),
      ),
    );
  }

  Widget _buildRotatingImage(BuildContext context) {
    final ImageEntity imageEntity =
        _getImageUseCase(MediaQuery.of(context).size.width);

    return Align(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (_, child) => Transform.rotate(
          angle: _rotationAnimation.value,
          child: child,
        ),
        child: Container(
          width: imageEntity.size,
          height: imageEntity.size,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageEntity.imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
