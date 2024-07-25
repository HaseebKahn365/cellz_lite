//Here is representation of a line in the game.

import 'dart:developer';

import 'package:cellz_lite/business_logic/game_state.dart';
import 'package:cellz_lite/business_logic/square.dart';

import 'point.dart';

//enum to show if the line is horizontal or vertical
enum LineDirection { horiz, vert }

class Line {
  Point firstPoint;
  Point secondPoint;
  bool isMine; //to show if the line is created by the player or the AI
  late LineDirection direction;

  Line({required this.firstPoint, required this.secondPoint, this.isMine = false}) {
    if (firstPoint.xCord == secondPoint.xCord) {
      direction = LineDirection.vert;
    } else {
      direction = LineDirection.horiz;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is Line) {
      return (firstPoint == other.firstPoint && secondPoint == other.secondPoint) || (firstPoint == other.secondPoint && secondPoint == other.firstPoint);
    }
    return false;
  }

  @override
  int get hashCode {
    // Ensure the hash code is the same regardless of the order of the points
    return firstPoint.hashCode ^ secondPoint.hashCode;
  }

  //coverting the line to string for proper storage in the Map
  @override
  String toString() {
    int firstLocation = firstPoint.location;
    int secondLocation = secondPoint.location;
    if (firstLocation < secondLocation) {
      return '$firstLocation-$secondLocation';
    } else {
      return '$secondLocation-$firstLocation';
    }
  }

  //creating a factory constructor to create a line from a string
  factory Line.fromString(String lineString) {
    List<String> points = lineString.split('-');
    Point firstPoint = GameState!.allPoints[int.parse(points[0])]!;
    Point secondPoint = GameState!.allPoints[int.parse(points[1])]!;
    return Line(firstPoint: firstPoint, secondPoint: secondPoint, isMine: GameState!.myTurn);
  }

  //before adding a line we covert it to string and check if it already exists in the Map
  bool isAlreadyLineDrawn() {
    //check for both cases ie. reverse the points and check again
    return GameState!.linesDrawn.containsKey(toString()) || GameState!.linesDrawn.containsKey('${secondPoint.location}-${firstPoint.location}');
  }

  //adding the line to the Map
  void addLineToMap() {
    if (!isAlreadyLineDrawn()) {
      GameState!.linesDrawn[toString()] = this;
      GameState!.latestLine = this; //! new change
      log('Line added successfully and we have updated our latest line!');
    }
    log('Line already exists');
  }

  //getting the sum of the locations of the two points of the line
  int getSumOfPoints() {
    return firstPoint.location + secondPoint.location;
  }

  //instead of returning a bool we need to return a list of squares that are formed by the line

  Map<String, Square> checkSquare() {
    Map<String, Square> squares = {};
    if (direction == LineDirection.horiz) {
      print('The line is horizontal and is under test for above and below squares');
      print('First point: $firstPoint, Second point: $secondPoint');
      Point p1 = firstPoint;
      Point p2 = secondPoint;

      // Check for the square above the line

      //making sure that we name the p1 and p2 properly
      print('I am a horizontal line and here are my first p1 and p2');
      print("p1 location: " + p1.location.toString());
      print("p2 location: " + p2.location.toString());

      Point? p3 = GameState!.allPoints[p1.location - (GameState!.gameCanvas!.xPoints)];
      Point? p4 = GameState!.allPoints[p2.location - (GameState!.gameCanvas!.xPoints)];

      print(p1.location - (GameState!.gameCanvas!.xPoints));
      print(p2.location - (GameState!.gameCanvas!.xPoints));

      print('Above line - p3: $p3, p4: $p4');
      if (p3 != null && p4 != null) {
        Line topHoriz = Line(firstPoint: p3, secondPoint: p4);
        Line leftVert = Line(firstPoint: p3, secondPoint: p1);
        Line rightVert = Line(firstPoint: p4, secondPoint: p2);
        print('Above line - topHoriz: $topHoriz, leftVert: $leftVert, rightVert: $rightVert');

        if (GameState!.linesDrawn.containsKey(topHoriz.toString()) && GameState!.linesDrawn.containsKey(leftVert.toString()) && GameState!.linesDrawn.containsKey(rightVert.toString())) {
          print('Square found above the line');
          //adding the square to the list of squares in the game state and also for returning:
          Square aboveSquare = Square(topHoriz: topHoriz, bottomHoriz: this, leftVert: leftVert, rightVert: rightVert, isMine: GameState!.myTurn);

          GameState!.allSquares[aboveSquare.hashForMap()] = aboveSquare; // [aboveSquare.hashForMap()] = aboveSquare;
          print('New square added to allSquares: ' + GameState!.allSquares.toString());
          squares[aboveSquare.hashForMap()] = aboveSquare;

          // return true;
        } else {
          print('Square not complete above the line');
        }
      } else {
        print('Points above the line are null');
      }

      // Check for the square below the line
      print('Checking for square below the line');
      if (p1.yCord < GameState!.gameCanvas!.yPoints && p2.yCord < GameState!.gameCanvas!.yPoints) {
        Point? p3 = GameState!.allPoints[p1.location + (GameState!.gameCanvas!.xPoints)];
        Point? p4 = GameState!.allPoints[p2.location + (GameState!.gameCanvas!.xPoints)];
        print('Below line - new p3: $p3, new p4: $p4');
        if (p3 != null && p4 != null) {
          Line bottomHoriz = Line(firstPoint: p3, secondPoint: p4);
          Line leftVert = Line(firstPoint: p1, secondPoint: p3);
          Line rightVert = Line(firstPoint: p2, secondPoint: p4);
          print('Below line - bottomHoriz: $bottomHoriz, leftVert: $leftVert, rightVert: $rightVert');

          if (GameState!.linesDrawn.containsKey(bottomHoriz.toString()) && GameState!.linesDrawn.containsKey(leftVert.toString()) && GameState!.linesDrawn.containsKey(rightVert.toString())) {
            print('Square found below the line');
            //adding the square to the list of squares:
            Square belowSquare = Square(topHoriz: this, bottomHoriz: bottomHoriz, leftVert: leftVert, rightVert: rightVert, isMine: GameState!.myTurn);
            GameState!.allSquares[belowSquare.hashForMap()] = belowSquare;
            squares[belowSquare.hashForMap()] = belowSquare;

            print('New square added to allSquares: ' + GameState!.allSquares.toString());

            return squares;
          } else {
            print('Square not complete below the line');
          }
        } else {
          print('Points below the line are null');
        }
      }
    } else {
      print('The line is vertical and is under test for left and right squares');
      Point p1 = firstPoint;
      Point p2 = secondPoint;

      // Check for the square to the left of the line
      print('Checking for square to the left of the line');

      Point? p3 = GameState!.allPoints[p1.location - 1];
      Point? p4 = GameState!.allPoints[p2.location - 1];
      print('Left of line - p3: $p3, p4: $p4');
      if (p3 != null && p4 != null) {
        Line leftVert = Line(firstPoint: p3, secondPoint: p4);
        Line topHoriz = Line(firstPoint: p3, secondPoint: p1);
        Line bottomHoriz = Line(firstPoint: p4, secondPoint: p2);
        print('Left of line - leftVert: $leftVert, topHoriz: $topHoriz, bottomHoriz: $bottomHoriz');

        if (GameState!.linesDrawn.containsKey(leftVert.toString()) && GameState!.linesDrawn.containsKey(topHoriz.toString()) && GameState!.linesDrawn.containsKey(bottomHoriz.toString())) {
          print('Square found to the left of the line');
          //adding the square to the list of squares:
          Square leftSquare = Square(topHoriz: topHoriz, bottomHoriz: bottomHoriz, leftVert: leftVert, rightVert: this, isMine: GameState!.myTurn);

          GameState!.allSquares[leftSquare.hashForMap()] = leftSquare;
          squares[leftSquare.hashForMap()] = leftSquare;

          print('New square added to allSquares: ' + GameState!.allSquares.toString());

          // return true;
        } else {
          print('Square not complete to the left of the line');
        }
      } else {
        print('Points to the left of the line are null');
      }

      // Check for the square to the right of the line
      print('Checking for square to the right of the line');
      if (p1.xCord < GameState!.gameCanvas!.xPoints - 1 && p2.xCord < GameState!.gameCanvas!.xPoints - 1) {
        Point? p3 = GameState!.allPoints[p1.location + 1];
        Point? p4 = GameState!.allPoints[p2.location + 1];
        print('Right of line - p3: $p3, p4: $p4');
        if (p3 != null && p4 != null) {
          Line rightVert = Line(firstPoint: p3, secondPoint: p4);
          Line topHoriz = Line(firstPoint: p1, secondPoint: p3);
          Line bottomHoriz = Line(firstPoint: p2, secondPoint: p4);
          print('Right of line - rightVert: $rightVert, topHoriz: $topHoriz, bottomHoriz: $bottomHoriz');

          if (GameState!.linesDrawn.containsKey(rightVert.toString()) && GameState!.linesDrawn.containsKey(topHoriz.toString()) && GameState!.linesDrawn.containsKey(bottomHoriz.toString())) {
            print('Square found to the right of the line');
            //adding the square to the list of squares:
            Square rightSquare = Square(topHoriz: topHoriz, bottomHoriz: bottomHoriz, leftVert: this, rightVert: rightVert, isMine: GameState!.myTurn);

            GameState!.allSquares[rightSquare.hashForMap()] = rightSquare; // [rightSquare.hashForMap()] = rightSquare;
            squares[rightSquare.hashForMap()] = rightSquare;

            return squares;
          } else {
            print('Square not complete to the right of the line');
          }
        } else {
          print('Points to the right of the line are null');
        }
      }
    }
    if (squares.isNotEmpty) {
    } else {
      log('HHHey! swtiching turns since no square is formed');
      GameState!.switchTurn();
    }

    return squares;
  }
}
