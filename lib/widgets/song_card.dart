import 'package:flutter/material.dart';
import 'package:spotify__uiclone/views/album_view.dart';
import 'package:spotify__uiclone/audio_manager.dart';

class SongCard extends StatelessWidget {
  final AssetImage image;
  final String audioPath;
  final String title;
  final String artist;

  const SongCard({
    Key? key,
    required this.image,
    required this.audioPath,
    this.title = "Song Title",
    this.artist = "Artist Name",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final song = Song(
      title: title,
      artist: artist,
      imagePath: image.assetName,
      audioPath: audioPath,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumView(song: song, playlist: [song]),
          ),
        );
      },
      child: Container(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: image, width: 140, height: 140, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              title,
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
              artist,
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
