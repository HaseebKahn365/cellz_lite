import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/business_logic/point.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/game_play_screen.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GuiLine extends PositionComponent with HasGameRef {
  final Point firstPoint;
  final Point secondPoint;
  double glowDoubleValue = 0;
  bool increasingGlow = true;
  double lineWidth = 2.0;
  double animationProgress = GameState!.myTurn ? 0.4 : 0;

  static bool controlBool = true;

  late bool imNew;
  bool expired = false;

  GuiLine({required this.firstPoint, required this.secondPoint}) {
    priority = 0;
    print('Received points: ${firstPoint.location} and ${secondPoint.location}');
    _calculateLinePositionAndSize();
    controlBool = GameState!.myTurn;
    imNew = controlBool;
    anchor = Anchor.topLeft;
    //lets decrement the moves when line is created
    gamePlayStateForGui!.decrementMovesLeft();
  }

  final Color newColor = GameState!.colorSet[6];
  final Color oldColor = GameState!.colorSet[7];

  void _calculateLinePositionAndSize() {
    _start = Offset(firstPoint.xCord * GameState!.globalOffset + GameState!.offsetFromTopLeftCorner / 2, firstPoint.yCord * GameState!.globalOffset + GameState!.offsetFromTopLeftCorner / 2);
    _end = Offset(secondPoint.xCord * GameState!.globalOffset + GameState!.offsetFromTopLeftCorner / 2, secondPoint.yCord * GameState!.globalOffset + GameState!.offsetFromTopLeftCorner / 2);
  }

  Offset _start = Offset.zero;
  Offset _end = Offset.zero;

  final line = Paint()
    ..color = Colors.white
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final glowShadowLine = Paint()
    ..color = GameState!.colorSet[8]
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

  var animateLimit = 1.5;

  @override
  void update(double dt) {
    super.update(dt);

    // change the color of line
    if (!expired) {
      if ((controlBool && imNew) || (!controlBool && !imNew)) {
        line.color = newColor;
      } else {
        line.color = oldColor;
        expired = true;
      }
    }

    // Animate the line drawing
    if (animationProgress < 1.0) {
      animationProgress += dt * 2.7; // Adjust this value to control animation speed
      animationProgress = animationProgress.clamp(0.0, 1.0);
    }

    // Animate the line width
    if (line.strokeWidth < 10) {
      line.strokeWidth = (line.strokeWidth + (10 * dt)).clamp(2.0, 10.0);
    }

    // Animate the glow effect
    if (increasingGlow) {
      glowDoubleValue += 40 * dt; //the glow speed is adjusted here
      if (glowDoubleValue >= 10) {
        glowDoubleValue = 10;
        increasingGlow = false;
      }
    } else {
      glowDoubleValue -= 40 * dt;
      if (glowDoubleValue <= 0) {
        glowDoubleValue = 0;
        animateLimit--;
        increasingGlow = (animateLimit > 0);
      }
    }
    glowShadowLine.maskFilter = MaskFilter.blur(BlurStyle.normal, glowDoubleValue);
  }

  static late final AudioCache audioCache = AudioCache(
    prefix: 'audio/',
  );

  @override
  FutureOr<void> onLoad() {
    if (soundEnabled) {
      AudioPlayer().play(AssetSource('audio/line.wav'));
    }
    line.color = oldColor;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate the current end point of the animated line
    Offset currentEnd = Offset.lerp(_start, _end, animationProgress)!;

    // Draw the glow effect
    canvas.drawLine(_start, currentEnd, glowShadowLine);

    // Draw the line
    canvas.drawLine(_start, currentEnd, line);
  }
}
