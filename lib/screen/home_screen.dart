import 'package:flutter/material.dart';
import 'package:flutter_video_app/app.dart';
import 'package:flutter_video_app/bloc/video_list_bloc.dart';
import 'package:flutter_video_app/screen/camera_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoListBloc>(
      creator: (context, bag) => VideoListBloc(),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VideoListBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<VideoListBloc>(context);
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
      body: _buildBody(context),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<List<Video>>(
      stream: _bloc.videos,
      builder: _getContentWidget,
    );
  }

  Widget _getContentWidget(
      BuildContext context, AsyncSnapshot<List<Video>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.active:
      case ConnectionState.done:
        if (snapshot.hasError) {
          if (snapshot.error is PermissionDeniedException) {
            return _buildNoStoragePermissions(context);
          }
        }
        final list = snapshot.data;
        if (list == null || list.isEmpty) {
          return _buildEmptyScreen(context);
        }
        return Container(
          color: Colors.brown,
        );
      case ConnectionState.none:
        return _buildEmptyScreen(context);
      case ConnectionState.waiting:
        return _buildProgress(context);
    }
    return null;
  }

  Widget _buildProgress(BuildContext context) {
    return Container(
        child: Center(
      child: CircularProgressIndicator(
        value: null,
      ),
    ));
  }

  Widget _buildNoStoragePermissions(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.solidFolder,
            color: Theme.of(context).accentColor,
            size: 72,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Нет доступа к файловой системе.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
            child: Text(
              "Предоставьте разрешения для сохранения видео.",
              textAlign: TextAlign.center,
            ),
          ),
          FlatButton(
            child: Text("Запросить права"),
            onPressed: () {
              _bloc.requestStoragePermission();
            },
          )
        ],
      ),
    );
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Список видео пуст.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
            child: Text(
              "Попробуйте для начала записать что-нибудь!",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
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
