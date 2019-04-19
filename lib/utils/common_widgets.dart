import 'package:flutter/material.dart';

Widget buildIndeterminateProgress() {
  return Center(
    child: CircularProgressIndicator(
      value: null,
    ),
  );
}

Widget buildListPlaceholder(
    {@required BuildContext context,
    @required IconData icon,
    @required String title,
    @required String description,
    String buttonText,
    VoidCallback buttonAction}) {
  final list = [
    Icon(
      icon,
      color: Theme.of(context).accentColor,
      size: 72,
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.title,
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
      child: Text(
        description,
        textAlign: TextAlign.center,
      ),
    ),
  ];
  if (buttonText != null && buttonAction != null) {
    list.add(
      FlatButton(
        child: Text(buttonText),
        onPressed: buttonAction,
      ),
    );
  }
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    ),
  );
}
