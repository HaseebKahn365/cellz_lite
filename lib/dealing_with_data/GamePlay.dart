//This is a class that will be used to store the data of the game play
/*

  const createGameplaysTable = '''
      CREATE TABLE IF NOT EXISTS `Gameplays` (
        `id`	INTEGER NOT NULL UNIQUE,
        `dateTime`	INTEGER NOT NULL UNIQUE,
        `isCompleted`	INTEGER NOT NULL DEFAULT 1,
        `isWon`	INTEGER NOT NULL DEFAULT 0,
        `score`	INTEGER NOT NULL,
        `uid`	INTEGER NOT NULL,
        `fkLevelId`	INTEGER NOT NULL,
        PRIMARY KEY(`id`),
        FOREIGN KEY(`fkLevelId`) REFERENCES `Levels`(`id`)
      );
      ''';
      
we will use the line and the square classes from the buisiness logic whereas the LevelObject class is gonna be created in this file to represent a level 

There are two types of insertion that will be performed whenever the user plays.

1. gameStartInsertion() : this is the insertion that will happen as the game starts
this method is responsible for inserting an empty record in the GamePlay table of the databse. this record is identified as incomplete game.
here is how we insert a record at the start of the game:
 gid = latest new id for the game record
 dateTime = current datetime in milliseconds since epoch
 isCompleted = 0
  isWon = 0
  score = 0
  uid = current user id
  fkLevelId = the level id of the level that the user is playing

 

2. gameOverInsertion() : this is the insertion that will happen when the user completes the game
first we obtain the last gid from the GamePlay table
then we update the record with the following values:
  isCompleted = 1
  isWon = 1 if the user has won the game else 0
  score = the score of the game
  the record will be updated with the gid that we obtained earlier
the last record will be update will all the stats of the completed game. the recorded lines and squares will already be stored in the game state as
  static Map<String, Line> linesDrawn = {};
  static Map<String, Square> allSquares = {};
we will insert each one of the lines and squares in the databse with foreign key as the gid of the game record

lets create a state class that will be used to properly store and retrieve the data of the game play table in the database

 */

class LineForDb {
  final int fkGamePlayId;
  final int isMine;
  final int firstPIndex; //index of the first point from which line is drawn
  final int secondPIndex; //index of the point on which the line ends

  LineForDb({
    required this.fkGamePlayId,
    required this.isMine,
    required this.firstPIndex,
    required this.secondPIndex,
  });
}

class SquareForDb {
  final int fkGamePlayId;
  final int isMine;
  final int xCord;
  final int yCord;

  SquareForDb({
    required this.fkGamePlayId,
    required this.isMine,
    required this.xCord,
    required this.yCord,
  });
}

class GamePlayState {
  final int id;
  final int dateTime;
  final int isCompleted;
  final int isWon;
  final int score;
  final int uid;
  final int fkLevelId;

  GamePlayState({
    required this.id,
    required this.dateTime,
    required this.isCompleted,
    required this.isWon,
    required this.score,
    required this.uid,
    required this.fkLevelId,
  });

  @override
  String toString() {
    return '''GamePlayState{
      id: $id,
      dateTime: $dateTime,
      isCompleted: $isCompleted,
      isWon: $isWon,
      score: $score,
      uid: $uid,
      fkLevelId: $fkLevelId,
    }''';
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
