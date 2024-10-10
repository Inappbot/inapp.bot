import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/features/modes/presentation/modes_view.dart';

class MyAppFloatingActionButton extends StatelessWidget {
  const MyAppFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToModesPage(context),
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      elevation: 0,
      child: const _FloatingActionButtonChild(),
    );
  }

  void _navigateToModesPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ModesPage(
          title: 'Add In Your App',
          imageUrl: 'lib/playground/onboarding/assets/images/dataplus.png',
          modeItems: [
            {
              'title': 'Where',
              'description': '''
&&lib/playground/onboarding/assets/animations/multiplatform.json&&
Our virtual assistant is +highly adaptable+ and can seamlessly integrate into +any type of application+, whether it's native, developed with +Flutter+, or deployed on web platforms. This flexibility allows the assistant to be easily incorporated into diverse technological environments without disrupting your existing system infrastructure, making it an optimal solution for businesses operating on +multiple platforms+.

For companies in the +process of digital expansion+, the assistant's smooth integration across new platforms ensures scalability without compatibility issues or the need for extensive redevelopment. This adaptability not only saves time and resources but also supports your business as it grows, providing a +future-proof+ solution that meets the evolving demands of your digital ecosystem.


## V 1.0.0 - 08/12/2024 ##

**Flutter App**
vvlib/playground/onboarding/assets/videos/apps/flutter.mp4vv

**Android App**
vvlib/playground/onboarding/assets/videos/apps/android.mp4vv

**IOS App**
vvlib/playground/onboarding/assets/videos/apps/ios.mp4vv

**Web App**
vvlib/playground/onboarding/assets/videos/apps/web.mp4vv


'''
            },
            {
              'title': 'How To Install',
              'description': '''
&&lib/playground/onboarding/assets/animations/Animation_files.json&&
Integrating our virtual assistant into your project is a +straightforward and efficient+ process, designed to minimize complexity while ensuring robust functionality. For Flutter applications, simply +copy our specialized folder+ into your project and ensure that you +install the necessary dependencies+ via the Flutter package manager. This approach allows for quick setup and seamless integration, making the assistant readily available within your Flutter environment.

For native Android or iOS applications, our module can be implemented using +Flutter's platform channels+, which enable +smooth communication+ between native code and Dart. This ensures that the assistant can interact with native functionalities, providing a cohesive experience across platforms. When integrating into web platforms, you can utilize +Flutter Web+, allowing you to +compile the project into HTML, JavaScript, and CSS+ for efficient operation in web browsers. This transforms the assistant into a +web application+ that can be hosted on +any standard server+ or easily integrated into existing websites, offering flexibility and broad accessibility.

For a detailed guide on embedding Flutter apps into native or web applications, please refer to Flutter's official documentation. Additionally, we offer installation and maintenance services to ensure that the assistant functions optimally in your apps. For more information, feel free to contact us at **inappbot@inapp.bot**.



'''
            },
            {
              'title': 'Why Install It',
              'description': '''
&&lib/playground/onboarding/assets/animations/chat_ai.json&&
Integrating our virtual assistant is not just about +enhancing the efficiency+ of your applications; it's about +revolutionizing the way you engage with your users+. By providing +instant, personalized responses+, the assistant significantly improves the +user experience+, making interactions more meaningful and driving customer loyalty. This isn't just an upgrade—it's a transformation.

The assistant's adaptability across different platforms ensures a +consistent and effective solution+ for all your virtual assistance needs, whether on mobile, web, or native applications. This cross-platform functionality simplifies your technological management, allowing you to maintain a unified experience for users, while also +reducing operational costs+ by streamlining your support processes.

Imagine a world where your customers receive the support they need exactly when they need it, without the delays and frustrations of traditional customer service. By installing this virtual assistant, you're not just improving your service—you're +taking your customer experience to the next level+. Don't miss the opportunity to +future-proof your business+, enhance customer satisfaction, and position yourself as a leader in digital engagement.



'''
            },
          ],
          fromBottomNavigationBar: true,
          fromFloatingActionButton: true,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _createTransition(animation, child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  static SlideTransition _createTransition(
      Animation<double> animation, Widget child) {
    return SlideTransition(
      position: animation.drive(
          Tween(begin: const Offset(0.0, 0.5), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease))),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

class _FloatingActionButtonChild extends StatelessWidget {
  const _FloatingActionButtonChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _BackgroundImage(),
          Icon(Icons.add, color: Color(0xFFFFFFFF), size: 28),
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.5),
          BlendMode.darken,
        ),
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(
                  'lib/playground/onboarding/assets/images/logo_background.webp'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
