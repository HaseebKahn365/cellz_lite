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
import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/audio_service.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/animated_think_circle.dart';
import 'package:cellz_lite/screens/game_over_screen.dart';
import 'package:cellz_lite/screens/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' as riv;

// ignore: must_be_immutable
class GamePlayScreen extends StatelessWidget {
  final String playerOneName;
  final String playerTwoName;
  final MyGame game;
  final bestTime = levelStars[gamePlayStateForGui!.currentLevel.id - 1].thresholdSeconds;

  GamePlayScreen({
    Key? key,
    required this.playerOneName,
    required this.playerTwoName,
    required this.game,
  }) : super(key: key);
  //lets create a timer that starts as the widget is created and should count the time the user has been in the game

  bool isExpired = false;
  Future<bool> _onWillPop(BuildContext context) async {
    AudioPlayer().play(AssetSource('audio/leave.wav'), volume: 0.4);

    return await showDialog<bool>(
          barrierColor: Colors.black.withOpacity(0.8),
          context: context,
          builder: (context) => AlertDialog(
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
                    const SizedBox(
                      width: 350,
                      height: 150,
                      child: riv.RiveAnimation.asset(
                        'assets/images/cute_heart_broken.riv',
                        fit: BoxFit.cover,
                        antialiasing: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'You will lose life!\nAre you sure you want to quit?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          child: Text('Leave', textAlign: TextAlign.center),
                          onPressed: () {
                            // audioService.playSfx(MyComponent.BUTTON);
                            audioService.gameEnd();

                            Navigator.of(context).pop(true);
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          child: Text('Keep Playing'),
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: () {
                            audioService.playSfx(MyComponent.BUTTON);

                            Navigator.of(context).pop(false);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ) ??
        false;
  }

  Color _getColorForProgress(double progress) {
    if (progress < 0.45) return Colors.green;
    if (progress < 0.6) return Colors.yellow;
    if (progress < 0.7) return Colors.orange;
    if (progress < 0.95) return Color.fromARGB(255, 255, 134, 97);

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 4.5;
    // level 29: 7x11 grid

    if (!gamePlayStateForGui!.isExpired) {
      GameState!.changeBGColor(Theme.of(context).colorScheme.surface);
      GameState!.changeLineColor(Theme.of(context).colorScheme.secondary);
      GameState!.changeDotColor(Theme.of(context).colorScheme.secondary);
      GameState!.changeHumanColor(Theme.of(context).colorScheme.primary);
      GameState!.changeAIColor(Theme.of(context).colorScheme.error);
      GameState!.changeSquareIconBoxColor(Theme.of(context).colorScheme.secondaryContainer);
      GameState!.changeMostRecentLineColor(Theme.of(context).colorScheme.primaryContainer);
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
                        child: Column(
                          children: [
                            //!Timer Text
                            Stack(
                              children: [
                                ValueListenableBuilder<int>(
                                  valueListenable: gamePlayStateForGui!.secTimerNotifier,
                                  builder: (context, elapsedSeconds, _) {
                                    // !Assume bestTimeSeconds is available from somewhere in your app
                                    final double progress = elapsedSeconds / bestTime;

                                    // Calculate the width of the container
                                    double containerWidth = progress <= 1 ? (220 * (1 - progress) + 30) : 1; //!30 is to just accomodate the text

                                    //! Determine the color based on progress
                                    Color containerColor = _getColorForProgress(progress);

                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Center(
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 700),
                                            margin: const EdgeInsets.only(top: 5),
                                            width: containerWidth,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: containerColor,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer, width: 0.8),
                                            ),
                                          ),
                                        ),
                                        //if progress becomes 1 then animate a star usig flutter animate downward
                                        if (progress >= 1)
                                          Center(
                                              child: SizedBox(
                                            height: 5,
                                            width: 5,
                                            child: Image.asset(
                                              'assets/images/star.png',
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                                  .animate()
                                                  .scale(
                                                    begin: Offset(10, 10),
                                                    end: Offset(1, 1),
                                                    curve: Curves.easeInOut,
                                                    duration: const Duration(milliseconds: 500),
                                                  )
                                                  .moveY(
                                                    begin: 0,
                                                    end: 100,
                                                    curve: Curves.easeInOut,
                                                    duration: const Duration(milliseconds: 500),
                                                  )
                                                  .rotate(
                                                    begin: 0,
                                                    end: 1,
                                                    duration: const Duration(milliseconds: 500),
                                                  )
                                                  .blur(
                                                    begin: Offset.zero,
                                                    end: Offset(10, 10),
                                                    duration: const Duration(milliseconds: 500),
                                                  )),
                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            color: Theme.of(context).colorScheme.surface,
                                            child: Text(
                                              '${(elapsedSeconds ~/ 60).toString()}:${(elapsedSeconds % 60).toString().padLeft(2, '0')}',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),

                            LayoutBuilder(
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
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                '(Finish before ${(bestTime ~/ 60).toString().padLeft(2, '')}:${(bestTime % 60).toString().padLeft(2, '0')})',
                                style: TextStyle(fontSize: 8),
                              ),
                            ),
                          ],
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
                            return Stack(
                              children: [
                                (GameState!.myTurn)
                                    ? Center(
                                        child: AnimatedScaleWidget(),
                                      )
                                    : const SizedBox.shrink(),
                                Card(
                                  elevation: 0,
                                  color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(
                                        Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.7,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: (GameState!.myTurn) ? GameState!.colorSet[3] : Theme.of(context).colorScheme.secondaryContainer,
                                      width: isMyTurn ? 4.0 : 1.0, // Adjust these values as needed
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
                                ),
                              ],
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
                              Text('Level ${gamePlayStateForGui!.currentLevel.id}', style: TextStyle(fontSize: 9)),
                              ValueListenableBuilder<int>(
                                valueListenable: gamePlayStateForGui!.squaresLeftNotifier,
                                builder: (context, squares, _) {
                                  return Text('$squares', style: Theme.of(context).textTheme.titleLarge);
                                },
                              ),
                              const Text('Sqrs. Left', style: TextStyle(fontSize: 9)),
                            ],
                          ),
                        ),
                      ),
                      // Player Two
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: gamePlayStateForGui!.isMyTurnNotifier,
                          builder: (context, isMyTurn, _) {
                            return Stack(
                              children: [
                                (!GameState!.myTurn)
                                    ? Center(
                                        child: AnimatedScaleWidget(),
                                      )
                                    : const SizedBox.shrink(),
                                Card(
                                  elevation: 0,
                                  color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(
                                        Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.7,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: GameState!.myTurn ? Theme.of(context).colorScheme.secondaryContainer : GameState!.colorSet[4],
                                      width: !isMyTurn ? 4.0 : 1.0, // Adjust these values as needed
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
                                ),
                              ],
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
                  padding: const EdgeInsets.only(bottom: 30.0, right: 50, left: 50),
                  child: SizedBox(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        interactiveSoundButton(),
                        const SizedBox(width: 10),
                        BGMControls(),
                      ],
                    ),
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

class BGMControls extends StatefulWidget {
  BGMControls({
    super.key,
  });

  @override
  State<BGMControls> createState() => _BGMControlsState();
}

class _BGMControlsState extends State<BGMControls> {
  bool isPlaying = false;
  int currentIndex = 1;
  int changeIndex({bool? previous, bool? next}) {
    if (previous != null) {
      currentIndex = currentIndex == 0 ? 5 : currentIndex - 1;
    } else if (next != null) {
      currentIndex = currentIndex == 5 ? 0 : currentIndex + 1;
    }
    return currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: () {
              // Handle back button press
              if (!isPlaying) return;

              audioService.changeBGM(index: changeIndex(previous: true));
            },
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        SizedBox(
          width: 25,
          height: 25,
          child: IconButton(
            icon: isPlaying ? const Icon(Icons.music_note) : const Icon(Icons.music_off),
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying;
                if (!audioService.gameRunState) {
                  audioService.gameStart();
                  setState(() {
                    isPlaying = true;
                  });
                  return;
                }
                if (isPlaying) {
                  audioService.resumeBGM();
                } else {
                  audioService.pauseBGM();
                }
              });
            },
            iconSize: 25,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        SizedBox(
          width: 30,
          height: 30,
          child: IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () {
              if (!isPlaying) return;

              audioService.changeBGM(index: changeIndex(next: true));
            },
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
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
