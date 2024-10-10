import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/state/bubble_state_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_mode_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_screen/presentation/pages/chat_screen.dart';
import 'package:in_app_bot/playground/auth/presentation/screen/login_screen.dart';

class ChatButtonWithBubble extends ConsumerStatefulWidget {
  final ChatMode mode;
  final ChatModeParams? modeParams;
  final Function(BuildContext, Widget) onNavigate;
  final String bubbleText;
  final String avatarImagePath;
  final Duration bubbleDuration;

  const ChatButtonWithBubble({
    Key? key,
    required this.mode,
    required this.modeParams,
    required this.onNavigate,
    required this.bubbleText,
    this.avatarImagePath = 'assets/images/avatar_eneia.PNG',
    this.bubbleDuration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  ChatButtonWithBubbleState createState() => ChatButtonWithBubbleState();
}

class ChatButtonWithBubbleState extends ConsumerState<ChatButtonWithBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _scheduleBubbleDisplay();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _fadeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(bubbleStateProvider.notifier).show();
      } else if (status == AnimationStatus.dismissed) {
        ref.read(bubbleStateProvider.notifier).hide();
      }
    });
  }

  void _scheduleBubbleDisplay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      Future.delayed(widget.bubbleDuration, () {
        if (mounted) _animationController.reverse();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleNavigation(BuildContext context) {
    late Widget screen;
    if (widget.modeParams == null) {
      screen = const LoginScreen();
    } else {
      ref
          .read(chatStateProvider.notifier)
          .setMode(widget.mode, widget.modeParams!);

      switch (widget.mode) {
        case ChatMode.indexMode:
          final params = widget.modeParams as IndexModeParams;
          screen = ChatScreen(
            appUserId: params.appUserId,
          );
          break;
        case ChatMode.dataplusMode:
          final params = widget.modeParams as DataplusModeParams;
          screen = ChatScreen(
            appUserId: params.appUserId,
          );
          break;
        case ChatMode.productMode:
          final params = widget.modeParams as ProductModeParams;
          screen = ChatScreen(
            appUserId: params.appUserId,
            productbotId: params.productbotId,
            productbotName: params.productbotName,
            productbotImageUrl: params.productbotImageUrl,
            productbotDescription: params.productbotDescription,
          );
          break;
        case ChatMode.scanaimode:
          final params = widget.modeParams as ScanAIModeParams;
          screen = ChatScreen(
            appUserId: params.appUserId,
          );
          break;
      }
    }
    widget.onNavigate(context, screen);
  }

  @override
  Widget build(BuildContext context) {
    final showBubble = ref.watch(bubbleStateProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildChatButton(),
        if (showBubble)
          ChatBubble(
            fadeAnimation: _fadeAnimation,
            text: widget.bubbleText,
          ),
      ],
    );
  }

  Widget _buildChatButton() {
    return Positioned(
      right: 20,
      bottom: 30,
      child: GestureDetector(
        onTap: () => _handleNavigation(context),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(widget.avatarImagePath),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final String text;

  const ChatBubble({
    Key? key,
    required this.fadeAnimation,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 110,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: CustomPaint(
          painter: ChatBubblePainter(),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 10.0, 10.0),
            child: Text(
              text,
              style: const TextStyle(color: Color.fromARGB(221, 255, 255, 255)),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 56, 56, 56)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - 10, 0)
      ..quadraticBezierTo(size.width, 0, size.width, 10)
      ..lineTo(size.width, size.height - 10)
      ..quadraticBezierTo(size.width, size.height, size.width - 10, size.height)
      ..lineTo(200, size.height)
      ..lineTo(190, size.height + 10)
      ..lineTo(180, size.height)
      ..lineTo(10, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - 10)
      ..lineTo(0, 10)
      ..quadraticBezierTo(0, 0, 10, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
