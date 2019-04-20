import 'package:flutter_video_app/api/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:thumbnails/thumbnails.dart';

class StorageApi {
  static const String SAVE_DIR = "DemoVideoApp";
  static const String VIDEO_EXT = ".mp4";
  static final _dateFormat = DateFormat('yyyy-MM-dd – kk:mm');

  Future<String> getVideosDirPath() async {
    final dir = await getVideoDir();
    return dir.path;
  }

  Future<Directory> getVideoDir() async {
    Directory extDir;
    try {
      extDir = await getExternalStorageDirectory();
      final dirPath = "${extDir.path}/$SAVE_DIR";
      return await Directory(dirPath).create(recursive: true);
    } on FileSystemException {
      throw PermissionDeniedException(AppPermission.storage);
    }
  }

  String _getTimestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> getNewVideoFilePath() async {
    final dirPath = await getVideosDirPath();
    return "$dirPath/${_getTimestamp()}$VIDEO_EXT";
  }

  Future<List<File>> getVideoFiles() async {
    final dir = await getVideoDir();
    return await dir
        .list()
        .where((file) => file.path.endsWith(VIDEO_EXT) && file is File)
        .map((file) => file as File)
        .toList();
  }

  Future<List<Video>> getVideos() async {
    final files = await getVideoFiles();
    final result = List<Video>();
    final videoDir = await getVideoDir();
    for (final file in files) {
      final thumbnail = await Thumbnails.getThumbnail(
        videoFile: file.path,
        quality: 50,
        imageType: ThumbFormat.PNG,
        thumbnailFolder: videoDir.path,
      );
      result.add(
        Video(
          pathToThumbnail: thumbnail,
          pathToVideo: file.path,
          thumbnailFile: File(thumbnail),
          videoFile: file,
          created: _getCreateTimeFromFileName(file.path),
        ),
      );
    }
    return result;
  }

  String _getCreateTimeFromFileName(String path) {
    try {
      final fileName = basenameWithoutExtension(path);
      final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(fileName));
      return _dateFormat.format(dateTime);
    } on Exception {
      // skip this
      print("Can't parse $path");
      return "";
    }
  }
}
