// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   Tween<double> _tween = Tween(begin: 0.6, end: 1);
//   var _init = true;
//   @override
//   void didChangeDependencies() {
//     if (_init) {
//       _controller = AnimationController(
//         duration: const Duration(milliseconds: 600),
//         vsync: this,
//       )..repeat(reverse: true);

//       _init = false;
//     }
//     super.didChangeDependencies();
//   }

//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //_controller.repeat();
    
//     return Scaffold(backgroundColor: Colors.grey.shade900,
//       body: Center(
//         child: ScaleTransition(
//             scale: _tween.animate(
//                 CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn)),
//             child: Image.asset(
//               'assets/Logo2.png',
//               fit: BoxFit.fill,
//               height: 72,
//             )),
//       ),
//     );
//   }
// }
