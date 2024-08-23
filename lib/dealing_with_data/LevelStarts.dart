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
    log('initial stats: $stars , and time: $time');
    thresholdSeconds = (((levelObject.xPoints - 1) * levelObject.yPoints) + ((levelObject.yPoints - 1) * levelObject.xPoints) * ((levelObject.id > 3) ? 0.9 : 1)).toInt();
    log('thresholdSeconds: $thresholdSeconds for level: ${levelObject.id}');
    totalScore = (levelObject.xPoints - 1) * (levelObject.yPoints - 1);
    log('totalScore: $totalScore for level: ${levelObject.id}');
    displayObjectState();
  }

  void displayObjectState() {
    log('stars: $stars, \n time: $time, \n totalScore: $totalScore, \n thresholdSeconds: $thresholdSeconds');
    log('newTime: $newTime, \n newScore: $newScore');
  }

  int newStars = 0;

  void updateStoredData(int score, int time) {
    log('updating stored data for level: ${levelObject.id}');
    log('incoming score: $score, incoming time: $time');
    newTime = time;
    newScore = score;
    int tempStars = calculateStars();
    saveStats(tempStars);
    newStars = tempStars;
    log('Saved stats for level: ${levelObject.id} are stars: $stars, time: $time');
    notifyListeners();
  }

  double secondStarCritera() {
    if (levelObject.id == 60) return 0.80 * totalScore;
    if (levelObject.id == 61) return 0.82 * totalScore;
    if (levelObject.id == 62) return 0.85 * totalScore;
    if (levelObject.id == 63) return 0.87 * totalScore;
    if (levelObject.id == 64) return 0.9 * totalScore;
    if (levelObject.id == 65) return 0.95 * totalScore;
    return (0.7 * totalScore);
  }

  int calculateStars() {
    bool first = false;
    bool second = false;
    bool third = false;

    if (newScore > (0.5 * totalScore)) {
      log('criteria for first star: ${0.5 * totalScore} has been met because new score is $newScore');
      first = true;
    }

    log('second star criteria: ${secondStarCritera()}');

    if (newScore > secondStarCritera().toInt()) {
      log('criteria for second star: ${secondStarCritera().toInt()} has been met because new score is $newScore');
      second = true;
    }

    log('third star criteria: $thresholdSeconds seconds new time: $newTime');

    if ((newTime < thresholdSeconds) && second) {
      log('criteria for third star: $thresholdSeconds seconds has been met because new time is $newTime');
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
      log('new stars for saving stats : $tempStars, old stars: $stars so updating the stats');
      stars = tempStars;
      time = newTime;
    } else if (tempStars == stars) {
      if (newTime < time) {
        log(' stars same but new time: $newTime, old time: $time so updating the stats');
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
      time = prefs.getInt('${levelObject.id}time') ?? thresholdSeconds;
      // stars = 0;
      // time = 0;
      notifyListeners();
    });

    log('stats loaded for level: ${levelObject.id} ${(stars != 0) ? 'stars: $stars, time: $time' : ''}');
  }
}
