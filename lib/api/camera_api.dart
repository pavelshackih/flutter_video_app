import 'package:camera/camera.dart';

class CameraApi {

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
