import 'lines.dart';

class Square {
  late Line topHoriz; //TOP HORIZONTAL LINE
  late Line bottomHoriz; //BOTTOM HORIZONTAL LINE
  late Line rightVert; //RIGHT VERTICAL LINE
  late Line leftVert; //LEFT VERTICAL LINE
  int xCord = 0;
  int yCord = 0; //these cordinates indicate the offset for the ui to show where to render the square
  bool isMine;

/*
    We know that the sum of 0+1 of topHoriz is less than the sum of 3+4 of bottom horiz. this means that the line with smaller sum and with direction as Horiz, is the topHoriz line.
  similarly in case of vertical lines
  0+3 < 1+4
  this indicates that 0-3 is the left vertical line
  1+4 is the right line

  */

  Square({required this.topHoriz, required this.bottomHoriz, required this.rightVert, required this.leftVert, required this.isMine}) {
    if (topHoriz.getSumOfPoints() > bottomHoriz.getSumOfPoints()) {
      Line temp = topHoriz;
      topHoriz = bottomHoriz;
      bottomHoriz = temp;
    }
    if (leftVert.getSumOfPoints() > rightVert.getSumOfPoints()) {
      Line temp = leftVert;
      leftVert = rightVert;
      rightVert = temp;
    }
    setSquareCordinates();
  }

  //now the coordinates of the point with least location will be the xCord and yCord of the square
  void setSquareCordinates() {
    //in the top horizontal line find the point with smaller location value and set its cordinates as the cordinates for the square
    if (topHoriz.firstPoint.location < topHoriz.secondPoint.location) {
      // print('no need to adjust the direction of the line');
      xCord = topHoriz.firstPoint.xCord;
      yCord = topHoriz.firstPoint.yCord;
    } else {
      // print('adjusting with the direction of the line');
      xCord = topHoriz.secondPoint.xCord;
      yCord = topHoriz.secondPoint.yCord;
    }
  }

  @override
  String toString() {
    return '''Square at ($xCord, $yCord) and lines {
    //Following notation contains indices of point to represent line!
    topHoriz: $topHoriz,
    bottomHoriz: $bottomHoriz,
    rightVert: $rightVert,
    leftVert: $leftVert
    }''';
  }

  String hashForMap() {
    return '$xCord$yCord';
  }

  //lets override the == operator to compare two squares
  @override
  bool operator ==(Object other) {
    if (other is Square) {
      return topHoriz == other.topHoriz && bottomHoriz == other.bottomHoriz && rightVert == other.rightVert && leftVert == other.leftVert;
    }
    return false;
  }
}
