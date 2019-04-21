import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/app.dart';
import 'package:flutter_video_app/bloc/camera_bloc.dart';
import 'package:flutter_video_app/utils/common_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

class _CameraScreenState extends State<CameraScreen> {
  CameraBloc _bloc;
  bool _isRecording;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<CameraBloc>(context);
    _isRecording = false;
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
            } else {
              return buildCameraScreen(context);
            }
        }
      },
    );
  }

  Widget buildCameraScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(_isRecording ? FontAwesomeIcons.stop : FontAwesomeIcons.video),
        onPressed: () => _onRecordClick(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: AspectRatio(
          aspectRatio: _bloc.controller.value.aspectRatio,
          child: CameraPreview(_bloc.controller),
        ),
      ),
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

  void _onRecordClick() async {
    _isRecording = !_isRecording;
    if (_isRecording) {
      await _bloc.startRecord();
      setState(() {});
    } else {
      await _bloc.stopRecording();
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }
}
