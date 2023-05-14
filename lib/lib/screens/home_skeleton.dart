import 'package:flutter/material.dart';

class HomeSkeleton extends StatefulWidget {
  const HomeSkeleton({super.key});

  @override
  State<HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends State<HomeSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation gradientPosition;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
        setState(() {});
      });

    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomeSkeletonWidget();
  }

  Widget _buildHomeSkeletonWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            width: 250,
            height: 40,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(gradientPosition.value, 0),
                end: const Alignment(-1, 0),
                colors: [Colors.grey.shade200, Colors.grey.shade100, Colors.grey.shade200],
              ),
            ),
          ),
          Container(
            width: 150,
            height: 20,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(gradientPosition.value, 0),
                end: const Alignment(-1, 0),
                colors: [Colors.grey.shade200, Colors.grey.shade100, Colors.grey.shade200],
              ),
            ),
          ),
          Container(
            width: 150,
            height: 100,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(gradientPosition.value, 0),
                end: const Alignment(-1, 0),
                colors: [Colors.grey.shade200, Colors.grey.shade100, Colors.grey.shade200],
              ),
            ),
          ),
          Container(
            width: 150,
            height: 20,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(gradientPosition.value, 0),
                end: const Alignment(-1, 0),
                colors: [Colors.grey.shade200, Colors.grey.shade100, Colors.grey.shade200],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
