import 'package:just_audio/just_audio.dart';

class AudioService {
  final _player = AudioPlayer();

  Future<void> play(String path) async {
    await _player.setFilePath(path);
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
