import 'package:flutter_video_app/api/permissions_api.dart';
import 'package:flutter_video_app/api/storage_api.dart';
import 'package:flutter_video_app/app.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class CameraBloc extends Bloc {
  static const ResolutionPreset PRESET = ResolutionPreset.high;

  final _permissionsApi = PermissionsApi();
  final _storageApi = StorageApi();

  final _streamController = StreamController<void>();

  List<CameraDescription> _cameras;
  CameraController _cameraController;

  Stream<void> get inited => _streamController.stream;

  CameraBloc() {
    init();
  }

  void init() async {
    _cameras = await availableCameras();
    if (_cameras == null || _cameras.isEmpty) {
      _streamController.addError(CameraInitException("Can't get cameras description!"));
      return;
    }
    _cameraController = CameraController(_cameras.first, PRESET);
    await _cameraController.initialize();
    _streamController.add(null);
  }

  void startRecord() async {
    final path = await _storageApi.getNewVideoFilePath();
    print("Recording video: $path");
    await _cameraController.startVideoRecording(path);
  }

  void stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      return;
    }
    await _cameraController.stopVideoRecording();
  }

  CameraController get controller => _cameraController;

  @override
  void dispose() async {
    await _streamController.close();
    await _cameraController?.dispose();
  }
}
