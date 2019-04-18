import 'package:flutter/material.dart';
import 'package:flutter_video_app/api/model.dart';
import 'package:flutter_video_app/provider/api_provider.dart'; // !
import 'package:flutter_video_app/scoped_model/home_page_model.dart';
import 'package:flutter_video_app/screen/camera_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_video_app/api/storage_api.dart'; // !
import 'package:permission_handler/permission_handler.dart'; // !
import 'package:scoped_model/scoped_model.dart'; // !

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomePageModel _model;

  @override
  Widget build(BuildContext context) {
    final provider = ApiProvider.of(context);
    _model = HomePageModel(provider.storageApi);
    return ScopedModel<HomePageModel>(
      model: _model,
      child: Scaffold(
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
        body: FutureBuilder(
          future: _model.getVideos(),
          builder: _getContentWidget,
        ),
      ),
    );
  }

  Widget _getContentWidget(
      BuildContext context, AsyncSnapshot<List<Video>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        if (snapshot.hasError) {
          if (snapshot.error is StoragePermissionDeniedException) {
            return _buildNoStoragePermissions(context);
          } else {
            return Container(
              color: Colors.red,
            );
          }
        }
        return Container(
          color: Colors.brown,
        );
      case ConnectionState.none:
        return _buildEmptyScreen(context);
      case ConnectionState.active:
      case ConnectionState.waiting:
        return _buildProgress(context);
    }
    return null;
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
      children: <Widget>[
        Text("Нет доступа к файловой системе."),
        FlatButton(
          child: Text("Запросить права"),
          onPressed: () {
            PermissionHandler().requestPermissions([PermissionGroup.storage]).then((result) {
              final status = result[PermissionGroup.storage];
              if (status == PermissionStatus.granted) {
                
              } else {
                
              }
            });
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
            "Попробуйте для начала записать что-нибудь!\nВидео файлы будут сохраняться в директорию: ${StorageApi.SAVE_DIR}",
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
