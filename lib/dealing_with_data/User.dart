//this is a class that represents a user and his data. it is used in both db and ui

import 'package:flutter/material.dart';

//the user player class acts as a provider to monitor any changes and upload them to database

class UserProvider extends ChangeNotifier {
  String name = 'Anon';
  int score = 0;
  int currentLevelIndex = 0;
  int wins = 0;
  int losses = 0;
  int lives = 5;
  int lastScore = 0; //score of the last game played
}
