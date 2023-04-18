import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/global.dart';
import 'package:resto_app/data/provider/db_provider.dart';
import 'package:resto_app/data/provider/preferences_provider.dart';
import 'package:resto_app/data/provider/restaurant_provider.dart';
import 'package:resto_app/helper/notification_helper.dart';
import 'package:resto_app/ui/setting_page.dart';
import 'package:resto_app/widgets/appbar_widget.dart';
import 'package:resto_app/ui/resto_detail_page.dart';
import 'package:resto_app/ui/resto_list_page.dart';

import '../common/styles.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    selectNotificationSubject.close();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      if (result == ConnectivityResult.none) {
        showErrorDialog(context, "Ooops",
            "Slow or no internet connections.\nPlease check your connection or your internet settings.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              actions: [
                Consumer<PreferencesProvider>(
                  builder: (context, provider, child) {
                    return Center(
                      child: IconButton(
                        splashRadius: 15,
                        iconSize: 30,
                        icon: Ink.image(
                          image: const AssetImage('images/settings.png'),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, SettingPage.routeName,
                              arguments: provider.isDailyRestoActive);
                        },
                      ),
                    );
                  },
                ),
              ],
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.vertical(
                      top: Radius.zero, bottom: Radius.circular(25))),
              flexibleSpace: FlexibleSpaceBar(
                background: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                        child: Image.asset(
                          'images/chef-hat.png',
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                title: const AppBarWidget(),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Favorites',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              selectedMenu = "Favorites";
                              Navigator.pushNamed(
                                  context, RestaurantListPage.routeName,
                                  arguments: "Favorites");
                            },
                            child: const Text("View more")),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                    height: 150,
                    child: _buildListFavoriteResto(context, "favorites")),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Recommended',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              selectedMenu = "Recommended";
                              Navigator.pushNamed(
                                  context, RestaurantListPage.routeName,
                                  arguments: "Recommended");
                            },
                            child: const Text("View more")),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                    height: 150,
                    child: _buildListResto(context, "recommended")),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Trending this week',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              selectedMenu = "Trending this week";
                              Navigator.pushNamed(
                                  context, RestaurantListPage.routeName,
                                  arguments: "Trending this week");
                            },
                            child: const Text("View more")),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                    height: 150, child: _buildListResto(context, "trending")),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Restaurant',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              selectedMenu = "Restaurant";
                              Navigator.pushNamed(
                                  context, RestaurantListPage.routeName,
                                  arguments: "Restaurant");
                            },
                            child: const Text("View more")),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(height: 150, child: _buildListResto(context, "all")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showErrorDialog(
    BuildContext context, String titleText, String contentText) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 4, child: Image.asset('images/no-connection.png')),
              const SizedBox(height: 5.0),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  height: 55.0,
                  child: Text(
                    contentText,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: onSecondaryColor, height: 1),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

Widget _buildListResto(BuildContext context, String key) {
  return Consumer<RestaurantProvider>(
    builder: (context, state, _) {
      if (state.state == ResultStateRestaurant.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.state == ResultStateRestaurant.hasData) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.result.count,
          itemBuilder: (context, index) {
            return _buildRestoBoxItem(
                context,
                key,
                state.result.restaurants[index].id,
                state.result.restaurants[index].pictureId,
                state.result.restaurants[index].name,
                state.result.restaurants[index].city,
                state.result.restaurants[index].rating);
          },
        );
      } else if (state.state == ResultStateRestaurant.noData) {
        return const NoDataNotification();
      } else if (state.state == ResultStateRestaurant.error) {
        return const ErrorDataNotification();
      } else {
        return const DataNotFoundNotification();
      }
    },
  );
}

Widget _buildListFavoriteResto(BuildContext context, String key) {
  return Consumer<DbProvider>(
    builder: (context, state, _) {
      if (state.state == ResultStateDb.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.state == ResultStateDb.hasData) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.result.length,
          itemBuilder: (context, index) {
            return _buildRestoBoxItem(
                context,
                key,
                state.result[index].id,
                state.result[index].pictureId,
                state.result[index].name,
                state.result[index].city,
                state.result[index].rating);
          },
        );
      } else if (state.state == ResultStateDb.noData) {
        return const NoDataNotification();
      } else if (state.state == ResultStateDb.error) {
        return const ErrorDataNotification();
      } else {
        return const DataNotFoundNotification();
      }
    },
  );
}

class DataNotFoundNotification extends StatelessWidget {
  const DataNotFoundNotification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 90),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              'images/404-not-found.png',
              width: 250,
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    ));
  }
}

class NoDataNotification extends StatelessWidget {
  const NoDataNotification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 90),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              'images/empty-data.png',
              width: 250,
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Text('No data to show',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: onPrimaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ));
  }
}

class ErrorDataNotification extends StatelessWidget {
  const ErrorDataNotification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 90),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              'images/sorry-error.png',
              width: 250,
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: onSecondaryColor),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'An unknown error has occured\n',
                      style: TextStyle(
                          color: onPrimaryColor, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          'Please check your internet connection and try again',
                      style: TextStyle(color: onSecondaryColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

Widget _buildRestoBoxItem(
  BuildContext context,
  String key,
  String id,
  String pictureId,
  String name,
  String city,
  num rating,
) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        selectedRestoID = id;
        detailKey = key;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RestaurantDetailPage(
            restoId: id,
            keyDetail: key,
          );
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10), bottom: Radius.zero),
                  child: Hero(
                    tag: key + id.toString(),
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/small/$pictureId",
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'images/404-not-found.png',
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.center,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              name,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 13,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      city,
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                  child: Icon(
                                    Icons.circle,
                                    size: 6,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.star_rate_rounded,
                                      size: 15,
                                      color: Colors.yellow[900],
                                    ),
                                    Text(
                                      rating.toString(),
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    ),
  );
}
