import 'package:camera/camera.dart';

class CameraApi {
  // singleton for simplicity
  static CameraApi _instance;

  static CameraApi getInstance() {
    if (_instance == null) {
      _instance = CameraApi();
    }
    return _instance;
  }

  List<CameraDescription> _cameras;

  Future<void> init() async {
    _cameras = await availableCameras();
  }

  List<CameraDescription> getCameras() {
    _checkInit();
    return _cameras;
  }

  void _checkInit() {
    if (_cameras == null) {
      throw ("Call init before access properties");
    }
  }
}
