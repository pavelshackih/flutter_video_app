import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class VideoCutPlugin {
  static const MethodChannel _channel = const MethodChannel('video_cut_plugin');

  static Future<VideoCutResult> cutVideo({
    @required String source,
    @required String dest,
    @required int from,
    @required int to,
  }) async {
    assert(source != null);
    assert(dest != null);
    assert(from != null);
    assert(to != null);

    final params = <String, dynamic>{
      'source': source,
      'dest': dest,
      'from': from,
      'to': to,
    };
    final int result = await _channel.invokeMethod('cutVideo', params);
    return _parseResult(result);
  }
}

VideoCutResult _parseResult(int result) {
  switch (result) {
    case 1:
      return VideoCutResult.ok;
    case 2:
      return VideoCutResult.fail;
    default:
      return VideoCutResult.unknown;
  }
}

enum VideoCutResult { ok, fail, unknown }
