import 'package:flutter/material.dart';
import 'package:flutter_video_app/api/storage_api.dart';
import 'package:flutter_video_app/app.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_share/simple_share.dart';
import 'package:flutter_video_app/plugins/video_cut_plugin.dart';

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

  double _min = -1;
  double _max = -1;

  _VideoScreenState(this.video);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(video.videoFile)
      ..initialize().then(
        (_) {
          setState(() {});
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Cut video"),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.cut),
            onPressed: () {
              if (_min != -1 && _max != -1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Обрезка видео"),
                        content: Text(
                            "Вы действительно хотите обрезать текущее видео?"),
                        actions: [
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () async {
                              final fromMs = Duration(seconds: _min.toInt());
                              final toMs = Duration(seconds: _max.toInt());
                              final destFile =
                                  await StorageApi().getNewVideoFilePath();
                              final result = await VideoCutPlugin.cutVideo(
                                source: video.videoFile.path,
                                dest: destFile,
                                from: fromMs.inMilliseconds,
                                to: toMs.inMilliseconds,
                              );
                              print("Cutter result $result");
                              Navigator.pop(context, true);
                            },
                          ),
                          FlatButton(
                            child: Text("ОТМЕНА"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });
              }
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.shareAlt),
            onPressed: () {
              final uri = Uri.file(video.videoFile.path);
              SimpleShare.share(
                uri: uri.toString(),
              );
            },
          )
        ],
      ),
      body: Center(
        child:
            _controller.value.initialized ? _buildVideo(context) : Container(),
      ),
      bottomSheet: _buildBottomPanel(context),
    );
  }

  Widget _buildVideo(BuildContext context) {
    _controller.play();
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    if (!_controller.value.initialized) {
      return Container();
    }
    final max = _controller.value.duration.inSeconds.toDouble();
    print("duration ${_controller.value.duration}");
    return SizedBox(
      height: 72.0,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Theme(
          data: Theme.of(context).copyWith(
            sliderTheme: SliderThemeData.fromPrimaryColors(
              primaryColor: Colors.orange,
              primaryColorDark: Colors.white,
              primaryColorLight: Colors.white,
              valueIndicatorTextStyle: Theme.of(context).textTheme.body1,
            ),
          ),
          child: RangeSlider(
            min: 0.0,
            max: max,
            lowerValue: 0,
            upperValue: max,
            showValueIndicator: true,
            divisions: max.toInt(),
            onChanged: (double newLowerValue, double newUpperValue) {
              print("lower $newLowerValue upper $newUpperValue");
              _min = newLowerValue;
              _max = newUpperValue;
            },
          ),
        ),
      ),
    );
  }
}
