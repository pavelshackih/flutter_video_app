import 'dart:io';

class Video {
  final String pathToThumbnail;
  final String pathToVideo;
  final File thumbnailFile;
  final File videoFile;
  final String created;
  const Video({
    this.pathToThumbnail,
    this.pathToVideo,
    this.thumbnailFile,
    this.videoFile,
    this.created,
  });
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
