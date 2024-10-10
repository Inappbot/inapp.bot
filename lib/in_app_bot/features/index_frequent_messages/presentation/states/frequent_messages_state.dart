import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/core/themes/default_theme.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/controllers/frequent_messages_controller.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/notifiers/questions_notifier.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/application/notifiers/search_notifier.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/presentation/pages/frequent_messages_widget.dart';
import 'package:in_app_bot/in_app_bot/features/index_frequent_messages/presentation/widgets/frequent_messages_button.dart';

class FrequentMessagesWidgetState extends ConsumerState<FrequentMessagesWidget>
    with TickerProviderStateMixin {
  late FrequentMessagesController _controller;
  late final AnimationController _animationController;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _waveAnimations;

  @override
  void initState() {
    super.initState();
    _controller = FrequentMessagesController(this, ref);
    _controller.init();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _initializeAnimations();
  }

  void _initializeAnimations() {
    final filteredQuestions = ref.read(filteredQuestionsProvider);

    if (filteredQuestions.isEmpty) {
      _animationControllers = [];
      _waveAnimations = [];
      return;
    }

    _animationControllers = List.generate(filteredQuestions.length, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );
    });

    _waveAnimations = List.generate(filteredQuestions.length, (index) {
      return Tween<double>(begin: 0.95, end: 1).animate(
        CurvedAnimation(
          parent: _animationControllers[index],
          curve: Curves.elasticOut,
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playAnimations();
    });
  }

  void _playAnimations() {
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: AppTheme.getFrequentMessageDecoration(isDarkMode),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildDragHandle(isDarkMode),
            _buildSearchField(isDarkMode),
            const SizedBox(height: 10),
            Consumer(
              builder: (context, ref, _) {
                final filteredQuestions = ref.watch(filteredQuestionsProvider);

                if (filteredQuestions.isEmpty) {
                  return Center(
                    child: Text(
                      "No frequent messages found.",
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontFamily: 'poppins'),
                    ),
                  );
                }

                if (_animationControllers.isEmpty ||
                    _animationControllers.length != filteredQuestions.length) {
                  _initializeAnimations();
                }

                return Column(
                  children: filteredQuestions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;

                    if (index >= _animationControllers.length) {
                      return const SizedBox.shrink();
                    }

                    return AnimatedBuilder(
                      animation: _animationControllers[index],
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _waveAnimations[index].value,
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          FrequentMessageButton(
                            iconColor: _getIconColor(isDarkMode),
                            textColor: _getTextColor(isDarkMode),
                            message: question,
                            buttonId: 'btn$index',
                            appUserId: widget.appUserId,
                            controller: _controller,
                          ),
                          Divider(color: _getDividerColor(isDarkMode)),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle(bool isDarkMode) {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.5),
        color: isDarkMode ? Colors.grey[300] : Colors.grey[300],
      ),
    );
  }

  Widget _buildSearchField(bool isDarkMode) {
    return Consumer(
      builder: (context, ref, _) {
        return TextField(
          controller: _controller.searchController,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'poppins',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDarkMode
                ? const Color.fromARGB(255, 143, 142, 142)
                : Colors.grey[200],
            hintText: "search...",
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black45,
              fontFamily: 'poppins',
            ),
            prefixIcon: Icon(
              Icons.search,
              color: isDarkMode
                  ? const Color.fromARGB(255, 216, 216, 216)
                  : Colors.grey,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
          ),
          onChanged: (value) {
            ref.read(searchProvider.notifier).updateSearch(value);
          },
        );
      },
    );
  }

  Color _getIconColor(bool isDarkMode) {
    return isDarkMode
        ? const Color.fromARGB(255, 214, 214, 214)
        : const Color(0xB3393939);
  }

  Color _getTextColor(bool isDarkMode) {
    return isDarkMode
        ? const Color.fromARGB(255, 190, 190, 190)
        : const Color(0xFF3A3A3A);
  }

  Color _getDividerColor(bool isDarkMode) {
    return isDarkMode
        ? const Color.fromARGB(133, 121, 120, 120)
        : const Color.fromARGB(255, 225, 225, 225);
  }
}
