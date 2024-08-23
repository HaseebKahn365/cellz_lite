//this is a class that manages the bgm audio and the sfx audios for the UI.

import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

//enum for the components that will play audio

enum MyComponent { BUTTON, ADBFORLIVES, SHOWMORE, NEXT, RETRY, PROFILE, PLAYBUTTON, GOBACK, COLORCHANGE, DARKSWITCH, BGPICSELECTOR, USERPICSELECTOR, GETLIFE, BUYBUTTON, DOLLARSTAP, EXPANSIONTILE }

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final AudioPlayer _squareSfxPlayer = AudioPlayer();

  bool gameRunState = false; //to check if the game is running or not

  //bg audio should come from online:
  /*
  https://assets.mixkit.co/music/138/138.mp3
  https://assets.mixkit.co/music/970/970.mp3
  https://assets.mixkit.co/music/989/989.mp3
  https://assets.mixkit.co/music/466/466.mp3
  https://assets.mixkit.co/music/759/759.mp3
  https://assets.mixkit.co/music/262/262.mp3

 */

  static const musicList = [
    'https://assets.mixkit.co/music/138/138.mp3',
    'https://assets.mixkit.co/music/970/970.mp3',
    'https://assets.mixkit.co/music/989/989.mp3',
    'https://assets.mixkit.co/music/466/466.mp3',
    'https://assets.mixkit.co/music/759/759.mp3',
    'https://assets.mixkit.co/music/262/262.mp3',
  ];

  //method to pause BGM
  void pauseBGM() {
    _audioPlayer.pause();
  }

  //method to resume BGM
  void resumeBGM() {
    _audioPlayer.resume();
  }

  //method for game start. CHANGE GAMESTATE, CHANGE BGM, RESUME BGM
  void gameStart() {
    gameRunState = true;
    changeBGM();
    resumeBGM();
  }

  void gameEnd() {
    gameRunState = false;
    _audioPlayer.stop();
  }

  //method to change bgm
  //THIS METHOD TAKES AN INDEX OF THE BGM WHICH IF NOT PROVIDED WILL PLAY A RANDOM BGM
  void changeBGM({int? index}) async {
    _audioPlayer.stop();
    final randIndex = Random().nextInt(musicList.length);
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // _audioPlayer.play(AssetSource("audio/bgm$index.wav"), volume: 0.2);
    //from url
    _audioPlayer.play(
        UrlSource(
          musicList[randIndex],
        ),
        volume: bgLoundness);
  }

  final double loudness = 0.5;
  final double bgLoundness = 0.06;

  //method to play sfx using provided component. IT WILL PAUSE THE BGM AND PLAY THE SFX THEN RESUME THE BGM WHILE MAINTAINING THE LENGTH OF THE BGM PLAYED
  void playSfx(MyComponent comp) {
    switch (comp) {
      case MyComponent.BUTTON:
        AudioPlayer().play(AssetSource('audio/button.wav'), volume: loudness);
        break;
      case MyComponent.ADBFORLIVES:
        AudioPlayer().play(AssetSource('audio/adblives.wav'), volume: loudness);
        break;
      case MyComponent.SHOWMORE:
        AudioPlayer().play(AssetSource('audio/show_more.wav'), volume: loudness);
        break;
      case MyComponent.NEXT:
        AudioPlayer().play(AssetSource('audio/next.wav'), volume: loudness);
        break;
      case MyComponent.RETRY:
        AudioPlayer().play(AssetSource('audio/retry.wav'), volume: loudness);
        break;
      case MyComponent.PROFILE:
        AudioPlayer().play(AssetSource('audio/profilesection.wav'), volume: loudness);
        break;
      case MyComponent.PLAYBUTTON:
        AudioPlayer().play(AssetSource('audio/playbutton.wav'), volume: loudness);
        break;
      case MyComponent.GOBACK:
        AudioPlayer().play(AssetSource('audio/goback.wav'), volume: loudness);
        break;
      case MyComponent.COLORCHANGE:
        AudioPlayer().play(AssetSource('audio/colorchange.wav'), volume: loudness);
        break;
      case MyComponent.DARKSWITCH:
        AudioPlayer().play(AssetSource('audio/darkswitch.wav'), volume: loudness);
        break;
      case MyComponent.BGPICSELECTOR:
        AudioPlayer().play(AssetSource('audio/bgpicselect.wav'), volume: loudness);
        break;
      case MyComponent.USERPICSELECTOR:
        AudioPlayer().play(AssetSource('audio/profilepic.wav'), volume: loudness);
        break;
      case MyComponent.GETLIFE:
        AudioPlayer().play(AssetSource('audio/getlife.wav'), volume: loudness);
        break;
      case MyComponent.BUYBUTTON:
        AudioPlayer().play(AssetSource('audio/buybutton.wav'), volume: loudness);
        break;
      default:
        break;
    }
  }

  int timeLastPlayed = DateTime.now().millisecondsSinceEpoch;

  void playSquareSfx(int count) {
    if ((DateTime.now().millisecondsSinceEpoch - timeLastPlayed) < 50) {
      return;
    }
    timeLastPlayed = DateTime.now().millisecondsSinceEpoch;
    switch (count) {
      case 2:
        //stop the cuurent
        // _squareSfxPlayer.stop();
        AudioPlayer().play(AssetSource('audio/2.wav'), volume: loudness);
        break;
      case 3:
        // _squareSfxPlayer.stop();
        AudioPlayer().play(AssetSource('audio/3.wav'), volume: loudness);
        break;
      case 4:
        // _squareSfxPlayer.stop();
        AudioPlayer().play(AssetSource('audio/4.wav'), volume: loudness);
        break;
      case 5:
        // _squareSfxPlayer.stop();
        AudioPlayer().play(AssetSource('audio/5.wav'), volume: loudness);
        break;
      case 6:
        // _squareSfxPlayer.stop();
        AudioPlayer().play(AssetSource('audio/6.wav'), volume: loudness);
        break;
      case 7:
        // _squareSfxPlayer.stop();
        AudioPlayer().play(AssetSource('audio/7.wav'), volume: loudness);
        break;
      case 8:
        // _squareSfxPlayer.stop();
        AudioPlayer().play(AssetSource('audio/8.wav'), volume: loudness);
        break;
      case 9:
        // _squareSfxPlayer.stop();
        AudioPlayer().play(AssetSource('audio/9.wav'), volume: loudness);
        break;
      case 10:
        // _squareSfxPlayer.stop();

        AudioPlayer().play(AssetSource('audio/10.wav'), volume: loudness);
        break;
      default:
        AudioPlayer().play(AssetSource('audio/combo.wav'), volume: loudness);
        break;
    }
  }
}
