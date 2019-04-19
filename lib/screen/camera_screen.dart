import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/api/storage_api.dart';
import 'package:flutter_video_app/app.dart';
import 'package:flutter_video_app/bloc/camera_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_video_app/utils/common_widgets.dart';

class CameraRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraBloc>(
      creator: (context, bag) => CameraBloc(),
      child: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  CameraBloc _bloc;
  bool _isRecording;
  AnimationController _animationController;
  Animation _colorTween;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<CameraBloc>(context);
    _isRecording = false;

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    final beginColor = _isRecording ? Colors.red : Colors.white;
    final endColor = _isRecording ? Colors.white : Colors.red;
    _colorTween = ColorTween(begin: beginColor, end: endColor)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.inited,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
              return buildIndeterminateProgress();
          default:
          if (snapshot.hasError) {
            return 
          }
        }
        return Container();
      },
    );
    /*return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildRecordButton(context),
        ),
      ],
    );*/
  }

  Widget _buildRecordButton(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FlatButton(
                padding: EdgeInsets.all(8),
                onPressed: () {
                  _onRecordClick();
                },
                shape: CircleBorder(),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _colorTween.value,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
      ),
    );
  }

  void _onRecordClick() {
    _proceedActionWithCamera();
  }

  void _proceedActionWithCamera() {
    _isRecording = !_isRecording;
    if (_isRecording) {
      startVideoRecording().then((path) {
        print("Start recording in path $path");
      });
      _animationController.forward();
    } else {
      _animationController.reverse();
      stopVideoRecording().then((value) {
        print("Stop camera recording");
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  Future<String> startVideoRecording() async {
    if (!_controller.value.isInitialized) {
      return null;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final extDir = await getExternalStorageDirectory();
    final dirPath = '${extDir.path}/${StorageApi.SAVE_DIR}/';
    await Directory(dirPath).create(recursive: true);
    final filePath = '$dirPath/$currentTime.mp4';
    if (_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      print(filePath);
      await _controller.startVideoRecording(filePath);
    } on CameraException {
      return null;
    }
    return filePath;
  }

  stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    try {
      await _controller.stopVideoRecording();
    } on CameraException {
      return null;
    }
  }
}
