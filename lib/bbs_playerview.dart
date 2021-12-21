import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

///IJK播放器
class BBSPlayView extends StatefulWidget {
  /// @nodoc
  /// channel标识符
  static String channelType = "BBSFlutterPlatformFactory";
  final ValueChanged<int>? onViewCreated;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  const BBSPlayView({Key? key, this.onViewCreated, this.gestureRecognizers})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => BBSPlayViewState();
}
class BBSPlayViewState extends State<BBSPlayView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: BBSPlayView.channelType,
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: BBSPlayView.channelType,
        creationParams: const <String, dynamic>{"flutter": "来自flutter", "player": "播放器"},
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
      );
    } else {
      return const Text("该平台不支持Platform View");
    }
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onViewCreated != null) {
      widget.onViewCreated!(id);
    }
  }
}

typedef ZLPlayOnPlayEvent = void Function(int id, Map param);

/// @nodoc
/// Weex页面控制器方法
class ZLPlayViewController {
  late final MethodChannel _channel;
  ZLPlayOnPlayEvent? _onPlayEvent;

  ZLPlayViewController(int id) {
    _channel = MethodChannel(BBSPlayView.channelType + '_$id');
    _channel.setMethodCallHandler((methodCall) async {
      switch (methodCall.method) {
        case 'onPlayEvent':
          int id = methodCall.arguments['EvtID'] ?? 0;
          Map param = methodCall.arguments['param'] ?? {};
          if (_onPlayEvent != null) {
            _onPlayEvent!(id, param);
          }
          throw MissingPluginException();
        case 'onNetStatus':
          throw MissingPluginException();
        default:
          throw MissingPluginException();
      }
    });
  }

  setOnPlayEvent(ZLPlayOnPlayEvent onPlayEvent) {
    _onPlayEvent = onPlayEvent;
  }

  /// @description: 开始播放
  /// @param url: 播放地址
  /// @param type: 播放类型
  /// @return void
  Future<void> startPlay(String url) {
    return _channel.invokeMethod('startPlay', {"url": url});
  }

  /// @description: 停止播放
  /// @return void
  Future<void> stopPlay() {
    return _channel.invokeMethod('stopPlay');
  }

  /// @description: 设置静音
  /// @param mute: true 静音
  /// @return void
  Future<void> setMute(bool mute) {
    return _channel.invokeMethod('setMute', {"mute": mute});
  }

  /// @description: 设置画面的裁剪模式
  /// @param setRenderMode: 模式
  /// @return void
  Future<void> setRenderMode() {
    return _channel
        .invokeMethod('setRenderMode', {"renderMode": 1});
  }

  /// @description: 设置画面的方向
  /// @param rotation: 方向
  /// @return void
  Future<void> setRenderRotation() {
    return _channel
        .invokeMethod('setRenderRotation', {"rotation": 1});
  }
}