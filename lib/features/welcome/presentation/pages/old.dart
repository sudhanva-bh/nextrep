// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:nextrep/core/constants/file_paths.dart';
// import 'package:nextrep/core/theme/app_palette.dart';
// import 'package:nextrep/features/welcome_screen/presentation/widgets/cut_out_text.dart';
// import 'package:nextrep/features/welcome_screen/presentation/widgets/non_cut_out_text.dart';

// class WelcomePage extends StatefulWidget {
//   const WelcomePage({super.key});

//   @override
//   State<WelcomePage> createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage>
//     with SingleTickerProviderStateMixin {
//   int count = 0;
//   String attribute = "";
//   double fontSize = 40.0;

//   List<String> attributes = [
//     'Strength',
//     'Discipline',
//     'Endurance',
//     'Agility',
//     'Power',
//     'Focus',
//     'Drive',
//     'Stamina',
//     'Flexibility',
//     'Grit',
//     'Speed',
//     'Control',
//     'Precision',
//     'Determination',
//     'Persistence',
//     'Balance',
//     'Mobility',
//     'Recovery',
//     'Adaptability',
//     'Consistency',
//     'Courage',
//     'Execution',
//     'Effort',
//     'Resilience',
//     'Tenacity',
//     'Mindset',
//     'Commitment',
//     'Momentum',
//     'Intensity',
//     'Greatness',
//   ];

//   late AnimationController controller;
//   late Animation<double> scaleAnimation;
//   late Animation<Offset> offsetAnimation;

//   @override
//   void initState() {
//     controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     );
//     scaleAnimation = Tween<double>(
//       begin: 1,
//       end: 100,
//     ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
//     offsetAnimation =
//         Tween<Offset>(
//           begin: Offset(0, 0),
//           end: Offset(0, -0.26),
//         ).animate(
//           CurvedAnimation(
//             parent: controller,
//             curve: Interval(
//               0,
//               0.2,
//               curve: Curves.easeInOut,
//             ),
//           ),
//         );

//     super.initState();
//     animate();
//   }

//   Future<void> animate() async {
//     for (int i = 0; i < attributes.length; i++) {
//       setState(() {
//         attribute = attributes[i];
//         fontSize += i / 15;
//       });
//       await Future.delayed(Duration(milliseconds: (2000 / (i + 1)).round()));
//     }
//     await Future.delayed(Duration(milliseconds: (2000)));
//     controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               FilePaths.welcomeImage,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppPalette.background,
//                     AppPalette.transparent,
//                     AppPalette.transparent,
//                     AppPalette.background,
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   stops: [0, .19, .65, 1],
//                 ),
//               ),
//             ),
//           ),
//           SafeArea(
//             child: ScaleTransition(
//               scale: scaleAnimation,
//               child: SlideTransition(
//                 position: offsetAnimation,
//                 child: Center(
//                   child: Flex(
//                     direction: Axis.vertical,
//                     children: [
//                       Expanded(
//                         flex: 8,
//                         child: SizedBox(),
//                       ),
//                       Column(
//                         children: [
//                           NonCutOutText(
//                             text: attribute,
//                             fontSize: fontSize,
//                           ),
//                           NonCutOutText(text: "lives in the"),
//                           Stack(
//                             children: [
//                               Center(
//                                 child: Container(
//                                   height: 60,
//                                   width: 15,
//                                   color: AppPalette.background,
//                                 ),
//                               ),
//                               Center(
//                                 child: CutOutText(
//                                   text: 'NextRep',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: SizedBox(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }