import 'package:flutter/material.dart';
import 'package:spotify__uiclone/widgets/album_card.dart';
import '../audio_manager.dart';

class AlbumView extends StatefulWidget {
  final Song song;
  final List<Song>? playlist;

  const AlbumView({required this.song, this.playlist, Key? key})
    : super(key: key);

  @override
  _AlbumViewState createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  final audio = AudioManager();
  late ScrollController scrollController;

  double imageSize = 240;
  double containerHeight = 500;
  double imageOpacity = 1;
  bool showTopBar = false;

  @override
  void initState() {
    super.initState();
    audio.addListener(_updateState);

    scrollController = ScrollController()
      ..addListener(() {
        final offset = scrollController.offset;

        setState(() {
          imageSize = (240 - offset).clamp(0, 240);
          containerHeight = (500 - offset).clamp(0, 500);
          imageOpacity = (imageSize / 240).clamp(0.0, 1.0);

          showTopBar = offset > 220;
        });
      });
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> togglePlay() async {
    if (audio.currentSong?.audioPath == widget.song.audioPath &&
        audio.isPlaying) {
      await audio.pause();
    } else {
      await audio.playSong(
        widget.song,
        playlist: widget.playlist ?? [widget.song],
      );
    }
  }

  @override
  void dispose() {
    audio.removeListener(_updateState);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardSize = MediaQuery.of(context).size.width / 2 - 32;

    return Scaffold(
      body: Stack(
        children: [
          // HEADER IMAGE
          Container(
            height: containerHeight,
            color: Colors.pink,
            alignment: Alignment.center,
            child: Opacity(
              opacity: imageOpacity,
              child: Image(
                image: AssetImage(widget.song.imagePath),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // MAIN CONTENT SCROLL
          SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 300),

                  // SONG INFO AND PLAY BTN
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          widget.song.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.song.artist,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        IconButton(
                          onPressed: togglePlay,
                          icon: Icon(
                            audio.currentSong?.audioPath ==
                                        widget.song.audioPath &&
                                    audio.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ALBUM LIST
                  Container(
                    color: const Color(0xFF121212),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You might also like",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AlbumCard(
                              size: cardSize,
                              label: "peaches",
                              image: const AssetImage("assets/album1.jpg"),
                              song: Song(
                                title: "peaches",
                                artist: "Various Artists",
                                imagePath: "assets/album1.jpg",
                                audioPath: "assets/audio/audio1.mp3",
                              ),
                            ),
                            AlbumCard(
                              size: cardSize,
                              label: "Blinding lights",
                              image: const AssetImage("assets/album2.jpg"),
                              song: Song(
                                title: "Blinding lights",
                                artist: "Various Artists",
                                imagePath: "assets/album2.jpg",
                                audioPath: "assets/audio/audio2.mp3",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AlbumCard(
                              size: cardSize,
                              label: "Industry baby",
                              image: const AssetImage("assets/album3.jpg"),
                              song: Song(
                                title: "Industry baby",
                                artist: "Various Artists",
                                imagePath: "assets/album3.jpg",
                                audioPath: "assets/audio/audio3.mp3",
                              ),
                            ),
                            AlbumCard(
                              size: cardSize,
                              label: "snowman",
                              image: const AssetImage("assets/album4.jpg"),
                              song: Song(
                                title: "snowman",
                                artist: "Various Artists",
                                imagePath: "assets/album4.jpg",
                                audioPath: "assets/audio/audio4.mp3",
                              ),
                            ),
                          ],
                        ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AlbumCard(
                              size: cardSize,
                              label: "Stay",
                              image: const AssetImage("assets/album5.jpg"),
                              song: Song(
                                title: "Stay",
                                artist: "Various Artists",
                                imagePath: "assets/album5.jpg",
                                audioPath: "assets/audio/audio5.mp3",
                              ),
                            ),
                            AlbumCard(
                              size: cardSize,
                              label: "Watermelon sugar",
                              image: const AssetImage("assets/album6.jpg"),
                              song: Song(
                                title: "Watermelon sugar",
                                artist: "Various Artists",
                                imagePath: "assets/album6.jpg",
                                audioPath: "assets/audio/audio6.mp3",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TOP NAV BAR
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: showTopBar
                ? const Color(0xFF1DB954).withOpacity(0.9)
                : Colors.transparent,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, size: 32),
                ),
                const Spacer(),
                AnimatedOpacity(
                  opacity: showTopBar ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    "Album",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
