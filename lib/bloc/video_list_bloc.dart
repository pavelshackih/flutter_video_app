import 'package:flutter_video_app/api/model.dart';
import 'package:flutter_video_app/bloc/base_bloc.dart';
import 'dart:async';

class VideoListBloc extends BaseBloc {

  StreamController<List<Video>> _videoListStream;

  VideoListBloc() {
    _videoListStream = StreamController();
  }

  Stream<List<Video>> get videos => _videoListStream.stream;
  
  @override
  void dispose() {
    _videoListStream?.close();
  }
}