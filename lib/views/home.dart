import 'package:flutter/material.dart';
import 'package:spotify__uiclone/widgets/album_card.dart';
import 'package:spotify__uiclone/widgets/song_card.dart';
import 'package:spotify__uiclone/audio_manager.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1DB954).withOpacity(0.8),
                  const Color(0xFF121212),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(.9),
                    Colors.black,
                    Colors.black,
                    Colors.black,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // RECENTLY PLAYED
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recently Played",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Row(
                            children: const [
                              Icon(Icons.history),
                              SizedBox(width: 16),
                              Icon(Icons.settings),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // HORIZONTAL ALBUMS
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          AlbumCard(
                            label: "peaches",
                            image: const AssetImage("assets/album1.jpg"),
                            song: Song(
                              title: "peaches",
                              artist: "Various Artists",
                              imagePath: "assets/album1.jpg",
                              audioPath: "assets/audio/audio1.mp3",
                            ),
                          ),
                          const SizedBox(width: 16),
                          AlbumCard(
                            label: "Blinding lights",
                            image: const AssetImage("assets/album2.jpg"),
                            song: Song(
                              title: "Blinding lights",
                              artist: "Various Artists",
                              imagePath: "assets/album2.jpg",
                              audioPath: "assets/audio/audio2.mp3",
                            ),
                          ),
                          const SizedBox(width: 16),
                          AlbumCard(
                            label: "Industry baby",
                            image: const AssetImage("assets/album3.jpg"),
                            song: Song(
                              title: "Industry baby",
                              artist: "Various Artists",
                              imagePath: "assets/album3.jpg",
                              audioPath: "assets/audio/audio3.mp3",
                            ),
                          ),
                          const SizedBox(width: 16),
                          AlbumCard(
                            label: "snowman",
                            image: const AssetImage("assets/album4.jpg"),
                            song: Song(
                              title: "snowman",
                              artist: "Various Artists",
                              imagePath: "assets/album4.jpg",
                              audioPath: "assets/audio/audio4.mp3",
                            ),
                          ),
                          const SizedBox(width: 16),
                          AlbumCard(
                            label: "stay",
                            image: const AssetImage("assets/album5.jpg"),
                            song: Song(
                              title: "stay",
                              artist: "Various Artists",
                              imagePath: "assets/album5.jpg",
                              audioPath: "assets/audio/audio5.mp3",
                               ),
                          ),
                              const SizedBox(width: 16),
                          AlbumCard(
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
                    ),

                    const SizedBox(height: 32),

                    // GOOD EVENING SECTION
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Good evening",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),

                    // ROW CARDS
                    _buildRowSection(
                      "assets/top50.jpg",
                      "Top 50 - Global",
                      "assets/album1.jpg",
                      "Best Mode",
                    ),
                    _buildRowSection(
                      "assets/album2.jpg",
                      "RapCaviar",
                      "assets/album5.jpg",
                      "Eminem",
                    ),
                    _buildRowSection(
                      "assets/album9.jpg",
                      "Top 50 - USA",
                      "assets/album10.jpg",
                      "Pop Remix",
                    ),

                    // SONG CARDS (Based on listening)
                    _buildSongScroller(
                      title: "Based on your recent listening",
                      songs: [
                        Song(
                          title: "Blinding Lights",
                          artist: "The Weeknd",
                          imagePath: "assets/album2.jpg",
                          audioPath: "assets/audio/audio2.mp3",
                        ),
                        Song(
                          title: "Watermelon Sugar",
                          artist: "Harry Styles",
                          imagePath: "assets/album6.jpg",
                          audioPath: "assets/audio/audio6.mp3",
                        ),
                        Song(
                          title: "Levitating",
                          artist: "Dua Lipa",
                          imagePath: "assets/album9.jpg",
                          audioPath: "assets/audio/audio3.mp3",
                        ),
                        Song(
                          title: "Good 4 U",
                          artist: "Olivia Rodrigo",
                          imagePath: "assets/album4.jpg",
                          audioPath: "assets/audio/audio4.mp3",
                        ),
                        Song(
                          title: "Stay",
                          artist: "The Kid LAROI & Justin Bieber",
                          imagePath: "assets/album5.jpg",
                          audioPath: "assets/audio/audio5.mp3",
                        ),
                        Song(
                          title: "Heat Waves",
                          artist: "Glass Animals",
                          imagePath: "assets/album1.jpg",
                          audioPath: "assets/audio/audio6.mp3",
                        ),
                      ],
                    ),

                    // RECOMMENDED RADIO
                    _buildSongScroller(
                      title: "Recommended radio",
                      songs: [
                        Song(
                          title: "Shape of You",
                          artist: "Ed Sheeran",
                          imagePath: "assets/album8.jpg",
                          audioPath: "assets/audio/audio1.mp3",
                        ),
                        Song(
                          title: "As It Was",
                          artist: "Harry Styles",
                          imagePath: "assets/album5.jpg",
                          audioPath: "assets/audio/audio2.mp3",
                        ),
                        Song(
                          title: "Bad Habits",
                          artist: "Ed Sheeran",
                          imagePath: "assets/album6.jpg",
                          audioPath: "assets/audio/audio3.mp3",
                        ),
                        Song(
                          title: "Peaches",
                          artist: "Justin Bieber",
                          imagePath: "assets/album1.jpg",
                          audioPath: "assets/audio/audio1.mp3",
                        ),
                        Song(
                          title: "Industry Baby",
                          artist: "Lil Nas X",
                          imagePath: "assets/album3.jpg",
                          audioPath: "assets/audio/audio5.mp3",
                        ),
                        Song(
                          title: "Montero",
                          artist: "Lil Nas X",
                          imagePath: "assets/album10.jpg",
                          audioPath: "assets/audio/audio6.mp3",
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowSection(
    String img1,
    String label1,
    String img2,
    String label2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          RowAlbumCard(image: AssetImage(img1), label: label1),
          const SizedBox(width: 16),
          RowAlbumCard(image: AssetImage(img2), label: label2),
        ],
      ),
    );
  }

  Widget _buildSongScroller({
    required String title,
    required List<Song> songs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: songs
                .map(
                  (song) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SongCard(
                      image: AssetImage(song.imagePath),
                      audioPath: song.audioPath,
                      title: song.title,
                      artist: song.artist,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class RowAlbumCard extends StatelessWidget {
  final AssetImage image;
  final String label;

  const RowAlbumCard({Key? key, required this.image, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Image(image: image, width: 48, height: 48, fit: BoxFit.cover),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
