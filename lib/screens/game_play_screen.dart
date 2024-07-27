/*

This is the screen where we will have the game play.

lets have to rows. 
the first row will act as an appbar
the second row will have the players containers

First row:
it will have the back button on the left

then a linear progress indicator in the center that will be filled with two colors of representing the scores of the two players.
In the progress indicator will update with the scores of the two players.
PlayerOne = Me ... color Primary
PlayerTwo = Opponent ... color Teritary
Here is how the color of the progress indicator will be:
if both players scores are 0 then the progress indicator will be grey
if either of the players have 0 then the player with non zero score will have the progress indicator filled with his color
else the progress indicator will be filled with the two colors in the ratio of the scores of the two players.

then a Zoom icon to adjust the zoom level of the game board

Second row:
A rounded corner container that will have the name of the player and his score in a colum. on the right will be his avatar
a mini container to display the remaining moves in game.
Another rounded corner container that will have the name of the player and his score in a colum. on the left will be his avatar

the rest of the scaffold will be the game board


 */

/*
Here is the data for demo:

PlayerOne = Me
score: 9
PlayerTwo = AI
score 2

remaining moves = 12



 */
import 'dart:developer';

import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/game_over_screen.dart';
import 'package:cellz_lite/screens/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

// ignore: must_be_immutable
class GamePlayScreen extends StatelessWidget {
  final String playerOneName;
  final String playerTwoName;
  final MyGame game;

  GamePlayScreen({
    Key? key,
    required this.playerOneName,
    required this.playerTwoName,
    required this.game,
  }) : super(key: key);

  bool isExpired = false;
  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(child: Text('Leave Game ?')),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 350,
                  height: 150,
                  child: RiveAnimation.asset(
                    'assets/images/cute_heart_broken.riv',
                    fit: BoxFit.cover,
                    antialiasing: true,
                  ),
                ),
                Text('\nYou will lose life!'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  gamePlayStateForGui!.resetGame();

                  Navigator.of(context).pop(true);
                },
                child: Text('Leave'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Keep Playing'),
              ),
            ],
          ),
        ) ??
        false;
  }

  //making sure to correct the colors of the game

  // final instead of using a solid 200 lets use 1/5 of the screen height

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 5;
    // level 29: 7x11 grid

    if (!gamePlayStateForGui!.isExpired) {
      GameState!.changeBGColor(Theme.of(context).colorScheme.surface);
      GameState!.changeLineColor(Theme.of(context).colorScheme.secondary);
      GameState!.changeDotColor(Theme.of(context).colorScheme.secondary);
      GameState!.changeHumanColor(Theme.of(context).colorScheme.primary);
      GameState!.changeAIColor(Theme.of(context).colorScheme.surface);
      GameState!.changeSquareIconBoxColor(Theme.of(context).colorScheme.secondaryContainer);
      GameState!.changeMostRecentLineColor(Theme.of(context).colorScheme.primary);
      GameState!.changeOldLineColor(Theme.of(context).colorScheme.secondary.withOpacity(0.8));
      GameState!.changeNewLineGlowColor(Theme.of(context).colorScheme.secondary.withOpacity(0.6));
      isExpired = true;
      gamePlayStateForGui!.isMyTurnNotifier.value = GameState!.myTurn;
      log('running the game');
    }

    //lets add a listener for isGameOver
    gamePlayStateForGui!.isGameOverNotifier.addListener(() async {
      if (gamePlayStateForGui!.isGameOverNotifier.value) {
        await Future.delayed(Duration(seconds: 2));
        //navigate to the game over screen using pushReplacement to GameResultScreen
        log('Game Over and Navigating to GameResultScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameResultScreen(
              playerOneName: playerOneName,
              playerOneScore: gamePlayStateForGui!.playerOneScoreNotifier.value,
              playerTwoName: playerTwoName,
              playerTwoScore: gamePlayStateForGui!.playerTwoScoreNotifier.value,
              levelPlayedIndex: gamePlayStateForGui!.currentLevel.id - 1,
            ),
          ),
        );
      }
    });

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                // First Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        height: 37,
                        width: 37,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            width: 0.5,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, size: 20),
                          onPressed: () async {
                            if (await _onWillPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      // Progress Indicator
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return ValueListenableBuilder<int>(
                              valueListenable: gamePlayStateForGui!.playerOneScoreNotifier,
                              builder: (context, playerOneScore, _) {
                                return ValueListenableBuilder<int>(
                                  valueListenable: gamePlayStateForGui!.playerTwoScoreNotifier,
                                  builder: (context, playerTwoScore, _) {
                                    int totalScore = playerOneScore + playerTwoScore;
                                    double playerOneRatio = totalScore == 0 ? 0.5 : playerOneScore / totalScore;
                                    double playerTwoRatio = totalScore == 0 ? 0.5 : playerTwoScore / totalScore;
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          LinearProgressIndicator(
                                            value: 1,
                                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                            minHeight: 12,
                                          ),
                                          SizedBox(
                                            height: 13,
                                            child: Row(
                                              children: [
                                                AnimatedContainer(duration: Duration(milliseconds: 300), width: constraints.maxWidth * playerOneRatio, color: playerOneScore == 0 && playerTwoScore == 0 ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8)),
                                                AnimatedContainer(
                                                  duration: Duration(milliseconds: 300),
                                                  width: constraints.maxWidth * playerTwoRatio,
                                                  color: playerOneScore == 0 && playerTwoScore == 0 ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).colorScheme.onSurfaceVariant,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 37,
                        width: 37,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            width: 0.5,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.zoom_out, size: 20),
                          onPressed: () {
                            game.handleZoom();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Second Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      // Player One
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: gamePlayStateForGui!.isMyTurnNotifier,
                          builder: (context, isMyTurn, _) {
                            return Card(
                              elevation: 0,
                              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(
                                    Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.7,
                                  ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: (isMyTurn) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondaryContainer,
                                  width: isMyTurn ? 3.0 : 1.0, // Adjust these values as needed
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          (playerOneName.length > 8) ? '${playerOneName.substring(0, 8)}..' : playerOneName,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        ValueListenableBuilder<int>(
                                          valueListenable: gamePlayStateForGui!.playerOneScoreNotifier,
                                          builder: (context, score, _) {
                                            return Text(
                                              '$score',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                          width: 50,
                                          height: 50,
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: gamePlayStateForGui!.playerOneImage,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Remaining Moves
                      Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(
                              Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.7,
                            ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ValueListenableBuilder<int>(
                                valueListenable: gamePlayStateForGui!.movesLeftNotifier,
                                builder: (context, movesLeft, _) {
                                  return Text('$movesLeft', style: Theme.of(context).textTheme.titleLarge);
                                },
                              ),
                              Text('Lines', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                      // Player Two
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: gamePlayStateForGui!.isMyTurnNotifier,
                          builder: (context, isMyTurn, _) {
                            return Card(
                              elevation: 0,
                              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(
                                    Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.7,
                                  ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: (!isMyTurn) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondaryContainer,
                                  width: !isMyTurn ? 3.0 : 1.0, // Adjust these values as needed
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                        child: gamePlayStateForGui!.playerTwoImage,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          (playerTwoName.length > 11) ? '${playerTwoName.substring(0, 10)}..' : playerTwoName,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        ValueListenableBuilder<int>(
                                          valueListenable: gamePlayStateForGui!.playerTwoScoreNotifier,
                                          builder: (context, score, _) {
                                            return Text(
                                              '$score',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height,
            ),
            //!Here is the game board
            Container(padding: EdgeInsets.only(top: height), child: GameWidget(game: game)),

            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.5,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: SizedBox(
                    height: 30,
                    child: interactiveSoundButton(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class interactiveSoundButton extends StatefulWidget {
  const interactiveSoundButton({
    super.key,
  });

  @override
  State<interactiveSoundButton> createState() => _interactiveSoundButtonState();
}

class _interactiveSoundButtonState extends State<interactiveSoundButton> {
  @override
  Widget build(BuildContext context) {
    final Color color = soundEnabled ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary.withOpacity(0.5);
    return OutlinedButton.icon(
      //border color primary

      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
      ),
      onPressed: () {
        setState(() {
          soundEnabled = !soundEnabled;
        });
        log('changing sound to $soundEnabled');
      },
      icon: Icon((soundEnabled) ? Icons.volume_up : Icons.volume_off, color: color),
      label: Text(
        'Sound : ${(soundEnabled) ? 'On' : 'Off'}',
        style: TextStyle(color: color),
      ),
    );
  }
}

bool soundEnabled = true;
