//this is a class that manages the bgm audio and the sfx audios for the UI.

import 'package:audioplayers/audioplayers.dart';

//enum for the components that will play audio

enum MyComponent { BUTTON, ADBFORLIVES, SHOWMORE, NEXT, RETRY, PROFILE, PLAYBUTTON, GOBACK, COLORCHANGE, DARKSWITCH, BGPICSELECTOR, USERPICSELECTOR, GETLIFE, BUYBUTTON, DOLLARSTAP, EXPANSIONTILE }

class AudioService {
  static AudioPlayer _audioPlayer = AudioPlayer();

  bool gameRunState = false; //to check if the game is running or not

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

  //method to change bgm
  //THIS METHOD TAKES AN INDEX OF THE BGM WHICH IF NOT PROVIDED WILL PLAY A RANDOM BGM
  void changeBGM({int? index}) async {
    index ??= 1;
    _audioPlayer.stop();
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource("assets/audio/bgm$index.wav"), volume: 0.2);
  }

  final double loudness = 0.5;

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
        AudioPlayer().play(AssetSource('audio/showmore.wav'), volume: loudness);
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
}
