import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:mb/data/enums/sound_identifier.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSound(SoundIdentifier type) async {
    try {
      String assetPath = '';

      switch (type) {
        case SoundIdentifier.MEOW:
          assetPath = SoundService.getRandomSoundPath(SoundIdentifier.MEOW);
          break;
        case SoundIdentifier.POP:
          assetPath = SoundService.getRandomSoundPath(SoundIdentifier.POP);
          break;
      }

      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  Future<void> stopNotificationSound() async {
    await _audioPlayer.stop();
  }

  static String getRandomSoundPath(SoundIdentifier type) {
    int randomNumber;
    String basePath = 'sounds/';

    switch (type) {
      case SoundIdentifier.MEOW:
        randomNumber = Random().nextInt(5) + 1;
        return '${basePath}meow_$randomNumber.mp3';

      case SoundIdentifier.POP:
        randomNumber = Random().nextInt(5) + 1;
        return '${basePath}pop_$randomNumber.mp3';
    }
  }
}
