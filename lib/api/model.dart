/// Simple model for keep data about preview image and video.
class Video {
  final String pathToThumbnail;
  final String pathToVideo;

  const Video({this.pathToThumbnail, this.pathToVideo});
}

class StoragePermissionDeniedException implements Exception {
  final String cause;
  StoragePermissionDeniedException(this.cause);
  
}