//this is a class that contains all the state of the game in the form of static members and methods

import 'dart:developer';

import 'package:cellz_lite/business_logic/game_canvas.dart';
import 'package:cellz_lite/business_logic/lines.dart';
import 'package:cellz_lite/business_logic/point.dart';
import 'package:cellz_lite/business_logic/square.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';

import 'package:flutter/material.dart';

class GameStateClass {
  Map<String, Line> linesDrawn = {};

  double globalOffset = 150; //this is the offset that is used to properly adjust the dots in the game.
  double offsetFromTopLeftCorner = 40; //this is the offset from the top left corner of the screen
  double offsetFactoForSquare = 0.5; //this is the factor that is used to adjust the square size

// and Here is how we store the all points in the game
  Map<int, Point> allPoints = {}; //key is the location aka the index of the point in the grid

  List<Color> colorSet = [
    Colors.purple, //color for
    Colors.white, //color for drag line
    Colors.blue, //dot color

    Colors.green, //human color
    Colors.red, //AI color

    Colors.white, //square icon box color //5th index

    Colors.red, //most recent line color //6th index
    Colors.teal, //old line color //7th index
    Colors.white, //color for new line glow//8th index
  ];

  List<IconData> iconSet = [
    Icons.check, //human
    Icons.close_rounded, //ai icon
  ];

  //a member to store the latest line that was drawn
  Line? latestLine; //this changes every time we add a line to map

  //a  member for all squares
  Map<String, Square> allSquares = {};

  //a  member to control the turns oof the player.
  bool myTurn = true; //if false then it is AI's turn

  //To add some spice to the game, we record the chain of square formation which is identified if the turn doesn't change and player keeps making squares

  int chainCount = 0; //this is the count of the squares formed in a chain we will play sounds based on this count

  void switchTurn() {
    print('Switching turn since No square was formed & chain count is $chainCount');

    myTurn = !myTurn;
    chainCount = 0; //reset chain square count as turn changes
    gamePlayStateForGui!.updateTurn(myTurn);
  }

  //the gameState will also have a GameCanvas instance that will be used for maintaining the info about the current level
  GameCanvas? gameCanvas;

  //we should have a map of all the valid lines in the game so that invalid lines may not be allowed to draw

  Map<String, Line> validLines = {};

  initGameCanvas({required int xPoints, required int yPoints}) {
    gameCanvas = GameCanvas(xPoints: xPoints, yPoints: yPoints);
    validLines = gameCanvas!.drawAllPossibleLines();
    //make sure to init the remaining lines in the gamestate for gui
    //number of squares initially = xPoints-1 * yPoints-1;
    gamePlayStateForGui!.initMovesLeftAndSquares(
      validLines.length,
      (xPoints - 1) * (yPoints - 1),
    );
    log('Valid lines: ${validLines.length}');
    GameState!.chainCount = 0;
  }

  //defining methods to change colors
  void changeBGColor(Color newColor) {
    colorSet[0] = newColor;
  }

  void changeLineColor(Color newColor) {
    colorSet[1] = newColor;
  }

  void changeDotColor(Color newColor) {
    colorSet[2] = newColor;
  }

  void changeHumanColor(Color newColor) {
    colorSet[3] = newColor;
  }

  void changeAIColor(Color newColor) {
    colorSet[4] = newColor;
  }

  void changeSquareIconBoxColor(Color newColor) {
    colorSet[5] = newColor;
  }

  void changeMostRecentLineColor(Color newColor) {
    colorSet[6] = newColor;
  }

  void changeOldLineColor(Color newColor) {
    colorSet[7] = newColor;
  }

  void changeHumanIcon(IconData newIcon) {
    iconSet[0] = newIcon;
  }

  void changeAIIcon(IconData newIcon) {
    iconSet[1] = newIcon;
  }

  void changeNewLineGlowColor(Color newColor) {
    colorSet[8] = newColor;
  }

  //reset the entire game state
  void resetGameState() {
    linesDrawn = {};
    allPoints = {};
    allSquares = {};
    myTurn = true;
    chainCount = 0;
    gameCanvas = GameCanvas(xPoints: 0, yPoints: 0);
    validLines = {};
    gamePlayStateForGui!.resetGame();
  }

  void dispose() {
    //making the state instances null to free up the resources
    gameCanvas = null;
    linesDrawn = {};
    allPoints = {};
    allSquares = {};
    validLines = {};
    colorSet = [];
    iconSet = [];
    log('Everything is destroyed to free up resources');
  }
}

GameStateClass? GameState;
