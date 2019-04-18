import 'package:permission_handler/permission_handler.dart';

class PermissionsApi {
  final _handler = PermissionHandler();

  Future<bool> isStorageGranted() =>
      _isPermissionGranted(PermissionGroup.storage);

  Future<bool> isCameraGranted() =>
      _isPermissionGranted(PermissionGroup.camera);

  Future<bool> isRecordAudioGranted() =>
      _isPermissionGranted(PermissionGroup.microphone);

  Future<bool> _isPermissionGranted(PermissionGroup group) async {
    final result = await _handler.checkPermissionStatus(group);
    return result == PermissionStatus.granted;
  }

  Future<bool> requestStorage() =>
      _requestPermission([PermissionGroup.storage]);

  Future<bool> requestCameraAndMic() =>
      _requestPermission([PermissionGroup.camera, PermissionGroup.microphone]);

  Future<bool> _requestPermission(List<PermissionGroup> group) async {
    final result = await _handler.requestPermissions(group);
    final status = result[PermissionGroup.storage];
    return status == PermissionStatus.granted;
  }
}
