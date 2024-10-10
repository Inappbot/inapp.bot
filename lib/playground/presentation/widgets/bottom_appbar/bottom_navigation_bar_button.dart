import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/auth/presentation/providers/user_provider.dart';
import 'package:in_app_bot/playground/auth/presentation/screen/login_screen.dart';
import 'package:in_app_bot/playground/features/modes/presentation/modes_view.dart';
import 'package:in_app_bot/playground/profile/screen/profile_screen.dart';

enum BottomNavButton { community, account }

class BottomNavigationBarButton extends ConsumerWidget {
  final IconData icon;
  final BottomNavButton buttonType;

  const BottomNavigationBarButton({
    Key? key,
    required this.icon,
    required this.buttonType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final userId = userState.user?.id;
    return TextButton(
      onPressed: () => _handleButtonPress(context, buttonType, userId),
      style: TextButton.styleFrom(foregroundColor: const Color(0xFF020623)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 26),
          const SizedBox(height: 0),
          Flexible(
            child: Text(
              _buttonLabel(buttonType),
              style: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(255, 57, 57, 57)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleButtonPress(
    BuildContext context,
    BottomNavButton buttonType,
    String? userId,
  ) {
    switch (buttonType) {
      case BottomNavButton.community:
        _navigateToCommunity(context);
        break;
      case BottomNavButton.account:
        _navigateToAccount(context, userId);
        break;
    }
  }

  void _navigateToCommunity(BuildContext context) {
    Navigator.push(
      context,
      _createPageRoute(
        const ModesPage(
          title: 'Community',
          imageUrl:
              'lib/playground/onboarding/assets/images/communityplus.webp',
          modeItems: [
            {
              'title': 'Social',
              'description': '''
##Follow us, we are already 1,000.##
web(inapp.bot)
github(inappbot)
x(inappbot)
youtube(inappbot)

'''
            },
            {
              'title': 'Contributors',
              'description': '''
##Thank you for contributing. ##
contributors(username: jesus89x2 , Commits: 182, Additions: 165925, Deletions: 111462, userimage: 'lib/playground/onboarding/assets/images/jesus.jpg')

'''
            },
            {
              'title': 'Sponsors',
              'description': '''
##Thank you for supporting us.##
sponsor(companyName: inappbot, description: Open Source platform, logo: 'lib/playground/onboarding/assets/images/x.webp', websiteUrl: x.com/inappbot)

'''
            },
          ],
          fromBottomNavigationBar: true,
        ),
      ),
    );
  }

  void _navigateToAccount(BuildContext context, String? userId) {
    Widget screen;
    if (userId == null) {
      screen = const LoginScreen();
    } else {
      screen = const ProfileScreen();
    }
    Navigator.push(
      context,
      _createPageRoute(screen),
    );
  }

  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
        position: animation.drive(
            Tween(begin: const Offset(0.0, 0.5), end: Offset.zero)
                .chain(CurveTween(curve: Curves.ease))),
        child: FadeTransition(opacity: animation, child: child),
      ),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  String _buttonLabel(BottomNavButton buttonType) {
    switch (buttonType) {
      case BottomNavButton.community:
        return 'Community';
      case BottomNavButton.account:
        return 'Account';
      default:
        return '';
    }
  }
}
