import 'package:flutter_video_app/api/permissions_api.dart';
import 'package:flutter_video_app/api/storage_api.dart';
import 'package:flutter_video_app/app.dart';
import 'dart:async';

class VideoListBloc extends Bloc {
  final _permissionsApi = PermissionsApi();
  final _storageApi = StorageApi();
  final _videoListStream = StreamController<List<Video>>();

  VideoListBloc() {
    _load();
  }

  void _load() {
    _permissionsApi.isStorageGranted().then((test) async {
      if (test) {
        final videos = await _storageApi.getVideos();
        _videoListStream.add(videos);
      } else {
        _videoListStream
            .addError(PermissionDeniedException(AppPermission.storage));
      }
      return null;
    });
  }

  void onRefresh() => _load();

  Stream<List<Video>> get videos => _videoListStream.stream;

  void requestStoragePermission() {
    _permissionsApi.requestStorage().then((test) {
      if (test) {
        _load();
      }
    });
  }

  @override
  void dispose() async {
    await _videoListStream.close();
  }
}
