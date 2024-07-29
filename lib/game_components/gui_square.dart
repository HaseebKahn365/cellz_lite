import 'dart:developer' as dev;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/game_play_screen.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class GuiSquare extends PositionComponent {
  final bool isMine;
  final Offset offsetFromTopLeftCorner;
  final double animationDuration = 40;
  final double animationEndSize = GameState!.globalOffset / 2;
  final double animationStartSize = GameState!.globalOffset / 4;
  final myXcord;
  final myYcord;

  double currentSize = 0.0;
  double velocity = 100.0;
  final IconData aiIcon = GameState!.iconSet[1];
  Color color = GameState!.colorSet[4];
  final IconData humanIcon = GameState!.iconSet.first;
  Color humanColor = Colors.green;
  double iconScale = 0.0;

  GuiSquare({
    required this.isMine,
    required this.myXcord,
    required this.myYcord,
    this.offsetFromTopLeftCorner = const Offset(0, 0),
  }) : super(anchor: Anchor.center) {
    currentSize = animationStartSize;
    size = Vector2(animationEndSize, animationEndSize);
    // incrementing the score in the gamestate!forGui when the square is created
    if (isMine) {
      gamePlayStateForGui!.incrementPlayerOneScore();
    } else {
      gamePlayStateForGui!.incrementPlayerTwoScore();
    }

    if (gamePlayStateForGui!.checkGameOver() && soundEnabled) {
      //check in the map of squares where isMine == true;
      final myScore = gamePlayStateForGui!.playerOneScoreNotifier.value;
      final aiScore = gamePlayStateForGui!.playerTwoScoreNotifier.value;

      dev.log('Game Over: My Score: $myScore, AI Score: $aiScore');

      if (myScore > aiScore) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          AudioPlayer().play(AssetSource('audio/you_win.wav'));
        });
      } else if (myScore < aiScore) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          AudioPlayer().play(AssetSource('audio/you_lose.wav'));
        });
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          AudioPlayer().play(AssetSource('audio/tie.wav'));
        });
      }
    }

    if (gamePlayStateForGui!.currentLevel.id < 3) {
      AudioPlayer().play(AssetSource('audio/${GameState!.allSquares.length}.wav'));
    }
  }

  void _addParticle(int count, Vector2 position) {
    dev.log('Generating random particles');
    final random = Random();
    ParticleSystemComponent particleSystem = ParticleSystemComponent(
      priority: 0,
      particle: Particle.generate(
        count: count * 5, // Increase count for more drops
        //rand between 0.5 and 2.5
        lifespan: 0.5 + random.nextDouble() * 1.0,
        generator: (i) {
          // Randomize direction for acceleration and speed
          final angle = random.nextDouble() * 2 * pi;
          final speedMagnitude = random.nextDouble() * 200;
          //lets also make it negative randomly
          final accelerationMagnitude = random.nextDouble() * 100 * (random.nextBool() ? 1 : -1);

          return AcceleratedParticle(
            acceleration: Vector2(
              accelerationMagnitude * cos(angle),
              accelerationMagnitude * sin(angle),
            ),
            speed: Vector2(
              speedMagnitude * cos(angle),
              speedMagnitude * sin(angle),
            ),
            child: CircleParticle(
              radius: 1 + random.nextDouble() * 0.5, // Increase radius for larger, more drop-like particles
              paint: Paint()..color = Colors.primaries[random.nextInt(Colors.primaries.length)].withOpacity(0.5), // Change color to colorful
            ),
          );
        },
      ),
      position: position,
    );

    add(particleSystem);
  }

  @override
  void onLoad() {
    if (soundEnabled) AudioPlayer().play(AssetSource('audio/square.wav'));
    //we will use switch case on the chain count to play the sound
    if (GameState!.myTurn && soundEnabled) {
      GameState!.chainCount++;

      final positionOffset = Offset(
        (myXcord.toDouble() * GameState!.globalOffset) + (GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare),
        (myYcord.toDouble() * GameState!.globalOffset) + GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare,
      );

      if (GameState!.chainCount > 1) {
        if (GameState!.chainCount == 2) {
          AudioPlayer().play(AssetSource('audio/2.wav'));
          _addParticle(1, positionOffset.toVector2());
        } else if (GameState!.chainCount == 3) {
          AudioPlayer().play(AssetSource('audio/3.wav'));
          _addParticle(2, positionOffset.toVector2());
        } else if (GameState!.chainCount == 4) {
          AudioPlayer().play(AssetSource('audio/4.wav'));
          _addParticle(3, positionOffset.toVector2());
        } else if (GameState!.chainCount == 5) {
          AudioPlayer().play(AssetSource('audio/5.wav'));
          _addParticle(4, positionOffset.toVector2());
        } else if (GameState!.chainCount == 6) {
          AudioPlayer().play(AssetSource('audio/6.wav'));
          _addParticle(5, positionOffset.toVector2());
        } else if (GameState!.chainCount == 7) {
          AudioPlayer().play(AssetSource('audio/7.wav'));
          _addParticle(6, positionOffset.toVector2());
        } else if (GameState!.chainCount == 8) {
          AudioPlayer().play(AssetSource('audio/8.wav'));
          _addParticle(7, positionOffset.toVector2());
        } else if (GameState!.chainCount == 9) {
          AudioPlayer().play(AssetSource('audio/9.wav'));
          _addParticle(8, positionOffset.toVector2());
        } else if (GameState!.chainCount == 10) {
          AudioPlayer().play(AssetSource('audio/10.wav'));
          _addParticle(9, positionOffset.toVector2());
        } else {
          AudioPlayer().play(AssetSource('audio/combo.wav'));
          _addParticle(10, positionOffset.toVector2());
        }
      }
    }

    super.onLoad();
  }

  static late final AudioCache audioCache = AudioCache(
    prefix: 'audio/',
  );

  @override
  void update(double dt) {
    super.update(dt);

    // Apply a spring-like force to create a bounce effect
    final acceleration = (animationEndSize - currentSize) * animationDuration;
    velocity += acceleration * dt;
    currentSize += velocity * dt;

    // Dampen the velocity to simulate friction
    velocity *= 0.9;

    // Clamp the size to prevent overshooting
    currentSize = currentSize.clamp(animationStartSize, animationEndSize);

    // Update the icon scale
    iconScale = (currentSize - animationStartSize) / (animationEndSize - animationStartSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate the position offset based on the provided coordinates.. 100 adjusts everything
    final positionOffset = Offset(
      (myXcord.toDouble() * GameState!.globalOffset) + (GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare),
      (myYcord.toDouble() * GameState!.globalOffset) + GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare,
    );

    // Draw the square
    final squarePaint = Paint()
      ..color = GameState!.colorSet[5]
      ..style = PaintingStyle.fill;

    final squareWithBorder = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: positionOffset,
            width: currentSize,
            height: currentSize,
          ),
          const Radius.circular(10.0),
        ),
      );

    canvas.drawPath(squareWithBorder, squarePaint);

    // Render the icon
    final textSpan = TextSpan(
      text: String.fromCharCode(
        isMine ? humanIcon.codePoint : aiIcon.codePoint,
      ),
      style: TextStyle(
        fontSize: (GameState!.globalOffset / 3) * iconScale, // Scale the font size based on the icon scale
        fontFamily: (isMine ? aiIcon.fontFamily : humanIcon.fontFamily),
        package: isMine ? humanIcon.fontPackage : aiIcon.fontPackage,
        color: isMine ? humanColor : color,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    final relativePosition = Vector2(-textPainter.width / 2, -textPainter.height / 2) + positionOffset.toVector2(); // Center the icon and adjust for the position offset

    textPainter.paint(canvas, relativePosition.toOffset());
  }
}
