import 'package:flutter/material.dart';
import 'package:flutter_video_app/api/camera_api.dart';
import 'package:flutter_video_app/api/storage_api.dart';

/// Provides global app APIs for widgets tree.
class ApiProvider extends InheritedWidget {
  final CameraApi cameraApi;
  final StorageApi storageApi;

  ApiProvider(this.cameraApi, this.storageApi, {Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static Widget newInstance(Widget wrapped) =>
      ApiProvider(CameraApi(), StorageApi(), child: wrapped);

  static ApiProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ApiProvider) as ApiProvider);
  }
}
