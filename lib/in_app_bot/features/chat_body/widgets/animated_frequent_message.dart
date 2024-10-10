// This is an animated widget for frequent messages.
// To use this code, replace buildFrequentMessagesButton in chat_body_widgets.dart with the following code:



// class AnimatedFrequentMessagesButton extends StatefulWidget {
//   final VoidCallback onTap;

//   const AnimatedFrequentMessagesButton({Key? key, required this.onTap})
//       : super(key: key);

//   @override
//   AnimatedFrequentMessagesButtonState createState() =>
//       AnimatedFrequentMessagesButtonState();
// }

// class AnimatedFrequentMessagesButtonState
//     extends State<AnimatedFrequentMessagesButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 60),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: Container(
//           height: 80,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 47, 47, 47),
//                 Color.fromARGB(255, 46, 46, 46)
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: AnimatedBuilder(
//                     animation: _controller,
//                     builder: (_, __) => CustomPaint(
//                       painter: BubblePainter(_controller.value),
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Frequent Messages',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         letterSpacing: 0.5,
//                         shadows: [
//                           Shadow(
//                             offset: const Offset(0, 2),
//                             blurRadius: 4,
//                             color: Colors.black.withOpacity(0.3),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BubblePainter extends CustomPainter {
//   final double animation;

//   BubblePainter(this.animation);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color.fromARGB(255, 98, 98, 98).withOpacity(0.1)
//       ..style = PaintingStyle.fill;

//     final textPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//     );

//     List<Bubble> bubbles = [
//       Bubble(0.3, 0.5, 10),
//       Bubble(0.5, 0.2, 20),
//       Bubble(0.7, 0.7, 15),
//       Bubble(0.9, 0.4, 12),
//     ];

//     for (var bubble in bubbles) {
//       final offset = Offset(
//         (bubble.x + sin(animation * 2 * pi + bubble.x * pi) * 0.85) *
//             size.width,
//         (bubble.y + cos(animation * 2 * pi + bubble.y * pi) * 0.95) *
//             size.height,
//       );
//       canvas.drawCircle(offset, bubble.radius, paint);

//       // Add question mark
//       textPainter.text = TextSpan(
//         text: '?',
//         style: TextStyle(
//           color: const Color.fromARGB(255, 99, 99, 99).withOpacity(0.6),
//           fontSize: bubble.radius * 1.2,
//           fontWeight: FontWeight.bold,
//         ),
//       );
//       textPainter.layout();
//       textPainter.paint(
//         canvas,
//         Offset(
//           offset.dx - textPainter.width / 2,
//           offset.dy - textPainter.height / 2,
//         ),
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

// class Bubble {
//   final double x;
//   final double y;
//   final double radius;

//   Bubble(this.x, this.y, this.radius);
// }

// Widget buildFrequentMessagesButton(
//   BuildContext context,
//   TextEditingController textEditingController,
//   String appUserId,
//   ChatbotService chatbotService,
//   WidgetRef ref,
//   SendMessageGptService sendmessagegptService,
// ) {
//   return AnimatedFrequentMessagesButton(
//     onTap: () {
//       showFrequentMessagesBottomSheet(context, textEditingController, appUserId,
//           chatbotService, ref, sendmessagegptService);
//     },
//   );
// }