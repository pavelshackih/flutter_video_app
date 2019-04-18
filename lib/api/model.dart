/// Simple model for keep data about preview image and video.
class Video {
  final String pathToThumbnail;
  final String pathToVideo;

  const Video({this.pathToThumbnail, this.pathToVideo});
}

class PermissionDeniedException implements Exception {
  final AppPermission cause;
  PermissionDeniedException(this.cause);
}

enum AppPermission { storage, camera, mic }
