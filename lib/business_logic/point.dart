class Point {
  int xCord;
  int yCord;
  bool isDisabled = false;
  int timesUsed = 0; //it shows how many times the point is used as part of the lines. if it becomes 4, the point is disabled.
  int location; //it shows the index of the point in the grid
  Point({required this.xCord, required this.yCord, required this.location});

  void incrementPointUsage() {
    timesUsed++;
    if (timesUsed == 4) {
      isDisabled = true;
    }
  }

  bool checkDisability() {
    return isDisabled;
  }

  bool operator ==(Object other) {
    if (other is Point) {
      return xCord == other.xCord && yCord == other.yCord;
    }
    return false;
  }

  @override
  String toString() {
    return 'Point at ($xCord, $yCord) isDisabled: $isDisabled, timesUsed: $timesUsed, location: $location';
  }
}
