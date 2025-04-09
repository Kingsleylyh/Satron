import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoAnimation;
  late final AnimationController _textController;
  late final Animation<Offset> _textOffset;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    );
    _logoController.forward();

    // Text animation
    _textController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _textOffset = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
    });

    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget.child!),
            (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1DA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoAnimation,
              child: Image.asset(
                'assets/images/Logo.png',
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _textOffset,
              child: FadeTransition(
                opacity: _textOpacity,
                child: const Column(
                  children: [
                    Text(
                      "SATRON",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "The key of Malaysia",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
