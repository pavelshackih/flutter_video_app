import 'package:flutter/material.dart';
import 'package:flutter_video_app/camera_api.dart';
import 'package:flutter_video_app/home_screen.dart';

Future<void> main() async {
  await CameraApi.getInstance().init();
  runApp(VideoApp());
}

class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent
      ),
      home: HomeScreen(),
    );
  }
}