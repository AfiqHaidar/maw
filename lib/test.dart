// import 'package:flutter/material.dart';
// import 'package:expandable/expandable.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const SlidingWidgetDemo(),
//     );
//   }
// }

// class SlidingWidgetDemo extends StatelessWidget {
//   const SlidingWidgetDemo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Smooth Expandable Sliding Widget'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               SmoothExpandableSlidingWidget(
//                 buttonColor: Color(0xFF8A56FF), // Purple
//                 contentColor: Color(0xFFF94AAD), // Pink
//                 icon: Icons.bolt,
//                 label: 'content',
//               ),
//               SizedBox(height: 40),
//               Text('Tap the button to expand/collapse'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SmoothExpandableSlidingWidget extends StatefulWidget {
//   final Color buttonColor;
//   final Color contentColor;
//   final IconData icon;
//   final String label;

//   const SmoothExpandableSlidingWidget({
//     Key? key,
//     required this.buttonColor,
//     required this.contentColor,
//     required this.icon,
//     required this.label,
//   }) : super(key: key);

//   @override
//   State<SmoothExpandableSlidingWidget> createState() =>
//       _SmoothExpandableSlidingWidgetState();
// }

// class _SmoothExpandableSlidingWidgetState
//     extends State<SmoothExpandableSlidingWidget>
//     with SingleTickerProviderStateMixin {
//   late ExpandableController _expandableController;
//   late AnimationController _animationController;
//   late Animation<double> _slideAnimation;
//   late Animation<double> _colorAnimation;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _expandableController = ExpandableController(initialExpanded: false);

//     // Setup animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );

//     // Setup animations
//     _slideAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
//     );

//     _colorAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutQuart,
//     );

//     _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.3, 1.0, curve: Curves.easeOutQuart),
//       ),
//     );

//     // Link expandable controller with animation controller
//     _expandableController.addListener(() {
//       if (_expandableController.expanded) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _expandableController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final maxWidth =
//         MediaQuery.of(context).size.width - 40; // Accounting for padding

//     return ExpandableNotifier(
//       controller: _expandableController,
//       child: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           // Calculate interpolated color
//           final color = Color.lerp(
//             widget.buttonColor,
//             widget.contentColor,
//             _colorAnimation.value,
//           );

//           return Container(
//             width: maxWidth,
//             height: 70,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(35),
//               color: color,
//             ),
//             child: Stack(
//               children: [
//                 // Content
//                 Positioned(
//                   left: 90,
//                   right: 20,
//                   top: 0,
//                   bottom: 0,
//                   child: Opacity(
//                     opacity: _opacityAnimation.value,
//                     child: Center(
//                       child: Text(
//                         widget.label,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Button
//                 Positioned(
//                   left: _slideAnimation.value * (maxWidth - 70),
//                   top: 0,
//                   child: GestureDetector(
//                     onTap: () => _expandableController.toggle(),
//                     child: Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                         color: widget.buttonColor,
//                         borderRadius: BorderRadius.circular(35),
//                         boxShadow: _colorAnimation.value > 0
//                             ? [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ]
//                             : null,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           widget.icon,
//                           color: Colors.orange,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
