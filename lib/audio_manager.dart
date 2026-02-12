// lib/audio_manager.dart

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Song {
  final String title;
  final String artist;
  final String imagePath;
  final String audioPath;

  Song({
    required this.title,
    required this.artist,
    required this.imagePath,
    required this.audioPath,
  });
}

class AudioManager extends ChangeNotifier {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  AudioManager._internal() {
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleSongEnd();
      }
      notifyListeners();
    });

    player.positionStream.listen((_) {
      notifyListeners();
    });
  }

  final AudioPlayer player = AudioPlayer();

  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffled = false;
  bool _isRepeating = false;
  List<int> _shuffledIndices = [];

  Song? get currentSong => _currentSong;
  bool get isPlaying => player.playing;
  bool get isShuffled => _isShuffled;
  bool get isRepeating => _isRepeating;
  Duration get position => player.position;
  Duration get duration => player.duration ?? Duration.zero;
  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration?> get durationStream => player.durationStream;

  Future<void> playSong(Song song, {List<Song>? playlist}) async {
    _currentSong = song;
    if (playlist != null) {
      _playlist = playlist;
      _currentIndex = playlist.indexOf(song);
    }
    await player.stop();
    await player.setAsset(song.audioPath);
    await player.play();
    notifyListeners();
  }

  Future<void> playPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
    notifyListeners();
  }

  Future<void> pause() async {
    await player.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await player.stop();
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    await player.setVolume(volume.clamp(0.0, 1.0));
    notifyListeners();
  }

  Future<void> next() async {
    if (_playlist.isEmpty) return;

    if (_isShuffled) {
      int currentShuffledIndex = _shuffledIndices.indexOf(_currentIndex);
      if (currentShuffledIndex < _shuffledIndices.length - 1) {
        _currentIndex = _shuffledIndices[currentShuffledIndex + 1];
      } else if (_isRepeating) {
        _currentIndex = _shuffledIndices[0];
      } else {
        return;
      }
    } else {
      if (_currentIndex < _playlist.length - 1) {
        _currentIndex++;
      } else if (_isRepeating) {
        _currentIndex = 0;
      } else {
        return;
      }
    }

    await playSong(_playlist[_currentIndex]);
  }

  Future<void> previous() async {
    if (_playlist.isEmpty) return;

    if (player.position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    if (_isShuffled) {
      int currentShuffledIndex = _shuffledIndices.indexOf(_currentIndex);
      if (currentShuffledIndex > 0) {
        _currentIndex = _shuffledIndices[currentShuffledIndex - 1];
      } else if (_isRepeating) {
        _currentIndex = _shuffledIndices[_shuffledIndices.length - 1];
      } else {
        return;
      }
    } else {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else if (_isRepeating) {
        _currentIndex = _playlist.length - 1;
      } else {
        return;
      }
    }

    await playSong(_playlist[_currentIndex]);
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    if (_isShuffled && _playlist.isNotEmpty) {
      _shuffledIndices = List.generate(_playlist.length, (i) => i)..shuffle();
      _shuffledIndices.remove(_currentIndex);
      _shuffledIndices.insert(0, _currentIndex);
    }
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    notifyListeners();
  }

  void _handleSongEnd() {
    if (_isRepeating) {
      player.seek(Duration.zero);
      player.play();
    } else {
      next();
    }
  }

  void dispose() {
    player.dispose();
    super.dispose();
  }
}
