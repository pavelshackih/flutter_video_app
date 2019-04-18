import 'package:flutter/material.dart';
import 'package:flutter_video_app/provider/api_provider.dart';
import 'package:flutter_video_app/screen/home_screen.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          accentColor: Colors.blueAccent),
      home: ApiProvider.newInstance(HomeScreen()),
    );
  }
}