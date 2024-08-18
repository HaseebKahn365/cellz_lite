import 'package:audioplayers/audioplayers.dart';
import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/game_play_screen.dart';
import 'package:cellz_lite/screens/my_game.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';

class GameResultScreen extends StatefulWidget {
  final String playerOneName;
  final int playerOneScore;
  final String playerTwoName;
  final int playerTwoScore;
  final levelPlayedIndex;

  const GameResultScreen({
    Key? key,
    required this.playerOneName,
    required this.playerOneScore,
    required this.playerTwoName,
    required this.playerTwoScore,
    required this.levelPlayedIndex,
  }) : super(key: key);

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  @override
  void initState() {
    updateTheDb();
    //lets feed the score and timer value to the LevelStarObject to get the stars
    levelStars[widget.levelPlayedIndex].updateStoredData(widget.playerOneScore, gamePlayStateForGui!.secTimerNotifier.value);
    super.initState();
  }

  Future<void> updateTheDb() async {
    await userProvider.lastPlay(widget.playerOneScore, widget.playerTwoScore + widget.playerOneScore);

    if (widget.playerOneScore > widget.playerTwoScore) {
      userProvider.incrementWins();
      userProvider.incrementLife();

      if (widget.levelPlayedIndex == userProvider.currentLevelIndex) {
        userProvider.updateCurrentLevelIndex(userProvider.currentLevelIndex + 1);
      }
      //lets play the applause audio
      AudioPlayer().play(AssetSource('audio/applause.wav'));
    } else if (widget.playerOneScore < widget.playerTwoScore) {
      userProvider.incrementLosses();
      AudioPlayer().play(AssetSource('audio/loss.wav'));
    } else {
      AudioPlayer().play(AssetSource('audio/quit.wav'));
      //lets refund the life
      userProvider.incrementLife();
    }
  }

  bool shouldAppear = true;

  @override
  Widget build(BuildContext context) {
    int total = widget.playerOneScore + widget.playerTwoScore;
    double ratio = total == 0 ? 0.5 : widget.playerOneScore / total;

    final bool shouldRetry = widget.playerOneScore <= widget.playerTwoScore;

    String resultText = widget.playerOneScore > widget.playerTwoScore
        ? 'You Win!'
        : widget.playerOneScore == widget.playerTwoScore
            ? 'It\'s a Draw!'
            : 'You Lose!';

    String emojiAnimation = _getEmojiAnimation(ratio);

    Color _getResultColor(int playerOneScore, int playerTwoScore) {
      if (playerOneScore > playerTwoScore) return Theme.of(context).colorScheme.primary;
      if (playerOneScore == playerTwoScore) return Colors.orange;
      return Colors.red;
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (widget.playerOneScore > widget.playerTwoScore && shouldAppear)
              const Opacity(
                opacity: 0.1,
                child: Positioned.fill(
                  child: RiveAnimation.asset(
                    'assets/images/confetti_best.riv',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            //lets display a huge percentage in the center
            Center(
              child: Stack(
                children: [
                  //this time it should animate and scale up until it disappears at the end using flutter animate
                  Text(
                    '${(ratio * 100).toStringAsFixed(0)} %',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: _getResultColor(widget.playerOneScore, widget.playerTwoScore),
                        ),
                  )
                      .animate()
                      .scale(
                        duration: 3.seconds,
                        curve: Curves.easeInOut,
                        begin: Offset(1, 1),
                        end: Offset(5, 5),
                      )
                      .fade(
                        duration: 3.seconds,
                        curve: Curves.easeInOut,
                        begin: 1,
                        end: 0,
                      )
                      .blur(
                        duration: 3.seconds,
                        curve: Curves.easeInOut,
                        begin: Offset.zero,
                        end: const Offset(3, 3),
                      ),

                  Text(
                    '${(ratio * 100).toStringAsFixed(0)} %',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: _getResultColor(widget.playerOneScore, widget.playerTwoScore),
                        ),
                  ),

                  //!now the stars are ready to be displayed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.star,
                            color: (index < levelStars[widget.levelPlayedIndex].newStars) ? Colors.yellow : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      //add a cross icon at the top right corner to close the screen

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            resultText,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getResultColor(widget.playerOneScore, widget.playerTwoScore),
                                ),
                          ),
                          SizedBox(
                            height: 300,
                            width: 450,
                            child: (!shouldAppear)
                                ? const SizedBox.shrink()
                                : RiveAnimation.asset(
                                    'assets/images/emoji_set.riv',
                                    artboard: emojiAnimation,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 5,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            border: Border.all(color: Theme.of(context).colorScheme.onSurface),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPlayerScore(context, widget.playerOneName, widget.playerOneScore, total, Theme.of(context).colorScheme.primary),
                        SizedBox(height: 20),
                        _buildPlayerScore(context, widget.playerTwoName, widget.playerTwoScore, total, Colors.redAccent),
                        SizedBox(height: 40),
                        ElevatedButton.icon(
                          onPressed: () async {
                            AudioPlayer().play(AssetSource('audio/play.wav'), volume: 0.4);

                            setState(() {
                              shouldAppear = false;
                            });
                            if (!userProvider.hasLives() && shouldRetry) {
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
                                              child: RiveAnimation.asset(
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

                            //first we store the current level
                            final thisLevel = levels[widget.levelPlayedIndex];

                            Future.delayed(Duration(seconds: 1), () {
                              //Creating instances of Global States
                              userProvider.decrementLives();
                            });

                            gamePlayStateForGui = GamePlayStateForGui();

                            //Creating instances of Global States

                            //make sure to reset the scores and stuff before game start
                            gamePlayStateForGui!.resetGame();

                            gamePlayStateForGui!.currentLevel = (shouldRetry) ? thisLevel : levels[thisLevel.id]; //id of this level is index+1
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
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => GamePlayScreen(
                                  game: game!,
                                  playerOneName: gamePlayStateForGui!.playerOneName,
                                  playerTwoName: gamePlayStateForGui!.playerTwoName,
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  if (shouldRetry) {
                                    // Scale animation for retry
                                    const begin = 0.5;
                                    const end = 1.0;
                                    const curve = Curves.easeOutQuint;
                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    var scaleAnimation = animation.drive(tween);
                                    return ScaleTransition(
                                      scale: scaleAnimation,
                                      child: child,
                                    );
                                  } else if (!shouldRetry) {
                                    // Slide animation for next level
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeOutCubic;
                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    var slideAnimation = animation.drive(tween);
                                    return SlideTransition(
                                      position: slideAnimation,
                                      child: child,
                                    );
                                  } else {
                                    // Default fade transition
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  }
                                },
                                transitionDuration: const Duration(milliseconds: 1000),
                              ),
                            );
                          },

                          //in case if the game is lost or draw the show retry button else show go Next button
                          icon: shouldRetry ? const Icon(Icons.replay_circle_filled_rounded) : Icon(Icons.arrow_forward_ios_rounded),
                          label: Text(
                            shouldRetry ? 'Retry' : 'Next Level',
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScore(BuildContext context, String name, int score, int total, Color color) {
    return Row(
      children: [
        SizedBox(
            width: 70,
            height: 70,
            child: ClipOval(
              child: FittedBox(
                fit: BoxFit.cover,
                child: (name == userProvider.name) ? gamePlayStateForGui?.playerOneImage : gamePlayStateForGui?.playerTwoImage,
              ),
            )),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : score / total,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 10,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 15),
        Text(
          score.toString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }

  String _getEmojiAnimation(double ratio) {
    if (ratio < 0.5) return 'Crying';
    if (ratio == 0.5) return 'Surprise';
    if (ratio < 0.60) return 'Smiling';
    if (ratio < 0.70) return 'Winking';
    if (ratio < 0.80) return 'Happy';
    return 'Laughing';
  }
}
