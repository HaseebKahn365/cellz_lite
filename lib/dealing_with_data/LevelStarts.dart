//this is is a provider that will have the data and methods to store the stars information about each level

import 'dart:developer';

import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelStarObject extends ChangeNotifier {
  int stars = 0;
  int time = 0;
  int totalScore = 0;
  final LevelObject levelObject;
  int thresholdSeconds = 1; //this is just for initalization but this variable store the time in seconds that the player has to beat to get 3 stars

  //variables to store info about the new game played
  int newTime = 0;
  int newScore = 0;

  LevelStarObject({required this.levelObject}) {
    thresholdSeconds = ((levelObject.xPoints - 1) * levelObject.yPoints) + ((levelObject.yPoints - 1) * levelObject.xPoints) * 3;
    totalScore = levelObject.xPoints - 1 * levelObject.yPoints - 1;
  }

  void updateStoredData(int score, int time) {
    newTime = time;
    newScore = score;
    int tempStars = calculateStars();
    saveStats(tempStars);
    notifyListeners();
  }

  double secondStarCritera() {
    return 0.7 * totalScore;
  }

  int calculateStars() {
    bool first = false;
    bool second = false;
    bool third = false;

    if (newScore > 0.5 * totalScore) {
      first = true;
    }

    if (newScore > secondStarCritera()) {
      second = true;
    }

    if ((newTime < thresholdSeconds) && second) {
      third = true;
    }

    return (third)
        ? 3
        : (second)
            ? 2
            : (first)
                ? 1
                : 0;
  }

  void saveStats(int tempStars) {
    if (tempStars > stars) {
      stars = tempStars;
      time = newTime;
    } else if (tempStars == stars) {
      if (newTime < time) {
        time = newTime;
      }
    }

//now lets save the new stats using sharedPrefs and notify the listeners to update the UI. we need to concatenate stars and time with the levelid before saving it
    try {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setInt('${levelObject.id}stars', stars);
        prefs.setInt('${levelObject.id}time', time);
        log('stats saved');
      });
    } catch (e) {
      log('error saving stats');
    }
  }

  void getStoredStats() {
    SharedPreferences.getInstance().then((prefs) {
      stars = prefs.getInt('${levelObject.id}stars') ?? 0;
      time = prefs.getInt('${levelObject.id}time') ?? 0;
      notifyListeners();
    });

    log('stats loaded for level: ${levelObject.id}');
  }
}
