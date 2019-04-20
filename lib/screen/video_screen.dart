import 'package:flutter/material.dart';
import 'package:flutter_video_app/app.dart';
import 'package:video_player/video_player.dart';

class VideoRoot extends StatelessWidget {
  final Video video;

  const VideoRoot({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoScreen(
      video: video,
    );
  }
}

class VideoScreen extends StatefulWidget {
  final Video video;

  const VideoScreen({Key key, this.video}) : super(key: key);
  @override
  _VideoScreenState createState() => _VideoScreenState(video);
}

class _VideoScreenState extends State<VideoScreen> {
  final Video video;
  VideoPlayerController _controller;

  _VideoScreenState(this.video);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(video.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
