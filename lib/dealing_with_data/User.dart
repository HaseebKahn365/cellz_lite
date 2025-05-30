//this is a class that represents a user and his data. it is used in both db and ui

import 'dart:developer';
import 'dart:io';

import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String name = 'Anon';
  int score = 0;
  int currentLevelIndex = 0;
  int wins = 0;
  int losses = 0;
  int lives = 5;
  int lastScore = 0;
  int lastTotalScore = 1;
  int nextLifeDateTime = 0;
  int avatarIndex = 0;

  SharedPreferences? _prefs;

  UserProvider() {
    loadAllPrefs();
  }

  void emptyUpdate() {
    notifyListeners();
  }

//we need t save and load the useKey
  Future<void> loadAllPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    name = _prefs?.getString('name') ?? 'You';
    score = _prefs?.getInt('score') ?? 0;
    // currentLevelIndex = _prefs?.getInt('currentLevelIndex') ?? 0;

    currentLevelIndex = 64;
    wins = _prefs?.getInt('wins') ?? 0;
    losses = _prefs?.getInt('losses') ?? 0;
    lives = _prefs?.getInt('lives') ?? 5;
    lastScore = _prefs?.getInt('lastScore') ?? 0;
    lastTotalScore = _prefs?.getInt('lastTotalScore') ?? 1;
    nextLifeDateTime = _prefs?.getInt('nextLifeDateTime') ?? 0;
    avatarIndex = _prefs?.getInt('avatarIndex') ?? 0;
    usedKey = _prefs?.getString('usedKey') ?? 'dfdsf';
    notifyListeners();
  }

  Future<void> _saveToPrefs(String key, dynamic value) async {
    if (_prefs == null) return;
    if (value is String) {
      await _prefs!.setString(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is bool) {
      await _prefs!.setBool(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    }
  }

  void incrementLife() {
    if (lives < 10) {
      lives++;
      _saveToPrefs('lives', lives);
      notifyListeners();
    }
  }

  bool hasLives() {
    return lives > 0;
  }

  void decrementLives() {
    if (lives > 0) {
      lives--;
      _saveToPrefs('lives', lives);
      notifyListeners();
    }
  }

  String usedKey = 'dfdsf';

  void changeName(String newName) async {
    if (usedKey != newName) {
      //lets see if the new name is a key to premium pack for lives:
      int currentTimeMs = DateTime.now().millisecondsSinceEpoch;

      int twoDigitPrefix = int.parse(currentTimeMs.toString().substring(6, 8)); //changes after 100s

      int key = twoDigitPrefix * 365;

      //old name + key
      String keyString = name + key.toString();

      //check if new name is = to keyString
      if (newName == keyString) {
        usedKey = keyString;
        log('valid new key:  $usedKey');
        addAmountLives(100);
        await _saveToPrefs('lives', lives);
        //save the usedKey
        await _saveToPrefs('usedKey', usedKey);

        await _saveToPrefs('name', newName);

        exit(0); //close the
      }
    } else {
      log('invalid key: match found with used key');
    }
    log('new name is: $newName');
    name = newName;
    _saveToPrefs('name', name);

    notifyListeners();
  }

  void incrementWins() {
    wins++;
    _saveToPrefs('wins', wins);
    notifyListeners();
  }

  void incrementLosses() {
    losses++;
    _saveToPrefs('losses', losses);
    notifyListeners();
  }

  void updateScore(int newScore) {
    score += newScore;
    _saveToPrefs('score', score);
    notifyListeners();
  }

  void updateNextLifeTime(int time) {
    nextLifeDateTime = time;
    _saveToPrefs('nextLifeDateTime', nextLifeDateTime);
    notifyListeners();
  }

  Future<void> lastPlay(int myScore, int totalScore) async {
    lastScore = myScore;

    await _saveToPrefs('lastScore', lastScore);
    lastTotalScore = totalScore;

    await ('lastTotalScore', lastTotalScore);

    updateScore(myScore);
  }

  void updateCurrentLevelIndex(int index) {
    if (index < levels.length) {
      currentLevelIndex = index;
    }
    _saveToPrefs('currentLevelIndex', currentLevelIndex);
    notifyListeners();
  }

  void addAmountLives(int amount) {
    lives += amount;
    _saveToPrefs('lives', lives);
    notifyListeners();
  }

  void updateAvatarIndex(int index) {
    avatarIndex = index;
    _saveToPrefs('avatarIndex', avatarIndex);
    notifyListeners();
  }
}
