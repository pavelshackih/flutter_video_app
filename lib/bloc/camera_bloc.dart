import 'package:flutter_video_app/api/permissions_api.dart';
import 'package:flutter_video_app/api/storage_api.dart';
import 'package:flutter_video_app/app.dart';

class CameraBloc extends Bloc {
  final _permissionsApi = PermissionsApi();
  final _storageApi = StorageApi();

  @override
  void dispose() {
  }
}