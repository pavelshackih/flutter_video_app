import 'package:flutter_video_app/api/model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:thumbnails/thumbnails.dart';

class StorageApi {
  static const String SAVE_DIR = "DemoVideoApp";
  static const String VIDEO_EXT = ".mp4";

  Future<String> getVideosDirPath() async {
    final dir = await getVideoDir();
    return dir.path;
  }

  Future<Directory> getVideoDir() async {
    final extDir = await getExternalStorageDirectory();
    final dirPath = "${extDir.path}/$SAVE_DIR";
    return await Directory(dirPath).create(recursive: true);
  }

  String _getTimestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> getNewVideoFilePath() async {
    final dirPath = await getVideosDirPath();
    return "$dirPath/${_getTimestamp()}.$VIDEO_EXT";
  }

  Future<List<File>> getVideoFiles() async {
    final dir = await getVideoDir();
    return await dir
        .list()
        .where((file) => file.path.endsWith(VIDEO_EXT) && file is File)
        .toList();
  }

  Future<List<Video>> getVideos() async {
    final files = await getVideoFiles();
    final result = List<Video>();
    for (final file in files) {
      final thumbnail = await Thumbnails.getThumbnail(
        videoFile: file.path,
      );
      result.add(
        Video(
          pathToThumbnail: thumbnail,
          pathToVideo: file.path,
        ),
      );
    }
    return result;
  }
}
