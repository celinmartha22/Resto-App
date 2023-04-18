import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/api/service.dart';
import 'package:resto_app/data/provider/db_provider.dart';
import 'package:resto_app/data/provider/preferences_provider.dart';
import 'package:resto_app/data/provider/restaurant_provider.dart';
import 'package:resto_app/helper/preferences_helper.dart';
import 'package:resto_app/ui/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget createHomeScreen() => MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider(create: (_) => DbProvider()),
        ChangeNotifierProvider(
            create: (_) => PreferencesProvider(
                preferencesHelper: PreferencesHelper(
                    sharedPreferences: SharedPreferences.getInstance()))),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );

void main() {
  group('Home Page Widget Test', () {

    testWidgets('Test [View More] Button', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.byType(TextButton), findsNWidgets(4));
    });

    testWidgets('Test [Setting] Button', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
