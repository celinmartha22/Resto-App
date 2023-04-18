import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resto_app/common/global.dart';
import 'package:resto_app/common/navigation.dart';
import 'package:resto_app/common/styles.dart';
import 'package:resto_app/data/api/service.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/provider/db_provider.dart';
import 'package:resto_app/data/provider/preferences_provider.dart';
import 'package:resto_app/data/provider/restaurant_provider.dart';
import 'package:resto_app/data/provider/scheduling_provider.dart';
import 'package:resto_app/helper/notification_helper.dart';
import 'package:resto_app/helper/preferences_helper.dart';
import 'package:resto_app/ui/home_page.dart';
import 'package:resto_app/ui/resto_detail_page.dart';
import 'package:resto_app/ui/resto_list_page.dart';
import 'package:resto_app/ui/setting_page.dart';
import 'package:resto_app/ui/splash_screen_page.dart';
import 'package:resto_app/utils/background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider(create: (_) => DbProvider()),
        ChangeNotifierProvider(
            create: (_) => PreferencesProvider(
                preferencesHelper: PreferencesHelper(
                    sharedPreferences: SharedPreferences.getInstance()))),
        ChangeNotifierProvider(create: (_) => SchedulingProvider())
      ],
      child: MaterialApp(
        title: 'Reataurant Application',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColor,
                onPrimary: onPrimaryColor,
                secondary: secondaryColor,
                onSecondary: onSecondaryColor,
                background: pageColor,
              ),
          textTheme: myTextTheme,
        ),
        initialRoute: SplashScreenPage.routeName,
        routes: {
          SplashScreenPage.routeName: (context) => const SplashScreenPage(),
          HomePage.routeName: (context) => const HomePage(),
          SettingPage.routeName: (context) => SettingPage(statusAlarm: ModalRoute.of(context)!.settings.arguments as bool),
          RestaurantListPage.routeName: (context) => RestaurantListPage(
                titlePage: ModalRoute.of(context)!.settings.arguments == null
                    ? selectedMenu
                    : ModalRoute.of(context)!.settings.arguments as String,
              ),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                restoId: ModalRoute.of(context)!.settings.arguments == null
                    ? selectedRestoID
                    : ModalRoute.of(context)!.settings.arguments as String,
                keyDetail: ModalRoute.of(context)!.settings.arguments == null
                    ? detailKey
                    : ModalRoute.of(context)!.settings.arguments as String,
              )
        },
      ),
    );
  }
}
