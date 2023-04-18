import 'dart:math';
import 'dart:ui';
import 'dart:isolate';
import 'package:resto_app/data/api/service.dart';
import 'package:resto_app/helper/notification_helper.dart';
import 'package:resto_app/main.dart';
 
final ReceivePort port = ReceivePort();
 
class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;
 
  BackgroundService._internal() {
    _instance = this;
  }
 
  factory BackgroundService() => _instance ?? BackgroundService._internal();
 
  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }
 
  static Future<void> callback() async {
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService().getRestaurant();
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result, Random().nextInt(result.restaurants.length));
 
    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}