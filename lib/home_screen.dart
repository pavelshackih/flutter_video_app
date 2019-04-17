import 'package:flutter/material.dart';
import 'package:flutter_video_app/camera_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_video_app/camera_api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video App"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen()),
          );
        },
        icon: Icon(Icons.camera),
        label: Text("Record video"),
      ),
      body: _buildEmptyScreen(context),
    );
  }
}

class HomeGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          Container(
            width: 32,
            height: 32,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}

Widget _buildEmptyScreen(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          FontAwesomeIcons.cameraRetro,
          color: Theme.of(context).accentColor,
          size: 72,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Text(
            "Список видео пуст.\nПопробуйте для начала записать что-нибудь!\nВидео будут сохраняться в директорию: ${CameraApi.SAVE_DIR}",
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
