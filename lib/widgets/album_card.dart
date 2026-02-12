import 'package:flutter/material.dart';
import 'package:spotify__uiclone/views/album_view.dart';
import 'package:spotify__uiclone/audio_manager.dart';

class AlbumCard extends StatelessWidget {
  final ImageProvider image;
  final String label;
  final double size;
  final Song song;
  final VoidCallback? onTap;

  const AlbumCard({
    Key? key,
    required this.image,
    required this.label,
    required this.song,
    this.onTap,
    this.size = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumView(song: song, playlist: [song]),
              ),
            );
          },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(image: image, width: size, height: size, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
