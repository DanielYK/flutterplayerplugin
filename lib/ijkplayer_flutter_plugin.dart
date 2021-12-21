
import 'dart:async';

import 'package:flutter/services.dart';

class IjkplayerFlutterPlugin {
  static const MethodChannel _channel = MethodChannel('ijkplayer_flutter_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
