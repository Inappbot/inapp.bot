import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_mode_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_input/application/providers/knowledge_provider.dart';
import 'package:in_app_bot/in_app_bot/features/notifications/presentation/state/notification_providers.dart';
import 'package:in_app_bot/in_app_bot/features/qr_assistant_scanner/presentation/providers/qr_ai_providers.dart';

class KnowledgeBaseWidget extends ConsumerStatefulWidget {
  const KnowledgeBaseWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<KnowledgeBaseWidget> createState() =>
      _KnowledgeBaseWidgetState();
}

class _KnowledgeBaseWidgetState extends ConsumerState<KnowledgeBaseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleKnowledgeBase() {
    if (ref.read(showKnowledgeBaseProvider)) {
      ref.read(showKnowledgeBaseProvider.notifier).state = false;
    } else {
      FocusScope.of(context).unfocus();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          ref.read(showKnowledgeBaseProvider.notifier).state = true;
        }
      });
    }
  }

  String _getModeName(ChatMode? mode) {
    final selectedNotification = ref.watch(selectedNotificationProvider);
    final productData = ref.watch(productDataProvider);

    switch (mode) {
      case ChatMode.indexMode:
        return "Index";
      case ChatMode.dataplusMode:
        return "General";
      case ChatMode.productMode:
        if (productData != null) {
          return "Scanned";
        } else if (selectedNotification != null) {
          return "Notifications";
        } else {
          return "Product";
        }
      default:
        return "N/A";
    }
  }

  String _getCapabilityDescription(ChatMode? mode) {
    final selectedNotification = ref.watch(selectedNotificationProvider);
    final productData = ref.watch(productDataProvider);

    switch (mode) {
      case ChatMode.indexMode:
        return "Responses based on the application index";
      case ChatMode.dataplusMode:
        return "Responses enriched with additional data";
      case ChatMode.productMode:
        if (productData != null) {
          return "Information about the scanned product";
        } else if (selectedNotification != null) {
          return "Information about the current notification";
        } else {
          return "Specific information about products";
        }
      default:
        return "Answers to questions about this app";
    }
  }

  String _getKnowledgeBaseDescription(ChatMode? mode) {
    final selectedNotification = ref.watch(selectedNotificationProvider);
    final productData = ref.watch(productDataProvider);

    switch (mode) {
      case ChatMode.indexMode:
        return "In this mode, the assistant uses an application index to provide accurate and relevant answers.";
      case ChatMode.dataplusMode:
        return "In Dataplus mode, the assistant enriches its responses with additional data to provide more comprehensive and detailed information.";
      case ChatMode.productMode:
        if (productData != null) {
          return "In this mode, the assistant provides detailed information about the product you've scanned. You can ask about its features, price, availability, etc.";
        } else if (selectedNotification != null) {
          return "In this mode, the assistant provides detailed information about the current notification and how to interact with it.";
        } else {
          return "The Product mode focuses on providing detailed and specific information about particular products.";
        }
      default:
        return "In this chat, the assistant has the ability to answer questions about this app. You can ask about any topic related to the app, and the assistant will try to respond in the best possible way.";
    }
  }

  Widget _buildKnowledgeBaseButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleKnowledgeBase,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: ref.watch(showKnowledgeBaseProvider)
                ? Colors.blue.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: ref.watch(showKnowledgeBaseProvider)
                  ? Colors.blue
                  : const Color.fromARGB(255, 238, 238, 238),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: scaleAnimation,
                child: AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return Icon(
                      ref.watch(showKnowledgeBaseProvider)
                          ? Icons.auto_awesome_rounded
                          : Icons.auto_awesome_outlined,
                      color: _colorAnimation.value,
                      size: 20,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ref.watch(showKnowledgeBaseProvider)
                    ? "Assistant knowledge base"
                    : _getModeName(ref.watch(chatStateProvider).mode),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: ref.watch(showKnowledgeBaseProvider)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapabilityItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKnowledgeBaseInfo() {
    return Consumer(
      builder: (context, ref, _) {
        final chatState = ref.watch(chatStateProvider);
        final showKnowledgeBase = ref.watch(showKnowledgeBaseProvider);
        final productData = ref.watch(productDataProvider);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: showKnowledgeBase ? null : 0,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Knowledge base '${_getModeName(chatState.mode)}'",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCapabilityItem(
                    Icons.question_answer,
                    _getCapabilityDescription(chatState.mode),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getKnowledgeBaseDescription(chatState.mode),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  if (productData != null) ...[
                    const SizedBox(height: 12),
                    const Text(
                      "Scanned :",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Name: ${productData['name']}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    // Add more product details as needed
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildKnowledgeBaseButton(),
        const SizedBox(height: 8),
        _buildKnowledgeBaseInfo(),
      ],
    );
  }
}
