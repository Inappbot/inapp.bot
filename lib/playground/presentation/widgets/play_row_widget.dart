import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/auth/presentation/providers/user_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/navigation/zoom_fade_route.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_button_with_bubble.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_mode_provider.dart';
import 'package:in_app_bot/in_app_bot/features/qr_assistant_scanner/presentation/pages/full_screen_ai_scanner.dart';
import 'package:in_app_bot/playground/features/data/mode_info_data.dart';
import 'package:in_app_bot/playground/features/modes/presentation/utils/mode_row_builder.dart';
import 'package:in_app_bot/playground/presentation/widgets/custom_section_header.dart';

// Here you can change the modes to be displayed
// For product mode, you need to provide the product botId, productbotName, productbot Image Url, and productbot Description of your product
// For scanaimode, you need to provide the appUserId
// For dataplusmode, you need to provide the appUserId

final currentModeProvider =
    StateProvider<ChatMode>((ref) => ChatMode.dataplusMode);

class PlayRowWidget extends ConsumerWidget {
  const PlayRowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(12.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const CustomSectionHeader(
                          icon: Icons.settings_suggest_sharp,
                          title: 'How it works',
                        ),
                        _buildModesRows(context, 0, 2),
                        const SizedBox(height: 10),
                        const CustomSectionHeader(
                          icon: Icons.account_tree,
                          title: 'Modes',
                        ),
                        _buildModesRows(context, 2, modes.length),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Consumer(
                builder: (context, ref, _) {
                  final userState = ref.watch(userProvider);
                  final userId = userState.user?.id;
                  final currentMode = ref.watch(currentModeProvider);

                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: _buildChatButton(context, ref, currentMode, userId),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChatButton(
      BuildContext context, WidgetRef ref, ChatMode mode, String? userId) {
    ChatModeParams? modeParams = _createChatModeParams(mode, userId);

    return ChatButtonWithBubble(
      mode: mode,
      modeParams: modeParams,
      onNavigate: (context, screen) =>
          _handleNavigation(context, ref, mode, userId, screen),
      bubbleText: 'Hello, I am here to assist you.',
    );
  }

  ChatModeParams? _createChatModeParams(ChatMode mode, String? userId) {
    if (userId == null) return null;

    switch (mode) {
      case ChatMode.dataplusMode:
        return DataplusModeParams(appUserId: userId);
      case ChatMode.productMode:
        return ProductModeParams(
          appUserId: userId,
          productbotId: '222',
          productbotName: 'Toyota Corolla',
          productbotImageUrl:
              'https://file.kelleybluebookimages.com/kbb/base/evox/CP/51678/2023-Toyota-Corolla-front_51678_032_2400x1800_040.png',
          productbotDescription:
              'El Toyota Corolla es un auto confiable y eficiente en combustible, perfecto para la conducción diaria.',
        );
      case ChatMode.scanaimode:
        return ScanAIModeParams(appUserId: userId);
      default:
        return null;
    }
  }

  void _handleNavigation(BuildContext context, WidgetRef ref, ChatMode mode,
      String? userId, Widget screen) {
    if (userId != null) {
      switch (mode) {
        case ChatMode.scanaimode:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullScreenQRScanner(userId: userId),
            ),
          );
          break;
        default:
          ref
              .read(chatStateProvider.notifier)
              .setMode(mode, _createChatModeParams(mode, userId)!);
          Navigator.of(context).push(ZoomFadeRoute(page: screen));
      }
    } else {
      Navigator.push(context, ZoomFadeRoute(page: screen));
    }
  }

  Widget _buildModesRows(BuildContext context, int start, int end) {
    List<Widget> rows = [];
    for (var i = start; i < end; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: buildModeRow(context, modes[i]),
              ),
            ),
            if (i + 1 < modes.length)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: buildModeRow(context, modes[i + 1]),
                ),
              ),
          ],
        ),
      );
    }
    return Column(children: rows);
  }
}
