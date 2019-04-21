import 'package:flutter/material.dart';
import 'package:flutter_video_app/screen/home_screen.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video App',
      theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.orangeAccent),
      home: HomeRoot(),
    );
  }
}
