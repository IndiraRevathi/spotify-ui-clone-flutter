import 'package:flutter/material.dart';
import 'package:spotify__uiclone/audio_manager.dart';

class BottomPlayerBar extends StatefulWidget {
  const BottomPlayerBar({Key? key}) : super(key: key);

  @override
  _BottomPlayerBarState createState() => _BottomPlayerBarState();
}

class _BottomPlayerBarState extends State<BottomPlayerBar> {
  final AudioManager audioManager = AudioManager();
  double _volume = 0.5;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    audioManager.addListener(_updateState);
    audioManager.setVolume(_volume);
  }

  @override
  void dispose() {
    audioManager.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (audioManager.currentSong == null) {
      return const SizedBox.shrink();
    }

    final song = audioManager.currentSong!;

    if (_isExpanded) {
      return _buildExpandedPlayer(song);
    }

    return _buildCollapsedPlayer(song);
  }

  Widget _buildCollapsedPlayer(Song song) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = true;
        });
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          border: Border(top: BorderSide(color: Colors.grey[800]!, width: 0.5)),
        ),
        child: Row(
          children: [
            // Song Info
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Image(
                    image: AssetImage(song.imagePath),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          song.artist,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.grey),
                    onPressed: () {},
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            // Controls
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.shuffle,
                          color: audioManager.isShuffled
                              ? Colors.green
                              : Colors.grey[400],
                          size: 20,
                        ),
                        onPressed: () => audioManager.toggleShuffle(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 28),
                        color: Colors.white,
                        onPressed: () => audioManager.previous(),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(
                            audioManager.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 28,
                            color: Colors.black,
                          ),
                          onPressed: () => audioManager.playPause(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 28),
                        color: Colors.white,
                        onPressed: () => audioManager.next(),
                      ),
                      IconButton(
                        icon: Icon(
                          audioManager.isRepeating
                              ? Icons.repeat
                              : Icons.repeat_one,
                          color: audioManager.isRepeating
                              ? Colors.green
                              : Colors.grey[400],
                          size: 20,
                        ),
                        onPressed: () => audioManager.toggleRepeat(),
                      ),
                    ],
                  ),
                  // Progress Bar
                  StreamBuilder<Duration>(
                    stream: audioManager.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = audioManager.duration;
                      final progress = duration.inMilliseconds > 0
                          ? position.inMilliseconds / duration.inMilliseconds
                          : 0.0;

                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                        ),
                        child: Slider(
                          value: progress.clamp(0.0, 1.0),
                          onChanged: (value) {
                            final newPosition = Duration(
                              milliseconds: (value * duration.inMilliseconds)
                                  .round(),
                            );
                            audioManager.seek(newPosition);
                          },
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey[800],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Volume & Expand
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.queue_music, color: Colors.grey[400], size: 20),
                  const SizedBox(width: 8),
                  Icon(Icons.volume_up, color: Colors.grey[400], size: 20),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                      ),
                      child: Slider(
                        value: _volume,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                          });
                          audioManager.setVolume(value);
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey[800],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.expand_less, size: 20),
                    color: Colors.grey[400],
                    onPressed: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedPlayer(Song song) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1DB954), Color(0xFF121212), Color(0xFF121212)],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.expand_more, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _isExpanded = false;
                        });
                      },
                    ),
                    const Spacer(),
                    const Text(
                      'Now Playing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Album Art
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image(
                          image: AssetImage(song.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Song Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      song.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      song.artist,
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: StreamBuilder<Duration>(
                  stream: audioManager.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = audioManager.duration;
                    final progress = duration.inMilliseconds > 0
                        ? position.inMilliseconds / duration.inMilliseconds
                        : 0.0;

                    return Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 16,
                            ),
                          ),
                          child: Slider(
                            value: progress.clamp(0.0, 1.0),
                            onChanged: (value) {
                              final newPosition = Duration(
                                milliseconds: (value * duration.inMilliseconds)
                                    .round(),
                              );
                              audioManager.seek(newPosition);
                            },
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey[700],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: audioManager.isShuffled
                            ? Colors.green
                            : Colors.grey[400],
                        size: 28,
                      ),
                      onPressed: () => audioManager.toggleShuffle(),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 40),
                      color: Colors.white,
                      onPressed: () => audioManager.previous(),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(
                          audioManager.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () => audioManager.playPause(),
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 40),
                      color: Colors.white,
                      onPressed: () => audioManager.next(),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        audioManager.isRepeating
                            ? Icons.repeat
                            : Icons.repeat_one,
                        color: audioManager.isRepeating
                            ? Colors.green
                            : Colors.grey[400],
                        size: 28,
                      ),
                      onPressed: () => audioManager.toggleRepeat(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Bottom Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.grey[400],
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.grey[400],
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.queue_music,
                        color: Colors.grey[400],
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.devices,
                        color: Colors.grey[400],
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
