import 'package:audioplayers/audioplayers.dart';
import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/audio_service.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/game_play_screen.dart';
import 'package:cellz_lite/screens/my_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' as riv;

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

var allStarsPlayed = false;

class _GameResultScreenState extends State<GameResultScreen> {
  @override
  void initState() {
    allStarsPlayed = false;
    updateTheDb();
    //lets feed the score and timer value to the LevelStarObject to get the stars
    levelStars[widget.levelPlayedIndex].updateStoredData(widget.playerOneScore, gamePlayStateForGui!.secTimerNotifier.value);
    Future.microtask(() {
      userProvider.emptyUpdate();
    });

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
      AudioPlayer().play(AssetSource('audio/tiebg.wav'));
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

    //display a snakebar highlighting the criteria for getting stars:
    //     if (levelObject.id == 60) return 0.80 * totalScore;
    // if (levelObject.id == 61) return 0.82 * totalScore;
    // if (levelObject.id == 62) return 0.85 * totalScore;
    // if (levelObject.id == 63) return 0.87 * totalScore;
    // if (levelObject.id == 64) return 0.9 * totalScore;
    // if (levelObject.id == 65) return 0.95 * totalScore;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (widget.playerOneScore > widget.playerTwoScore && shouldAppear)
              const Positioned.fill(
                child: const Opacity(
                  opacity: 0.1,
                  child: riv.RiveAnimation.asset(
                    'assets/images/confetti_best.riv',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            //lets display a huge percentage in the center
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  //text about the level id

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(ratio * 100).toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                              color: _getResultColor(widget.playerOneScore, widget.playerTwoScore),
                            ),
                      ),
                      Text(
                        ' %',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w100,
                              color: _getResultColor(widget.playerOneScore, widget.playerTwoScore),
                            ),
                      ),
                    ],
                  ),

                  //!now the stars are ready to be displayed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) {
                        bool isActive = index < levelStars[widget.levelPlayedIndex].newStars;
                        Future.delayed(Duration(milliseconds: ((index + 1) * 500)), () {
                          if (isActive && !allStarsPlayed) AudioPlayer().play(AssetSource('audio/star${index + 1}.wav'));
                          if (index == 2) allStarsPlayed = true; //to avoid multiple plays
                        });

                        return SizedBox(
                          child: Container(
                            margin: const EdgeInsets.only(top: 110.0),
                            height: 700,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: isActive
                                  ? Image.asset(
                                      'assets/images/star.png',
                                      width: 20,
                                      height: 20,
                                    )
                                      .animate(
                                        onPlay: (controller) => controller.forward(),
                                      )
                                      .rotate(
                                        begin: 0,
                                        end: 1,
                                        duration: 3.seconds,
                                      )
                                      .moveX(
                                        begin: index == 0 ? -100 : (index == 2 ? 100 : 0),
                                        end: 0,
                                        duration: 3.seconds,
                                        curve: Curves.easeOutQuart,
                                      )
                                      .moveY(
                                        begin: index == 1 ? 100 : 0,
                                        end: 0,
                                        duration: 3.seconds,
                                        curve: Curves.easeOutQuart,
                                      )
                                      .scale(
                                        delay: ((index + 1) * 500).milliseconds,
                                        duration: 1.seconds,
                                        curve: Curves.bounceOut,
                                        begin: Offset(3.5, 3.5),
                                        end: Offset(1, 1),
                                      )
                                  : Image.asset(
                                      'assets/images/star.png',
                                      width: 20,
                                      height: 20,
                                      color: Colors.grey,
                                    ),
                            ),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              '[  L e v e l   ${widget.levelPlayedIndex + 1}  ]',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            width: 450,
                            child: (!shouldAppear)
                                ? const SizedBox.shrink()
                                : riv.RiveAnimation.asset(
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
                        //color should be inversePrimary
                        Container(
                          padding: EdgeInsets.all(2),
                          //same as the button
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 23,
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                              )
                            ],
                          ),
                          child: ElevatedButton.icon(
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
                                              const Text(
                                                'No Lives Left',
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(
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
                                                      audioService.playSfx(MyComponent.BUTTON);

                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  OutlinedButton(
                                                    child: Text('Get Lives'),
                                                    onPressed: () {
                                                      audioService.playSfx(MyComponent.BUTTON);

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

                              int validLevelID = (thisLevel.id == 65) ? 64 : thisLevel.id;

                              gamePlayStateForGui!.currentLevel = (shouldRetry) ? thisLevel : levels[validLevelID]; //id of this level is index+1
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
                              shouldRetry ? 'Retry' : 'Next Level ${levels[widget.levelPlayedIndex + 1].id}',
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              right: MediaQuery.of(context).size.width / 2 - 120,
              child: Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: Row(
                  //info icon and text all in primary color
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5),
                    Column(
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: Icon(
                            Icons.arrow_drop_down_sharp,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          'To get 3 stars, you need to have at least ${levelStars[widget.levelPlayedIndex].secondStarCritera().ceil().toInt()} squares,',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        // within ${levelStars[widget.levelPlayedIndex].thresholdSeconds} seconds',
                        Text(
                          'within ${levelStars[widget.levelPlayedIndex].thresholdSeconds} seconds',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //this time it should animate and scale up until it disappears at the end using flutter animate
            Center(
              child: Text(
                '${(ratio * 100).toStringAsFixed(0)} %',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 35,
                      color: _getResultColor(widget.playerOneScore, widget.playerTwoScore).withOpacity(0.4),
                    ),
              )
                  .animate()
                  .moveY(
                      begin: 1,
                      end: 12,
                      curve: Curves.linear,
                      duration: const Duration(
                        milliseconds: 500,
                      ))
                  .then()
                  .scale(
                    duration: 3.seconds,
                    curve: Curves.easeInOutExpo,
                    begin: const Offset(1, 1),
                    end: const Offset(4, 4),
                  )
                  .fade(
                    duration: 3.seconds,
                    curve: Curves.easeInOutExpo,
                    begin: 1,
                    end: 0,
                  )
                  .blur(
                    duration: 3.seconds,
                    curve: Curves.easeInQuad,
                    begin: Offset.zero,
                    end: const Offset(10, 10),
                  ),
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
        Row(
          children: [
            Text(
              score.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
            ),
            Text(
              ' ▢',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
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
