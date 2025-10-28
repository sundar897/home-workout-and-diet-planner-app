import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExercisePlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const ExercisePlayerScreen({required this.videoUrl, required this.title, Key? key}) : super(key: key);

  @override
  State<ExercisePlayerScreen> createState() => _ExercisePlayerScreenState();
}

class _ExercisePlayerScreenState extends State<ExercisePlayerScreen> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _ytController;
  bool isYoutube = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkVideoType();
  }

  void _checkVideoType() {
    final url = widget.videoUrl;

    if (YoutubePlayer.convertUrlToId(url) != null) {
      isYoutube = true;
      _ytController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
      isInitialized = true;
      setState(() {});
    } else {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          _videoController!.play();
          setState(() {
            isInitialized = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: isInitialized
            ? isYoutube
                ? YoutubePlayer(controller: _ytController!)
                : AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: !isYoutube && isInitialized
          ? FloatingActionButton(
              child: Icon(
                _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  _videoController!.value.isPlaying
                      ? _videoController!.pause()
                      : _videoController!.play();
                });
              },
            )
          : null,
    );
  }
}
