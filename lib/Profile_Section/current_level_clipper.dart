import 'package:audioplayers/audioplayers.dart';
import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/game_play_screen.dart';
import 'package:cellz_lite/screens/my_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as riv;

class PointsClipper extends CustomClipper<Path> {
  final int waves;
  final double amplitude;

  PointsClipper({this.waves = 5, this.amplitude = 15.0});

  @override
  Path getClip(Size size) {
    Path path = Path();
    double width = size.width;
    double height = size.height;
    double waveWidth = width / waves;
    double waveHeight = height / waves;

    // Top edge
    path.moveTo(0, amplitude);
    for (int i = 0; i < waves * 2; i++) {
      double x = waveWidth * i / 2;
      double y = i % 2 == 0 ? 0 : amplitude * 2;
      path.quadraticBezierTo(x + waveWidth / 4, y, x + waveWidth / 2, amplitude);
    }

    // Right edge
    for (int i = 0; i < waves * 2; i++) {
      double x = width - (i % 2 == 0 ? 0 : amplitude * 2);
      double y = waveHeight * i / 2;
      path.quadraticBezierTo(x, y + waveHeight / 4, width - amplitude, y + waveHeight / 2);
    }

    // Bottom edge
    for (int i = waves * 2; i > 0; i--) {
      double x = waveWidth * i / 2;
      double y = height - (i % 2 == 0 ? 0 : amplitude * 2);
      path.quadraticBezierTo(x - waveWidth / 4, y, x - waveWidth / 2, height - amplitude);
    }

    // Left edge
    for (int i = waves * 2; i > 0; i--) {
      double x = i % 2 == 0 ? 0 : amplitude * 2;
      double y = waveHeight * i / 2;
      path.quadraticBezierTo(x, y - waveHeight / 4, amplitude, y - waveHeight / 2);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CurrentLevelContainer extends StatelessWidget {
  const CurrentLevelContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final currentLevel = levels[userProvider.currentLevelIndex];
        return ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: ClipPath(
            clipper: PointsClipper(waves: 10, amplitude: 3),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You\'re at Level',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          currentLevel.id.toString(),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                      Spacer(),

                      //adding colums to show the details of the level
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Grid: ' + currentLevel.xPoints.toString() + ' x ' + currentLevel.yPoints.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            currentLevel.grade!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),

                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          if (!userProvider.hasLives()) {
                            showDialog(
                              barrierColor: Colors.black.withOpacity(0.8),
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  titlePadding: EdgeInsets.all(0),
                                  contentPadding: EdgeInsets.all(0),
                                  actionsPadding: EdgeInsets.all(0),
                                  content: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2.0),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'No Lives Left',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 350,
                                            height: 150,
                                            child: riv.RiveAnimation.asset(
                                              'assets/images/cute_heart_broken.riv',
                                              fit: BoxFit.cover,
                                              antialiasing: true,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text('You have no lives left. Would you like to get more?'),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              OutlinedButton(
                                                child: Text('Get Lives'),
                                                onPressed: () {
                                                  // Implement logic to get more lives
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                            return;
                          }

                          AudioPlayer().play(AssetSource('audio/play.wav'), volume: 0.4);

                          Future.delayed(Duration(seconds: 2), () {
                            //Creating instances of Global States
                            userProvider.decrementLives();
                          });

                          //Creating instances of Global States
                          GameState = GameStateClass();
                          gamePlayStateForGui = GamePlayStateForGui();
                          //make sure to reset the scores and stuff before game start
                          gamePlayStateForGui!.resetGame();
                          //use material route to navigate to the game play screen

                          final size = MediaQuery.of(context).size;
                          game = MyGame(
                            screenSize: size,
                            xP: gamePlayStateForGui!.currentLevel.xPoints,
                            yP: gamePlayStateForGui!.currentLevel.yPoints,
                          );
                          //random int generated from 0 to 2

                          GameState!.offsetFromTopLeftCorner = gamePlayStateForGui!.currentLevel.offsetFromTopLeftCorner;
                          GameState!.offsetFactoForSquare = gamePlayStateForGui!.currentLevel.offsetFactoForSquare;

                          //lets upload a new instance to the database. this will be a gameStartInsertion

                          GameState!.myTurn = true;
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => GamePlayScreen(
                                game: game!,
                                playerOneName: gamePlayStateForGui!.playerOneName,
                                playerTwoName: gamePlayStateForGui!.playerTwoName,
                              ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = 0.5;
                                const end = 1.0;
                                const curve = Curves.easeOutQuint;
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var scaleAnimation = animation.drive(tween);
                                return ScaleTransition(
                                  scale: scaleAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration: Duration(milliseconds: 1000),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.4), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: (Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.2)),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_arrow,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                'Play',
                                style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(), // This makes it loop indefinitely
                            )
                            .shimmer(
                              delay: const Duration(seconds: 1),
                              duration: const Duration(seconds: 1),
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              angle: 45,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HistoryElement extends StatelessWidget {
  const HistoryElement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalScore = userProvider.lastTotalScore;
    final score = userProvider.lastScore;

    if (score == 0 || score > totalScore) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 200, // Set a fixed width or adjust as needed
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Last Played',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              'Score: $score / $totalScore',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                double userRatio = totalScore == 0 ? 0.5 : score / totalScore;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: 13,
                    child: Stack(
                      children: [
                        LinearProgressIndicator(
                          value: 1,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          minHeight: 13,
                        ),
                        FractionallySizedBox(
                          widthFactor: userRatio,
                          child: Container(
                            height: 13,
                            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
