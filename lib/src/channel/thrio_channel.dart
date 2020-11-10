// The MIT License (MIT)
//
// Copyright (c) 2019 Hellobike Group
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:thrio/src/navigator/navigator_logger.dart';
import 'package:thrio/src/registry/registry_map.dart';

typedef MethodHandler = Future<dynamic> Function([
  Map<String, dynamic> arguments,
]);

const String _kEventNameKey = '__event_name__';

class ThrioChannel {
  factory ThrioChannel({String channel = '__thrio_channel__'}) =>
      ThrioChannel._(channel: channel);

  ThrioChannel._({String channel}) : _channel = channel;

  final String _channel;

  final _methodHandlers = RegistryMap<String, MethodHandler>();

  MethodChannel _methodChannel;

  EventChannel _eventChannel;

  final _eventControllers = <String, List<StreamController>>{};
  final _eventNameControllers = <StreamController>{};

  Future<List<T>> invokeListMethod<T>(String method, [Map arguments]) {
    _setupMethodChannelIfNeeded();
    return _methodChannel.invokeListMethod<T>(method, arguments);
  }

  Future<Map<K, V>> invokeMapMethod<K, V>(String method, [Map arguments]) {
    _setupMethodChannelIfNeeded();
    return _methodChannel.invokeMapMethod<K, V>(method, arguments);
  }

  Future<T> invokeMethod<T>(String method, [Map arguments]) {
    _setupMethodChannelIfNeeded();
    return _methodChannel.invokeMethod<T>(method, arguments);
  }

  VoidCallback registryMethodCall(String method, MethodHandler handler) {
    _setupMethodChannelIfNeeded();
    return _methodHandlers.registry(method, handler);
  }

  void sendEvent(String name, [Map arguments]) {
    _setupEventChannelIfNeeded();
    final controllers = _eventControllers[name];
    if (controllers?.isNotEmpty ?? false) {
      for (final controller in controllers) {
        controller.add({...arguments, _kEventNameKey: name});
      }
    }
  }

  Stream<Map<String, dynamic>> onEventStream(String name) {
    _setupEventChannelIfNeeded();
    final controller = StreamController<Map<String, dynamic>>();
    _eventNameControllers.add(controller);
    controller
      ..onListen = () {
        _eventControllers[name] ??= <StreamController>[];
        _eventControllers[name].add(controller);
      }
      ..onCancel = () {
        controller.close();
        _eventControllers[name].remove(controller);
        _eventNameControllers.remove(controller);
      };
    return controller.stream;
  }

  void _setupMethodChannelIfNeeded() {
    if (_methodChannel != null) {
      return;
    }
    _methodChannel = MethodChannel('_method_$_channel')
      ..setMethodCallHandler((call) {
        final handler = _methodHandlers[call.method];
        final args = call.arguments;
        if (handler != null) {
          if (args is Map) {
            final arguments = args.cast<String, dynamic>();
            return handler(arguments);
          } else {
            return handler(null);
          }
        }
        return Future.value();
      });
  }

  void _setupEventChannelIfNeeded() {
    if (_eventChannel != null) {
      return;
    }
    _eventChannel = EventChannel('_event_$_channel')
      ..receiveBroadcastStream()
          .map<Map<String, dynamic>>(
              (data) => data is Map ? data.cast<String, dynamic>() : null)
          .where((data) => data?.containsKey(_kEventNameKey) ?? false)
          .listen((data) {
        verbose('Notify on $_channel $data');
        final eventName = data.remove(_kEventNameKey);
        final controllers = _eventControllers[eventName];
        if (controllers?.isNotEmpty ?? false) {
          for (final controller in controllers) {
            controller.add(data);
          }
        }
      });
  }
}
