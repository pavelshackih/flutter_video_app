import 'package:flutter/material.dart';
import 'package:flutter_video_app/app.dart';
import 'package:flutter_video_app/bloc/video_list_bloc.dart';
import 'package:flutter_video_app/screen/camera_screen.dart';
import 'package:flutter_video_app/utils/common_widgets.dart';
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
    _bloc?.dispose();
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
        // TODO build list
        return Container(
          color: Colors.brown,
        );
      case ConnectionState.none:
        return _buildEmptyScreen(context);
      case ConnectionState.waiting:
        return buildIndeterminateProgress();
    }
    return null;
  }

  Widget _buildNoStoragePermissions(BuildContext context) =>
      buildListPlaceholder(
        context: context,
        icon: FontAwesomeIcons.solidFolder,
        title: "Нет доступа к файловой системе",
        description: "Предоставьте разрешения для сохранения видео.",
        buttonText: "Запросить права",
        buttonAction: () => _bloc.requestStoragePermission(),
      );

  Widget _buildEmptyScreen(BuildContext context) => 
  buildListPlaceholder(
        context: context,
        icon: FontAwesomeIcons.cameraRetro,
        title: "Список видео пуст",
        description: "Попробуйте для начала записать что-нибудь!",
      );
}

class HomeGrid extends StatelessWidget {

  final List<Video> videos;

  const HomeGrid({Key key, this.videos}) : super(key: key);

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
