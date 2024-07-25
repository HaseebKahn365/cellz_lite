import 'dart:developer';

import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/screens/my_game.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class GameResultScreen extends StatefulWidget {
  final String playerOneName;
  final int playerOneScore;
  final String playerTwoName;
  final int playerTwoScore;

  const GameResultScreen({
    Key? key,
    required this.playerOneName,
    required this.playerOneScore,
    required this.playerTwoName,
    required this.playerTwoScore,
  }) : super(key: key);

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  @override
  void dispose() {
    // TODO: implement dispose

    //making the state instances null to free up the resources
    game = null;
    gamePlayStateForGui = null;
    GameState!.dispose();
    GameState = null;
    log('Everything is destroyed to free up resources');
    super.dispose();
  }

  @override
  void initState() {
    updateTheDb();
    super.initState();
  }

  Future<void> updateTheDb() async {
    userProvider.lastScore = widget.playerOneScore;
    userProvider.lastTotalScore = widget.playerOneScore + widget.playerTwoScore;
    if (widget.playerOneScore > widget.playerTwoScore) {
      userProvider.wins++;
    } else if (widget.playerOneScore < widget.playerTwoScore) {
      userProvider.losses++;
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = widget.playerOneScore + widget.playerTwoScore;
    double ratio = total == 0 ? 0.5 : widget.playerOneScore / total;

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
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.playerOneScore > widget.playerTwoScore)
                    RiveAnimation.asset(
                      'assets/images/confetti_best.riv',
                      fit: BoxFit.cover,
                    ),
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
                        child: RiveAnimation.asset(
                          'assets/images/emoji_set.riv',
                          artboard: emojiAnimation,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
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
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      icon: Icon(Icons.home),
                      label: Text('Go Home'),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                  ],
                ),
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
