// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

class Replies {
  static Function? _hasChatsCallback;
  static Function? _onNewReplyReceivedCallback;
  static Function? _unreadRepliesCountCallback;
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async =>
      (await _channel.invokeMethod<String>('getPlatformVersion'))!;

  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'hasChatsCallback':
        _hasChatsCallback?.call(call.arguments);
        return;
      case 'onNewReplyReceivedCallback':
        _onNewReplyReceivedCallback?.call();
        return;
      case 'unreadRepliesCountCallback':
        _unreadRepliesCountCallback?.call(call.arguments);
        return;
    }
  }

  /// Enables and disables everything related to receiving replies.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    final List<dynamic> params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setRepliesEnabled:', params);
  }

  ///Manual invocation for replies.
  static Future<void> show() async {
    await _channel.invokeMethod<Object>('showReplies');
  }

  /// Tells whether the user has chats already or not.
  ///  [function] - callback that is invoked if chats exist
  static Future<void> hasChats(Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _hasChatsCallback = function;
    await _channel.invokeMethod<Object>('hasChats');
  }

  ///  Sets a block of code that gets executed when a new message is received.
  ///  [function] -  A callback that gets executed when a new message is received.
  static Future<void> setOnNewReplyReceivedCallback(Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _onNewReplyReceivedCallback = function;
    await _channel.invokeMethod<Object>('setOnNewReplyReceivedCallback');
  }

  /// Returns the number of unread messages the user currently has.
  /// Use this method to get the number of unread messages the user
  /// has, then possibly notify them about it with your own UI.
  /// [function] callback with argument
  /// Notifications count, or -1 in case the SDK has not been initialized.
  static Future<void> getUnreadRepliesCount(Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _unreadRepliesCountCallback = function;
    await _channel.invokeMethod<Object>('getUnreadRepliesCount');
  }

  /// Enables/disables showing in-app notifications when the user receives a new message.
  /// [isEnabled] A boolean to set whether notifications are enabled or disabled.
  static Future<void> setInAppNotificationsEnabled(bool isEnabled) async {
    final List<dynamic> params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setChatNotificationEnabled:', params);
  }

  /// Set whether new in app notification received will play a small sound notification or not (Default is {@code false})
  /// [isEnabled] A boolean to set whether notifications sound should be played.
  /// @android ONLY
  static Future<void> setInAppNotificationSound(bool isEnabled) async {
    if (Platform.isAndroid) {
      final List<dynamic> params = <dynamic>[isEnabled];
      await _channel.invokeMethod<Object>(
          'setEnableInAppNotificationSound:', params);
    }
  }
}
