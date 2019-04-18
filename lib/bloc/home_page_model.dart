import 'package:flutter_video_app/api/model.dart';
import 'package:flutter_video_app/api/storage_api.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePageModel extends Model {

  final StorageApi _storageApi;

  HomePageModel(this._storageApi);
  
  Future<List<Video>> getVideos() async {
    return await _storageApi.getVideos();
  }

  void onVideoAdded() {
    notifyListeners();
  }
}