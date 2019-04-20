import 'package:flutter/material.dart';
import 'package:flutter_video_app/app.dart';
import 'package:flutter_video_app/bloc/video_list_bloc.dart';
import 'package:flutter_video_app/screen/camera_screen.dart';
import 'package:flutter_video_app/screen/video_screen.dart';
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
            MaterialPageRoute(builder: (context) => CameraRoot()),
          );
        },
        icon: Icon(Icons.camera),
        label: Text("Записать видео"),
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
        return HomeGrid(videos: list);
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

  Widget _buildEmptyScreen(BuildContext context) => buildListPlaceholder(
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
        children: videos.map((item) => HomeGridItem(video: item)).toList(),
      ),
    );
  }
}

class HomeGridItem extends StatelessWidget {
  final Video video;

  const HomeGridItem({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 8,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoRoot(
                          video: video,
                        )),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  video.thumbnailFile,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black54,
                    child: Text(
                      video.created,
                      style: Theme.of(context).textTheme.subtitle.apply(
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
