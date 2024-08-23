import 'dart:developer' as dev;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/game_play_screen.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/*
Here is the latest feature that we are adding to the game:
we should record the chain of squares by storing the cordinates of its top left corner in a list.

lets display a shadow while the squares are added by the current player

lets code:


 */

class GuiSquare extends PositionComponent with HasGameRef {
  final bool isMine;
  final Offset offsetFromTopLeftCorner;
  final double animationDuration = 40;
  final double animationEndSize = GameState!.globalOffset / 2;
  final double animationStartSize = GameState!.globalOffset / 4;
  final myXcord;
  final myYcord;

  static bool controlBool = false; //! this is the new static bool for the class to control the chain of squares

  double currentSize = 0.0;
  double velocity = 100.0;
  final IconData aiIcon = GameState!.iconSet[1];
  Color color = GameState!.colorSet[4];
  final IconData humanIcon = GameState!.iconSet.first;
  Color humanColor = Colors.green;
  double iconScale = 0.0;

  static final int levelId = gamePlayStateForGui!.currentLevel.id;

  GuiSquare({
    required this.isMine,
    required this.myXcord,
    required this.myYcord,
    this.offsetFromTopLeftCorner = const Offset(0, 0),
  }) : super(anchor: Anchor.center) {
    controlBool = isMine;
    currentSize = animationStartSize;
    size = Vector2(animationEndSize, animationEndSize);
    // incrementing the score in the gamestate!forGui when the square is created
    //decrementiing the squares value notifier when square is crreated
    gamePlayStateForGui!.squaresLeftNotifier.value--;
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

      if ((myScore > aiScore)) {
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
  }

  void _addParticle(int count, Vector2 position) {
    dev.log('Generating random particles');
    final random = Random();

    ParticleSystemComponent particleSystem = ParticleSystemComponent(
      priority: 0,
      particle: Particle.generate(
        count: count * 2,
        lifespan: 1,
        generator: (i) {
          final angle = random.nextDouble() * 2 * pi;
          final speedMagnitude = random.nextDouble() * 200;
          final gravity = Vector2(0, 100); // Simulate gravity downward

          return AcceleratedParticle(
            acceleration: Vector2(
              0, // No horizontal acceleration for gravity
              gravity.y * 2, // Apply gravity downward
            ),
            speed: Vector2(
              speedMagnitude * cos(angle),
              speedMagnitude * sin(angle),
            ),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final progress = particle.progress;
                final opacity = 1.0 - (progress > 0.6 ? progress : 0); // stat decrease opacity from 1.0 to 0
                final size = 1 + random.nextDouble() * 1.5; // Randomize size

                final position = this.position;
                randInt = random.nextInt(Colors.primaries.length);
                final paint = Paint()
                  ..color = Colors.primaries[randInt].withOpacity(opacity)
                  ..style = PaintingStyle.fill;

                canvas.drawCircle(position.toOffset(), size, paint);
              },
              // child: CircleParticle(
              //   radius: 1 + random.nextDouble() * 0.5,
              //   paint: Paint()..color = Colors.primaries[random.nextInt(Colors.primaries.length)].withOpacity(0.5),
              // ),
              // // Use a ComputedParticle to dynamically calculate the scale
              // computer: (particle, delta) {
              //   final progress = particle.progress;
              //   return ScaledParticle(
              //     scale: 1.0 - progress, // Gradually decrease scale from 1.0 to 0
              //     child: particle.child,
              //   );
              // },
            ),
          );
        },
      ),
      position: position,
    );

    add(particleSystem);
  }

  void _showStar(int chainCount) async {
    if (soundEnabled) AudioPlayer().play(AssetSource('audio/newstar.wav')); //dot touch sound matches the square creation thats why im using it

    dev.log('Generating star particles');
    final random = Random();
    final sprite = await Sprite.load('star.png');
    final position = Offset(
      (myXcord.toDouble() * GameState!.globalOffset) + (GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare),
      (myYcord.toDouble() * GameState!.globalOffset) + GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare,
    );

    Vector2 randomVector2() => (Vector2.random(random) - Vector2.random(random)) * 80;
    final gravity = Vector2(0, 200); // Gravity vector, adjust as needed

    ParticleSystemComponent particleSystem = ParticleSystemComponent(
      priority: 0,
      particle: Particle.generate(
        count: chainCount,
        lifespan: chainCount / 3, // Increased lifespan to make gravity effect more noticeable
        generator: (i) {
          return AcceleratedParticle(
            speed: randomVector2(),
            acceleration: gravity / 2,
            child: RotatingParticle(
              to: random.nextDouble() * pi * 2,
              child: ComputedParticle(
                renderer: (canvas, particle) {
                  sprite.render(
                    canvas,
                    size: Vector2.all(40) * (1 - particle.progress), // Slower shrinking
                    anchor: Anchor.center,
                    overridePaint: Paint()
                      ..color = Colors.white.withOpacity(
                        1 - particle.progress,
                      ),
                  );
                },
              ),
            ),
          );
        },
      ),
      position: position.toVector2(),
    );

    add(particleSystem);
  }

  static const loundness = 0.6;
  @override
  void onLoad() {
    if (((GameState!.chainCount + 1) % 4) == 0) {
      dev.log('Showing star particles for chain count: ${GameState!.chainCount}');

      _showStar(GameState!.chainCount);
    }

    if (soundEnabled) AudioPlayer().play(AssetSource('audio/dot_touch.wav')); //dot touch sound matches the square creation thats why im using it
    //we will use switch case on the chain count to play the sound
    if (GameState!.myTurn && soundEnabled) {
      GameState!.chainCount++;

      final positionOffset = Offset(
        (myXcord.toDouble() * GameState!.globalOffset) + (GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare),
        (myYcord.toDouble() * GameState!.globalOffset) + GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare,
      );

      if (GameState!.chainCount > 1) {
        _addParticle(GameState!.chainCount, positionOffset.toVector2());
        audioService.playSquareSfx(GameState!.chainCount);
      }
    }

    super.onLoad();
  }

  static late final AudioCache audioCache = AudioCache(
    prefix: 'audio/',
  );

  int colorChangeInterval = 19;

  static int randInt = 0;

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

    //randomized the colors of the shadow

    shadowPaint.color = colorChangeCounter;

    shadowPaint.style = PaintingStyle.fill;
    // Update the icon scale
    iconScale = (currentSize - animationStartSize) / (animationEndSize - animationStartSize);
  }

  Paint shadowPaint = Paint()..maskFilter = MaskFilter.blur(BlurStyle.normal, 1); // Add blur effect

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate the position offset based on the provided coordinates.. 100 adjusts everything
    final positionOffset = Offset(
      (myXcord.toDouble() * GameState!.globalOffset) + (GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare),
      (myYcord.toDouble() * GameState!.globalOffset) + GameState!.offsetFromTopLeftCorner * GameState!.offsetFactoForSquare,
    );

    if (!expired) {
      if (!(isMine ^ controlBool)) {
        final shadowPath = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: positionOffset + Offset(5, 5),
                width: currentSize,
                height: currentSize,
              ),
              const Radius.circular(10.0),
            ),
          );

        canvas.drawPath(shadowPath, shadowPaint);
      } else {
        expired = true;
      }
    }
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

  bool expired = false;
}

Color colorChangeCounter = Colors.primaries[Random().nextInt(Colors.primaries.length)];
