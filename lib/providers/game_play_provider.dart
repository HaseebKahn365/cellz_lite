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
  final ValueNotifier<int> playerOneScoreNotifier = ValueNotifier(0);
  final ValueNotifier<int> playerTwoScoreNotifier = ValueNotifier(0);
  //another boolean value notifier for isGameOver
  final ValueNotifier<bool> isGameOverNotifier = ValueNotifier(false);

  bool isExpired = false;

  void updateTurn(bool isMyTurn) {
    isMyTurnNotifier.value = isMyTurn;
  }

  void initMovesLeft(int movesLeft) {
    movesLeftNotifier.value = movesLeft;
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
    isMyTurnNotifier.value = false;
    isGameOverNotifier.value = false;
    playerOneScoreNotifier.value = 0;
    playerTwoScoreNotifier.value = 0;
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
  int? aiXperience; //in case when playing with friend this could be set to null if we use LevelObject in gamePlaystateForGui

  LevelObject({
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

List<LevelObject> levels = [
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
  ),
  LevelObject(
    offsetFromTopLeftCorner: 150,
    offsetFactoForSquare: 1.23,
    id: 4,
    grade: "Breeze",
    xPoints: 3,
    yPoints: 4,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 150,
    offsetFactoForSquare: 1.23,
    id: 5,
    grade: "No Sweat",
    xPoints: 3,
    yPoints: 5,
    aiXperience: 1,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 110,
    offsetFactoForSquare: 1.25,
    id: 6,
    grade: "Moderate",
    xPoints: 4,
    yPoints: 4,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 110,
    offsetFactoForSquare: 1.25,
    id: 7,
    grade: "Average",
    xPoints: 4,
    yPoints: 5,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 110,
    offsetFactoForSquare: 1.25,
    id: 8,
    grade: "Decent",
    xPoints: 4,
    yPoints: 6,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 110,
    offsetFactoForSquare: 1.25,
    id: 9,
    grade: "Manageable",
    xPoints: 4,
    yPoints: 7,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 10,
    grade: "Medium",
    xPoints: 5,
    yPoints: 4,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 11,
    grade: "Moderate",
    xPoints: 5,
    yPoints: 5,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 12,
    grade: "Average",
    xPoints: 5,
    yPoints: 6,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 13,
    grade: "Decent",
    xPoints: 5,
    yPoints: 7,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 80,
    offsetFactoForSquare: 1.32,
    id: 14,
    grade: "Manageable",
    xPoints: 5,
    yPoints: 8,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 15,
    grade: "Moderate",
    xPoints: 6,
    yPoints: 4,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 16,
    grade: "Average",
    xPoints: 6,
    yPoints: 5,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 17,
    grade: "Decent",
    xPoints: 6,
    yPoints: 6,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 18,
    grade: "Manageable",
    xPoints: 6,
    yPoints: 7,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 19,
    grade: "Medium",
    xPoints: 6,
    yPoints: 8,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 20,
    grade: "Moderate",
    xPoints: 6,
    yPoints: 9,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 70,
    offsetFactoForSquare: 1.27,
    id: 21,
    grade: "Average",
    xPoints: 6,
    yPoints: 10,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 22,
    grade: "Decent",
    xPoints: 7,
    yPoints: 4,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 23,
    grade: "Manageable",
    xPoints: 7,
    yPoints: 5,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 24,
    grade: "Medium",
    xPoints: 7,
    yPoints: 6,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 25,
    grade: "Moderate",
    xPoints: 7,
    yPoints: 7,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 26,
    grade: "Average",
    xPoints: 7,
    yPoints: 8,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 27,
    grade: "Decent",
    xPoints: 7,
    yPoints: 9,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 28,
    grade: "Manageable",
    xPoints: 7,
    yPoints: 10,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.27,
    id: 29,
    grade: "Medium",
    xPoints: 7,
    yPoints: 11,
    aiXperience: 2,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 30,
    grade: "Challenging",
    xPoints: 8,
    yPoints: 4,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 31,
    grade: "Tough",
    xPoints: 8,
    yPoints: 5,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 32,
    grade: "Demanding",
    xPoints: 8,
    yPoints: 6,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 33,
    grade: "Hardcore",
    xPoints: 8,
    yPoints: 7,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 34,
    grade: "Grueling",
    xPoints: 8,
    yPoints: 8,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 35,
    grade: "Challenging",
    xPoints: 8,
    yPoints: 9,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 36,
    grade: "Tough",
    xPoints: 8,
    yPoints: 10,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 37,
    grade: "Demanding",
    xPoints: 8,
    yPoints: 11,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 38,
    grade: "Hardcore",
    xPoints: 8,
    yPoints: 12,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 60,
    offsetFactoForSquare: 1.19,
    id: 39,
    grade: "Grueling",
    xPoints: 8,
    yPoints: 13,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 40,
    grade: "Challenging",
    xPoints: 9,
    yPoints: 4,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 41,
    grade: "Tough",
    xPoints: 9,
    yPoints: 5,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 42,
    grade: "Demanding",
    xPoints: 9,
    yPoints: 6,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 43,
    grade: "Hardcore",
    xPoints: 9,
    yPoints: 7,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 44,
    grade: "Grueling",
    xPoints: 9,
    yPoints: 8,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 45,
    grade: "Challenging",
    xPoints: 9,
    yPoints: 9,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 46,
    grade: "Tough",
    xPoints: 9,
    yPoints: 10,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 47,
    grade: "Demanding",
    xPoints: 9,
    yPoints: 11,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 48,
    grade: "Hardcore",
    xPoints: 9,
    yPoints: 12,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 49,
    grade: "Grueling",
    xPoints: 9,
    yPoints: 13,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 50,
    grade: "Challenging",
    xPoints: 9,
    yPoints: 14,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 50,
    offsetFactoForSquare: 1.22,
    id: 51,
    grade: "Tough",
    xPoints: 9,
    yPoints: 15,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 52,
    grade: "Demanding",
    xPoints: 10,
    yPoints: 4,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 53,
    grade: "Hardcore",
    xPoints: 10,
    yPoints: 5,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 54,
    grade: "Grueling",
    xPoints: 10,
    yPoints: 6,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 55,
    grade: "Challenging",
    xPoints: 10,
    yPoints: 7,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 56,
    grade: "Tough",
    xPoints: 10,
    yPoints: 8,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 57,
    grade: "Demanding",
    xPoints: 10,
    yPoints: 9,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 58,
    grade: "Hardcore",
    xPoints: 10,
    yPoints: 10,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 59,
    grade: "Grueling",
    xPoints: 10,
    yPoints: 11,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 60,
    grade: "Challenging",
    xPoints: 10,
    yPoints: 12,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 61,
    grade: "Tough",
    xPoints: 10,
    yPoints: 13,
    aiXperience: 3,
  ),
  LevelObject(
    offsetFromTopLeftCorner: 40,
    offsetFactoForSquare: 1.3,
    id: 62,
    grade: "Demanding",
    xPoints: 10,
    yPoints: 14,
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
