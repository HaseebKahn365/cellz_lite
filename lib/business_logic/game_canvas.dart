/*
This is an important class that represents a level in the game.
it contains the number of x points and y points.
it contains the number of movesLeft 
it also contains the following methods

createPoints() : creates the points for the level and fills the allPoints map
calculateMovesLeft() : calculates the number of moves left in the game
decrementMovesLeft() : decrements the number of moves left

 */

import 'package:cellz_lite/business_logic/game_state.dart';

import 'lines.dart';
import 'point.dart';

GameCanvas gameCanvas = GameCanvas(xPoints: 4, yPoints: 4);

class GameCanvas {
  int xPoints;
  int yPoints;
  late int movesLeft;
  GameCanvas({required this.xPoints, required this.yPoints}) {
    createPoints();
    calculateMovesLeft();
  }

  void createPoints() {
    // Make sure to empty the allPoints map before adding new points
    // Also make sure to empty the linesDrawn map
    GameState!.allPoints = {};
    GameState!.linesDrawn = {};

    for (int j = 0; j < yPoints; j++) {
      for (int i = 0; i < xPoints; i++) {
        GameState!.allPoints[j * xPoints + i] = Point(xCord: i, yCord: j, location: j * xPoints + i);
      }
    }
  }

  void calculateMovesLeft() {
    movesLeft = ((xPoints - 1) * yPoints) + ((yPoints - 1) * xPoints);
  }

  void decrementMovesLeft() {
    movesLeft--;
  }

  //creating a method that will be used to draw every possible line and returns a map of Lines

  Map<String, Line> drawAllPossibleLines() {
    //example :   {{0-1 : Line(firstPoint: Point(xCord: 0, yCord: 0), secondPoint: Point(xCord: 1, yCord: 0), direction: LineDirection.horiz)},...}

    Map<String, Line> allPossibleLines = {};

    // Drawing horizontal lines
    for (int j = 0; j < yPoints; j++) {
      for (int i = 0; i < xPoints - 1; i++) {
        Point? firstPoint = GameState!.allPoints[j * xPoints + i];
        Point? secondPoint = GameState!.allPoints[j * xPoints + (i + 1)];

        if (firstPoint != null && secondPoint != null) {
          final lineObj = Line(
            firstPoint: firstPoint,
            secondPoint: secondPoint,
          );
          allPossibleLines[lineObj.toString()] = lineObj;
        }
      }
    }

    //drawing vertical lines
    for (int i = 0; i < xPoints; i++) {
      for (int j = 0; j < yPoints - 1; j++) {
        Point? firstPoint = GameState!.allPoints[j * xPoints + i];
        Point? secondPoint = GameState!.allPoints[(j + 1) * xPoints + i];

        if (firstPoint != null && secondPoint != null) {
          final lineObj = Line(
            firstPoint: firstPoint,
            secondPoint: secondPoint,
          );
          allPossibleLines[lineObj.toString()] = lineObj;
        }
      }
    }

    return allPossibleLines;
  }
}
