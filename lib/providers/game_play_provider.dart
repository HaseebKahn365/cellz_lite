/*
Here we define a class that will be used to manage the game play state.
Following are the members of this provider:
movesLeft : int. it will keep track of the number of moves left in the game.
playerOneScore : int. it will keep track of the score of player one.
playerTwoScore : int. it will keep track of the score of player two.

bool isMyTurn : bool. it will keep track of whose turn it is. if true then it is player one's turn else it is player two's turn.

in this class we will have a bunch of value notifiers that will automatically notify the listeners when the value changes.
eg.
  final ValueNotifier<bool> isMyTurn = ValueNotifier(false);
  final ValueNotifier<int> movesLeft = ValueNotifier(365);
  final ValueNotifier<int> playerOneScore = ValueNotifier(0);

 */

import 'dart:async';
import 'dart:math';

import 'package:cellz_lite/main.dart';
import 'package:flutter/material.dart';

class GamePlayStateForGui {
  LevelObject currentLevel = levels[userProvider.currentLevelIndex];
  String playerOneName = userProvider.name;
  String playerTwoName = 'Opponent';

  Widget? playerTwoImage = Image.asset('assets/images/o${Random().nextInt(3) + 1}.jpg');
  Widget playerOneImage = Image.asset('assets/images/p${userProvider.avatarIndex + 1}.jpg');
  final ValueNotifier<bool> isMyTurnNotifier = ValueNotifier(false);
  final ValueNotifier<int> movesLeftNotifier = ValueNotifier(365);
  final ValueNotifier<int> squaresLeftNotifier = ValueNotifier(365);
  final ValueNotifier<int> playerOneScoreNotifier = ValueNotifier(0);
  final ValueNotifier<int> playerTwoScoreNotifier = ValueNotifier(0);
  //another boolean value notifier for isGameOver
  final ValueNotifier<bool> isGameOverNotifier = ValueNotifier(false);
  //creating a timer
  final ValueNotifier<int> secTimerNotifier = ValueNotifier(0);

  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //increment the time by 1
    gamePlayStateForGui!.secTimerNotifier.value++;
  });

  bool isExpired = false;

  void updateTurn(bool isMyTurn) {
    isMyTurnNotifier.value = isMyTurn;
  }

  void initMovesLeftAndSquares(int movesLeft, int squaresLeft) {
    movesLeftNotifier.value = movesLeft;
    squaresLeftNotifier.value = squaresLeft;
    //start the timer
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //increment the time by 1
      secTimerNotifier.value++;
    });
  }

  void decrementMovesLeft() {
    movesLeftNotifier.value--;
  }

  void incrementPlayerOneScore() {
    playerOneScoreNotifier.value++;
  }

  void incrementPlayerTwoScore() {
    playerTwoScoreNotifier.value++;
  }

  void resetGame() {
    isMyTurnNotifier.value = true;
    isGameOverNotifier.value = false;
    playerOneScoreNotifier.value = 0;
    playerTwoScoreNotifier.value = 0;

    //stop the timer
    timer.cancel();
  }

  bool checkGameOver() {
    if (movesLeftNotifier.value == 0) {
      isGameOverNotifier.value = true;
      print('Game Over and resetting');
    }

    return isGameOverNotifier.value;
  }
}

class LevelObject {
  final double offsetFromTopLeftCorner;
  final offsetFactoForSquare;
  final int id;
  final String? grade;
  final int xPoints;
  final int yPoints;
  final int? aiXperience; //in case when playing with friend this could be set to null if we use LevelObject in gamePlaystateForGui

  const LevelObject({
    required this.offsetFromTopLeftCorner,
    required this.offsetFactoForSquare,
    required this.id,
    required this.grade,
    required this.xPoints,
    required this.yPoints,
    this.aiXperience = 1,
  });

  @override
  String toString() {
    return '''LevelObject{
      id: $id,
      grade: $grade,
      xPoints: $xPoints,
      yPoints: $yPoints,
      aiXperience: $aiXperience,
    }''';
  }
}

//create a global instance for easy access
GamePlayStateForGui? gamePlayStateForGui;

//reordering the levels is required

const List<LevelObject> levels = [
  LevelObject(
    offsetFromTopLeftCorner: 275,
    offsetFactoForSquare: 0.9,
    id: 1,
    grade: "Easy Peasy",
    xPoints: 2,
    yPoints: 2,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 275,
    offsetFactoForSquare: 0.9,
    id: 2,
    grade: "Piece o'Cake",
    xPoints: 2,
    yPoints: 4,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 150,
    offsetFactoForSquare: 1.23,
    id: 3,
    grade: "Simple",
    xPoints: 3,
    yPoints: 3,
    aiXperience: 1,
  ), //!the above levels should not be altered
  LevelObject(
    offsetFromTopLeftCorner: 110,
    offsetFactoForSquare: 1.25,
    id: 4,
    grade: "Moderate",
    xPoints: 4,
    yPoints: 4,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 5,
    grade: "Medium",
    xPoints: 5,
    yPoints: 4,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 6,
    grade: "Moderate",
    xPoints: 6,
    yPoints: 4,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 7,
    grade: "Decent",
    xPoints: 7,
    yPoints: 4,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 8,
    grade: "Challenging",
    xPoints: 8,
    yPoints: 4,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 9,
    grade: "Challenging",
    xPoints: 9,
    yPoints: 4,
    aiXperience: 1,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 10,
    grade: "Demanding",
    xPoints: 10,
    yPoints: 4,
    aiXperience: 1,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 150,
    offsetFactoForSquare: 1.23,
    id: 11,
    grade: "Breeze",
    xPoints: 3,
    yPoints: 4,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 110,
    offsetFactoForSquare: 1.25,
    id: 12,
    grade: "Average",
    xPoints: 4,
    yPoints: 5,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 150,
    offsetFactoForSquare: 1.23,
    id: 13,
    grade: "No Sweat",
    xPoints: 3,
    yPoints: 5,
    aiXperience: 1,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 14,
    grade: "Moderate",
    xPoints: 5,
    yPoints: 5,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 15,
    grade: "Average",
    xPoints: 6,
    yPoints: 5,
    aiXperience: 1,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 16,
    grade: "Manageable",
    xPoints: 7,
    yPoints: 5,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 17,
    grade: "Tough",
    xPoints: 8,
    yPoints: 5,
    aiXperience: 1,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 18,
    grade: "Tough",
    xPoints: 9,
    yPoints: 5,
    aiXperience: 1,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 19,
    grade: "Hardcore",
    xPoints: 10,
    yPoints: 5,
    aiXperience: 1,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 110,
    offsetFactoForSquare: 1.25,
    id: 20,
    grade: "Decent",
    xPoints: 4,
    yPoints: 6,
    aiXperience: 1,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 21,
    grade: "Average",
    xPoints: 5,
    yPoints: 6,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 22,
    grade: "Decent",
    xPoints: 6,
    yPoints: 6,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 23,
    grade: "Medium",
    xPoints: 7,
    yPoints: 6,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 24,
    grade: "Demanding",
    xPoints: 8,
    yPoints: 6,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 25,
    grade: "Demanding",
    xPoints: 9,
    yPoints: 6,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 26,
    grade: "Grueling",
    xPoints: 10,
    yPoints: 6,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 110,
    offsetFactoForSquare: 1.25,
    id: 27,
    grade: "Manageable",
    xPoints: 4,
    yPoints: 7,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 28,
    grade: "Decent",
    xPoints: 5,
    yPoints: 7,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 29,
    grade: "Manageable",
    xPoints: 6,
    yPoints: 7,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 30,
    grade: "Moderate",
    xPoints: 7,
    yPoints: 7,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 31,
    grade: "Hardcore",
    xPoints: 8,
    yPoints: 7,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 32,
    grade: "Hardcore",
    xPoints: 9,
    yPoints: 7,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 33,
    grade: "Challenging",
    xPoints: 10,
    yPoints: 7,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 34,
    grade: "Manageable",
    xPoints: 5,
    yPoints: 8,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 35,
    grade: "Medium",
    xPoints: 6,
    yPoints: 8,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 36,
    grade: "Average",
    xPoints: 7,
    yPoints: 8,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 37,
    grade: "Grueling",
    xPoints: 8,
    yPoints: 8,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 38,
    grade: "Grueling",
    xPoints: 9,
    yPoints: 8,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 39,
    grade: "Tough",
    xPoints: 10,
    yPoints: 8,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 40,
    grade: "Moderate",
    xPoints: 6,
    yPoints: 9,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 41,
    grade: "Decent",
    xPoints: 7,
    yPoints: 9,
    aiXperience: 2,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 42,
    grade: "Challenging",
    xPoints: 8,
    yPoints: 9,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 43,
    grade: "Challenging",
    xPoints: 9,
    yPoints: 9,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 44,
    grade: "Demanding",
    xPoints: 10,
    yPoints: 9,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 45,
    grade: "Average",
    xPoints: 6,
    yPoints: 10,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 46,
    grade: "Manageable",
    xPoints: 7,
    yPoints: 10,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 47,
    grade: "Tough",
    xPoints: 8,
    yPoints: 10,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 48,
    grade: "Tough",
    xPoints: 9,
    yPoints: 10,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 49,
    grade: "Hardcore",
    xPoints: 10,
    yPoints: 10,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 50,
    grade: "Medium",
    xPoints: 7,
    yPoints: 11,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 51,
    grade: "Demanding",
    xPoints: 8,
    yPoints: 11,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 52,
    grade: "Demanding",
    xPoints: 9,
    yPoints: 11,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 53,
    grade: "Grueling",
    xPoints: 10,
    yPoints: 11,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 54,
    grade: "Hardcore",
    xPoints: 8,
    yPoints: 12,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 55,
    grade: "Hardcore",
    xPoints: 9,
    yPoints: 12,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 56,
    grade: "Challenging",
    xPoints: 10,
    yPoints: 12,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 57,
    grade: "Grueling",
    xPoints: 8,
    yPoints: 13,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 58,
    grade: "Grueling",
    xPoints: 9,
    yPoints: 13,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 59,
    grade: "Tough",
    xPoints: 10,
    yPoints: 13,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 60,
    grade: "Challenging",
    xPoints: 9,
    yPoints: 14,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 61,
    grade: "Demanding",
    xPoints: 10,
    yPoints: 14,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 62,
    grade: "Tough",
    xPoints: 9,
    yPoints: 15,
    aiXperience: 3,
  ),

  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 63,
    grade: "Hardcore",
    xPoints: 10,
    yPoints: 15,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 64,
    grade: "Grueling",
    xPoints: 10,
    yPoints: 16,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 65,
    grade: "Challenging",
    xPoints: 10,
    yPoints: 17,
    aiXperience: 3,
  ),
];
