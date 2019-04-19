class Video {
  final String pathToThumbnail;
  final String pathToVideo;

  const Video({this.pathToThumbnail, this.pathToVideo});
}

class PermissionDeniedException implements Exception {
  final AppPermission cause;
  PermissionDeniedException(this.cause);
}

class CameraInitException implements Exception {
  final String message;
  CameraInitException(this.message);
}

enum AppPermission { storage, camera, mic }
