import 'dart:math';

import 'package:flutter/material.dart';

class FunkyLevelsRadial extends StatelessWidget {
  final int currentLevel;
  final int totalLevels;
  final double diameter;
  final Color progressColor;
  final Color backgroundColor;
  final Color centerColor;
  final List<LabelData> labels;
  final TextStyle levelTextStyle;
  final TextStyle subtitleTextStyle;
  final TextStyle labelTextStyle;
  final double progressWidth;
  final double backgroundWidth;
  final double labelOffset;

  FunkyLevelsRadial({
    Key? key,
    required this.currentLevel,
    this.totalLevels = 65,
    this.diameter = 300,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.centerColor = Colors.white,
    this.labels = const [],
    this.levelTextStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    this.subtitleTextStyle = const TextStyle(fontSize: 14),
    this.labelTextStyle = const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    this.progressWidth = 10,
    this.backgroundWidth = 10,
    this.labelOffset = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = currentLevel / totalLevels;

    return Container(
      width: diameter,
      height: diameter,
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(
                startAngle: degToRad(180),
                endAngle: degToRad(360),
                colors: [progressColor, progressColor.withOpacity(0.3)],
                stops: [progress, progress],
              ).createShader(rect);
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: CustomArc(
                  diameter: diameter - 60,
                  backgroundColor: backgroundColor,
                  backgroundWidth: backgroundWidth,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: diameter - 100, //radius of the center circle
              height: diameter - 100,
              decoration: BoxDecoration(
                color: centerColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    spreadRadius: 5,
                    color: progressColor.withOpacity(0.2),
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Level $currentLevel', style: levelTextStyle),
                  SizedBox(height: 10),
                  Text('Complete all levels', style: subtitleTextStyle),
                  Text('to win \$100!', style: subtitleTextStyle),
                ],
              ),
            ),
          ),
          ...labels.map((label) => _buildLabelText(label)),
        ],
      ),
    );
  }

  Widget _buildLabelText(LabelData label) {
    final double radians = degToRad(label.angle + 180);
    final double x = cos(radians) * (diameter / 2 - labelOffset);
    final double y = sin(radians) * (diameter / 2 - labelOffset);

    return Positioned(
      left: diameter / 2 + x - 5,
      top: diameter / 2 + y - 5,
      child: Text(label.text, style: labelTextStyle),
    );
  }
}

class CustomArc extends StatelessWidget {
  final double diameter;
  final Color backgroundColor;
  final double backgroundWidth;

  CustomArc({
    required this.diameter,
    required this.backgroundColor,
    required this.backgroundWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomArcPainter(
        backgroundColor: backgroundColor,
        backgroundWidth: backgroundWidth,
      ),
      size: Size(diameter, diameter),
    );
  }
}

class CustomArcPainter extends CustomPainter {
  final Color backgroundColor;
  final double backgroundWidth;

  CustomArcPainter({
    required this.backgroundColor,
    required this.backgroundWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = backgroundWidth
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2 - 2),
      pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LabelData {
  final double angle;
  final String text;

  LabelData(this.angle, this.text);
}

double degToRad(num deg) => deg * (pi / 180.0);
