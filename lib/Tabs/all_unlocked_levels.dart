import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/dealing_with_data/LevelStarts.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/game_play_screen.dart';
import 'package:cellz_lite/screens/my_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AllUnlockedLevels extends StatelessWidget {
  const AllUnlockedLevels({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Levels Journey'),
        forceMaterialTransparency: true,
      ),
      body: Column(
        children: [
          // add a close button
          // Padding(
          //   padding: const EdgeInsets.only(top: 50.0),
          //   child: OutlinedButton.icon(
          //     label: Text('Close'),
          //     icon: Icon(Icons.close),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                final isFirst = index == 0;
                final isLast = index == levels.length - 1;
                final isCurrent = level.id - 1 == userProvider.currentLevelIndex;
                final isPassed = level.id - 1 < userProvider.currentLevelIndex;
                final isExpanded = isCurrent || isPassed;
                final LevelStarObject levelStar = levelStars[level.id - 1];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TimelineTile(
                    isFirst: isFirst,
                    isLast: isLast,
                    indicatorStyle: IndicatorStyle(
                      width: 30,
                      height: 30,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      indicator: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        child: Center(
                          child: isCurrent
                              ? Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                  ),
                                  child: Icon(
                                    Icons.circle,
                                    size: 15,
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  ),
                                )
                              : isPassed
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                                      size: 20,
                                    )
                                  : Icon(
                                      size: 15,
                                      Icons.lock_outline_rounded,
                                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                                    ),
                        ),
                      ),
                    ),
                    endChild: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          trailing: isCurrent || isPassed ? null : SizedBox.shrink(),
                          enabled: isCurrent || isPassed,
                          initiallyExpanded: isExpanded,
                          childrenPadding: const EdgeInsets.all(0),
                          title: Row(
                            children: [
                              Text(
                                'Level ${level.id}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),

                              Spacer(),

                              //creating stars for the level
                              (isPassed || isCurrent)
                                  ? Stack(
                                      children: [
                                        ...[
                                          Row(
                                            children: [
                                              //this row will contain the filled stars
                                              for (int i = 0; i < levelStar.stars; i++)
                                                Icon(
                                                  Icons.star,
                                                  color: Theme.of(context).colorScheme.primary,
                                                  size: 25,
                                                ),
                                            ],
                                          ),
                                          Row(
                                            //this row will contain the empty stars
                                            children: [
                                              for (int i = 0; i < 3; i++)
                                                Icon(
                                                  Icons.star_border_rounded,
                                                  color: Theme.of(context).colorScheme.primary,
                                                  size: 25,
                                                ),
                                            ],
                                          ),
                                        ]
                                      ],
                                    )
                                  : SizedBox.shrink(),
                              Spacer(),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(children: [
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Grid ${level.xPoints}x${level.yPoints}',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Hard? - ${level.grade}',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),

                                            //adding time
                                            const SizedBox(height: 5),
                                            Text(
                                              '${levelStar.time} s',
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ],
                                  ),
                                  //add a play button

                                  InkWell(
                                    //the inkwell shows an ugly container when tapped. lets fix that

                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      if (!userProvider.hasLives()) {
                                        showDialog(
                                          barrierColor: Colors.black.withOpacity(0.8),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              titlePadding: const EdgeInsets.all(0),
                                              contentPadding: const EdgeInsets.all(0),
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
                                                      const Text(
                                                        'No Lives Left',
                                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(
                                                        width: 350,
                                                        height: 150,
                                                        child: RiveAnimation.asset(
                                                          'assets/images/cute_heart_broken.riv',
                                                          fit: BoxFit.cover,
                                                          antialiasing: true,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 16),
                                                      const Text('You have no lives left. Would you like to get more?'),
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
                                                            child: const Text('Get Lives'),
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

                                      Future.delayed(const Duration(seconds: 1), () {
                                        //Creating instances of Global States
                                        userProvider.decrementLives();
                                      });

                                      //Creating instances of Global States
                                      GameState = GameStateClass();
                                      gamePlayStateForGui = GamePlayStateForGui();
                                      //make sure to reset the scores and stuff before game start
                                      gamePlayStateForGui!.resetGame();
                                      //use material route to navigate to the game play screen

                                      gamePlayStateForGui!.currentLevel = level;

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
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.4), width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.2)),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.play_arrow,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          Text(
                                            'Play',
                                            style: Theme.of(context).textTheme.bodyMedium,
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
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                          angle: 45,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            //lets create a grid for the level
                            Grid(level: level),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Grid extends StatelessWidget {
  const Grid({
    super.key,
    required this.level,
  });

  final LevelObject level;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: (15 * level.xPoints).toDouble(),
        height: (15 * level.yPoints).toDouble(),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: level.xPoints,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: 1, // Ensure square cells
          ),
          itemCount: level.xPoints * level.yPoints,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).colorScheme.surfaceDim,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 5,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
