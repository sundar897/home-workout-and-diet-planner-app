import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ExercisePlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  const ExercisePlayerScreen({super.key, required this.videoUrl, required this.title});

  @override
  State<ExercisePlayerScreen> createState() => _ExercisePlayerScreenState();
}

class _ExercisePlayerScreenState extends State<ExercisePlayerScreen> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Support both network URLs and packaged asset videos
      if (widget.videoUrl.startsWith('http')) {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
            allowBackgroundPlayback: false,
          ),
          // Try different video formats
          httpHeaders: {
            'Range': 'bytes=0-', // Request range support
          },
        );
      } else {
        _controller = VideoPlayerController.asset(widget.videoUrl);
      }

      // Pre-configure video settings
      await _controller.setLooping(true);
      await _controller.setVolume(1.0);
      
      // Add timeout and retry logic for initialization
      bool initialized = false;
      int retryCount = 0;
      const maxRetries = 3;
      
      while (!initialized && retryCount < maxRetries) {
        try {
          await Future.any([
            _controller.initialize().then((_) => initialized = true),
            Future.delayed(const Duration(seconds: 15))
          ]);
          
          if (!initialized) {
            retryCount++;
            if (retryCount < maxRetries) {
              // Dispose and recreate controller for retry
              await _controller.dispose();
              _controller = VideoPlayerController.networkUrl(
                Uri.parse(widget.videoUrl),
                videoPlayerOptions: VideoPlayerOptions(
                  mixWithOthers: true,
                  allowBackgroundPlayback: false,
                ),
              );
              await _controller.setLooping(true);
              await _controller.setVolume(1.0);
            }
          }
        } catch (e) {
          print('Attempt $retryCount failed: $e');
          retryCount++;
        }
      }

      if (!initialized) {
        throw Exception('Video initialization failed after $maxRetries attempts');
      }
      
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,
        allowFullScreen: true,
        aspectRatio: _controller.value.aspectRatio,
        allowedScreenSleep: false,
        showControls: true,
        showControlsOnInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 42),
                const SizedBox(height: 8),
                Text(
                  'Error loading video\nTap retry to try again',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _initializeVideo(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.deepPurple,
          handleColor: Colors.deepPurpleAccent,
          bufferedColor: Colors.deepPurple.shade200,
          backgroundColor: Colors.grey.shade300,
        ),
        placeholder: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              Positioned(
                bottom: 100,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Loading video...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error loading video. Please check your internet connection.'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _initializeVideo,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.pause();
    _chewieController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_initialized && _chewieController != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _initializeVideo,
              tooltip: 'Reload video',
            ),
        ],
      ),
      body: Column(
        children: [
          if (!_initialized)
            Container(
              height: 300,
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Loading video...',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please wait while we prepare your workout',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          if (_initialized && _chewieController != null)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Chewie(controller: _chewieController!),
            ),
          const SizedBox(height: 16),
          if (_initialized && _chewieController != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tips:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Ensure you\'re in a well-lit area\n'
                    '• Keep your entire body visible in the camera\n'
                    '• Follow the instructor\'s form carefully\n'
                    '• Take breaks when needed',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
