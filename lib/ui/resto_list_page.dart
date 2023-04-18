import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/global.dart';
import 'package:resto_app/common/styles.dart';
import 'package:resto_app/data/model/favorite_resto.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/data/provider/db_provider.dart';
import 'package:resto_app/data/provider/restaurant_provider.dart';
import 'package:resto_app/ui/resto_detail_page.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/list';
  final String titlePage;
  const RestaurantListPage({Key? key, required this.titlePage})
      : super(key: key);

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  late List<Restaurant> displayListResto;
  late List<FavoriteResto> displayListFavResto;
  String searchString = "";
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(
            color: Colors.white,
          ),
          title: Text(
            widget.titlePage,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white),
          )),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Material(
                elevation: 8,
                shadowColor: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(50),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchString = value;
                    });
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Find restaurant",
                    hintStyle: TextStyle(color: Colors.grey[350]),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    prefixIconColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                flex: 10,
                child: widget.titlePage.toLowerCase() == "favorites"
                    ? _buildAllFavoriteList(context, "search")
                    : _buildAllRestoList(context, "search"))
          ],
        ),
      ),
    );
  }

  List<Restaurant> _searchResto(List<Restaurant>? resto) {
    if (searchString.isNotEmpty) {
      return resto
              ?.where((element) => element.name
                  .toLowerCase()
                  .contains(searchString.toLowerCase()))
              .toList() ??
          <Restaurant>[];
    }
    return resto ?? <Restaurant>[];
  }

  List<FavoriteResto> _searchRestoFav(List<FavoriteResto>? resto) {
    if (searchString.isNotEmpty) {
      return resto
              ?.where((element) => element.name
                  .toLowerCase()
                  .contains(searchString.toLowerCase()))
              .toList() ??
          <FavoriteResto>[];
    }
    return resto ?? <FavoriteResto>[];
  }

  Widget _buildAllRestoList(BuildContext context, String key) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultStateRestaurant.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultStateRestaurant.hasData) {
          displayListResto = state.result.restaurants;
          final result = _searchResto(displayListResto);
          if (result.isNotEmpty) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: result.length,
              itemBuilder: (context, index) {
                return _buildRestoItem(
                    context,
                    key,
                    result.length,
                    result[index].id,
                    result[index].pictureId,
                    result[index].name,
                    result[index].city,
                    result[index].description,
                    result[index].rating);
              },
            );
          } else {
            return const BlankDataResultNotification();
          }
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

  Widget _buildAllFavoriteList(BuildContext context, String key) {
    return Consumer<DbProvider>(
      builder: (context, state, _) {
        if (state.state == ResultStateDb.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultStateDb.hasData) {
          displayListFavResto = state.result;
          final result = _searchRestoFav(displayListFavResto);
          if (result.isNotEmpty) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: result.length,
              itemBuilder: (context, index) {
                return _buildRestoItem(
                    context,
                    key,
                    result.length,
                    result[index].id,
                    result[index].pictureId,
                    result[index].name,
                    result[index].city,
                    result[index].description,
                    result[index].rating);
              },
            );
          } else {
            return const BlankDataResultNotification();
          }
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

  Widget _buildRestoItem(
      BuildContext context,
      String key,
      int total,
      String id,
      String pictureId,
      String name,
      String city,
      String description,
      num rating) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            selectedRestoID = id;
            detailKey = key;
            return RestaurantDetailPage(
              keyDetail: key,
              restoId: id,
            );
          }));
        },
        child: Card(
          margin: const EdgeInsets.all(3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    height:
                        (MediaQuery.of(context).size.height / (total / 3)) >= 80
                            ? 80
                            : MediaQuery.of(context).size.height / (total / 3),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20), right: Radius.circular(5)),
                      child: Hero(
                          tag: key + id.toString(),
                          child: Image.network(
                            "https://restaurant-api.dicoding.dev/images/small/$pictureId",
                            fit: BoxFit.fill,
                            errorBuilder: (context, widget, _) {
                              return Image.asset(
                                'images/404-not-found.png',
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              );
                            },
                          )),
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 2, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Icon(
                                            Icons.location_on,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                40,
                                            color: Colors.red[800],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Expanded(
                                          child: Text(
                                            city,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Icon(
                                            Icons.star_rate_rounded,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                35,
                                            color: Colors.yellow[800],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Expanded(
                                          child: Text(
                                            rating.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            description,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
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
          vertical: MediaQuery.of(context).size.height / 10),
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

class ErrorDataNotification extends StatelessWidget {
  const ErrorDataNotification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 10),
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

class NoDataNotification extends StatelessWidget {
  const NoDataNotification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 10),
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

class BlankDataResultNotification extends StatelessWidget {
  const BlankDataResultNotification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              'images/search-not-found.png',
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
                      text: 'No results to show\n',
                      style: TextStyle(
                          color: onPrimaryColor, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: 'Please check spelling or try different keywords',
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
