import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/app.dart';
import 'package:flutter_video_app/bloc/camera_bloc.dart';
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
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
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
              return buildCameraError(context);
            }
            return buildCameraScreen();
        }
      },
    );
  }

  Widget buildCameraScreen() {
    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _bloc.controller.value.aspectRatio,
            child: CameraPreview(_bloc.controller),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildRecordButton(context),
        ),
      ],
    );
  }

  Widget buildCameraError(BuildContext context) {
    return Scaffold(
      body: buildListPlaceholder(
        context: context,
        icon: Icons.error_outline,
        title: "Ошибка при инициализации камеры",
        description: "Возникла проблема при получении доступа к камере.",
        buttonText: "Назад",
        buttonAction: () => Navigator.pop(context),
      ),
    );
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
      _bloc.startRecord();
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
    _bloc?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  stopVideoRecording() async {}
}
