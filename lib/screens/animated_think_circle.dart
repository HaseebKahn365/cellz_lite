import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/my_game.dart';
import 'package:flutter/material.dart';

class AnimatedScaleWidget extends StatefulWidget {
  @override
  _AnimatedScaleWidgetState createState() => _AnimatedScaleWidgetState();
}

class _AnimatedScaleWidgetState extends State<AnimatedScaleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      reverseDuration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scaleX: _animation.value,
          scaleY: 2,
          child: Container(
            height: 1,
            width: 50,
            color: GameState!.myTurn ? GameState!.colorSet[3] : GameState!.colorSet[4],
          ),
        );
      },
    );
  }
}
