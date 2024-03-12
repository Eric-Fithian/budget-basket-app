import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3), // Adjust duration to fit your needs
      vsync: this,
    );

    // Create a looping animation
    _animation = Tween<double>(begin: 0.1, end: .8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuint,
      ),
    )..addListener(() {
        setState(() {
          // Force rebuild to update position based on animation
        });
      });

    _animationController.repeat(); // Start the animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate screen width
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate icon's horizontal position
    final iconPosition = _animation.value * screenWidth;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 2 +
                12, // Center vertically with offset for the line's thickness
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 2, // Thick line height
              color: Colors.black, // Line color
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 -
                24, // Adjust vertical position to center the icon on the line
            left: iconPosition,
            child: Icon(
              PhosphorIcons.regular.shoppingCart,
              size: 36,
              color: Colors.black, // Icon color
            ),
          ),
        ],
      ),
    );
  }
}
