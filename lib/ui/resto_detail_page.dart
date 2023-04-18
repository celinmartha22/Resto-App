import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/styles.dart';
import 'package:resto_app/data/api/service.dart';

import 'package:resto_app/data/provider/db_provider.dart';
import 'package:resto_app/data/provider/detail_resto_provider.dart';
import 'package:http/http.dart' as http;
import '../data/model/detail_customer_review.dart';
import '../data/model/detail_resto.dart';
import '../data/model/favorite_resto.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/detail';
  final String restoId;
  final String keyDetail;
  const RestaurantDetailPage(
      {Key? key, required this.restoId, required this.keyDetail})
      : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) =>
            DetailRestoProvider(widget.restoId, apiService: ApiService()),
        child: Consumer<DetailRestoProvider>(
          builder: (context, state, _) {
            if (state.state == ResultStateDetailResto.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.state == ResultStateDetailResto.hasData) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Scaffold(
                    body: SingleChildScrollView(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth <= 600) {
                            return DetailMobileLayout(
                              selectedResto: state.result.restaurant,
                              coverHeight: 300,
                              keyDetail: widget.keyDetail,
                            );
                          } else if (constraints.maxWidth <= 950) {
                            return DetailMobileLayout(
                              selectedResto: state.result.restaurant,
                              coverHeight: 500,
                              keyDetail: widget.keyDetail,
                            );
                          } else {
                            return DetailMobileLayout(
                              selectedResto: state.result.restaurant,
                              coverHeight: 500,
                              keyDetail: widget.keyDetail,
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state.state == ResultStateDetailResto.noData) {
              return Center(
                  child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 10),
                child: Column(
                  children: [
                    Image.asset(
                      'images/empty-data.png',
                      width: 250,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                    ),
                    Text('No data to show',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: onPrimaryColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ));
            } else if (state.state == ResultStateDetailResto.error) {
              return Center(
                  child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 10),
                child: Column(
                  children: [
                    Image.asset(
                      'images/sorry-error.png',
                      width: 250,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                    ),
                    RichText(
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
                                  color: onPrimaryColor,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Please try again',
                              style: TextStyle(color: onSecondaryColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
            } else {
              return Center(
                  child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 10),
                child: Column(
                  children: [
                    Image.asset(
                      'images/404-not-found.png',
                      width: 250,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                    )
                  ],
                ),
              ));
            }
          },
        ));
  }
}

class DetailMobileLayout extends StatefulWidget {
  final Restaurant selectedResto;
  final double coverHeight;
  final String keyDetail;
  const DetailMobileLayout(
      {Key? key,
      required this.selectedResto,
      required this.coverHeight,
      required this.keyDetail})
      : super(key: key);

  @override
  State<DetailMobileLayout> createState() => _DetailMobileLayoutState();
}

class _DetailMobileLayoutState extends State<DetailMobileLayout> {
  final TextEditingController _controllerComment = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  Future<DetailCustomerReview>? _futureDetailCustomerReview;
  var imgItem;

  @override
  void initState() {
    imgItem = NetworkImage(
        "https://restaurant-api.dicoding.dev/images/medium/${widget.selectedResto.pictureId}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Hero(
              tag: widget.keyDetail + widget.selectedResto.id.toString(),
              child: Container(
                height: widget.coverHeight,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: imgItem,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  onError: (exception, stackTrace) {
                    setState(() {
                      imgItem = const AssetImage('images/404-not-found.png');
                    });
                  },
                )),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.5),
                    Colors.transparent
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                ),
              ),
            ),
            SafeArea(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ],
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.selectedResto.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: FavoriteButton(
                          id: widget.selectedResto.id,
                          city: widget.selectedResto.city,
                          name: widget.selectedResto.name,
                          description: widget.selectedResto.description,
                          pictureId: widget.selectedResto.pictureId,
                          rating: widget.selectedResto.rating,
                        )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(
                  children: [
                    Flexible(
                      child: Icon(
                        Icons.location_on,
                        size: MediaQuery.of(context).size.height / 30,
                        color: Colors.red[800],
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "${widget.selectedResto.address}, ${widget.selectedResto.city}",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 3,
                              child: RatingResto(
                                  value: widget.selectedResto.rating)),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.start,
                              widget.selectedResto.rating.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                        child: RestoCategories(
                            selectedResto: widget.selectedResto)),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(5, 4, 5, 4),
                  child: Text(
                    widget.selectedResto.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  )),
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Food",
                    style: Theme.of(context).textTheme.subtitle1,
                  )),
              const Divider(
                color: primaryColor,
              ),
              SizedBox(
                height: widget.selectedResto.menus.food.length > 4 ? 200 : 140,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 4 / 1),
                  itemCount: widget.selectedResto.menus.food.length,
                  itemBuilder: (context, index) {
                    return BuildMenuItem(
                      name: widget.selectedResto.menus.food[index].name,
                      icon: "fried-egg.png",
                    );
                  },
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Baverage",
                    style: Theme.of(context).textTheme.subtitle1,
                  )),
              const Divider(
                color: primaryColor,
              ),
              SizedBox(
                height: widget.selectedResto.menus.drink.length > 4 ? 200 : 140,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 4 / 1),
                  itemCount: widget.selectedResto.menus.drink.length,
                  itemBuilder: (context, index) {
                    return BuildMenuItem(
                      name: widget.selectedResto.menus.drink[index].name,
                      icon: "toast.png",
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                color: const Color.fromARGB(255, 238, 236, 235),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        alignment: Alignment.center,
                        child: Text(
                          "Customer Reviews",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.normal),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      labelText: 'Name',
                                    ),
                                    controller: _controllerName,
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      labelText: 'Text your comment',
                                    ),
                                    controller: _controllerComment,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _futureDetailCustomerReview = addReview(
                                            widget.selectedResto.id,
                                            _controllerName.text,
                                            _controllerComment.text);
                                        _controllerName.clear();
                                        _controllerComment.clear();
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      color: secondaryColor,
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Text(
                          "${widget.selectedResto.customerReviews.length} comments",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: (_futureDetailCustomerReview == null)
                            ? buildListCustomerReview()
                            : buildFutureCustomerReview(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  ListView buildListCustomerReview() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.selectedResto.customerReviews.length,
      itemBuilder: (context, index) {
        return CommentItem(
            name: widget.selectedResto.customerReviews[index].name,
            date: widget.selectedResto.customerReviews[index].date,
            review: widget.selectedResto.customerReviews[index].review);
      },
    );
  }

  FutureBuilder<DetailCustomerReview> buildFutureCustomerReview() {
    return FutureBuilder<DetailCustomerReview>(
      future: _futureDetailCustomerReview,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.customerreview.length,
            itemBuilder: (context, index) {
              return CommentItem(
                  name: snapshot.data?.customerreview[index].name as String,
                  date: snapshot.data?.customerreview[index].date as String,
                  review:
                      snapshot.data?.customerreview[index].review as String);
            },
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 10),
            child: Column(
              children: [
                Image.asset(
                  'images/sorry-error.png',
                  width: 250,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.contain,
                ),
                RichText(
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
                              color: onPrimaryColor,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'Please check your internet connection and try again',
                          style: TextStyle(color: onSecondaryColor)),
                    ],
                  ),
                ),
              ],
            ),
          ));
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  String name;
  String review;
  String date;

  CommentItem(
      {Key? key, required this.name, required this.date, required this.review})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: onPrimaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Flexible(
                      child: Icon(
                        Icons.more_horiz,
                        color: onSecondaryColor,
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          date,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: onSecondaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  review,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: onSecondaryColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RestoCategories extends StatelessWidget {
  const RestoCategories({
    Key? key,
    required this.selectedResto,
  }) : super(key: key);

  final Restaurant selectedResto;

  @override
  Widget build(BuildContext context) {
    var textCategory = StringBuffer();
    for (var item in selectedResto.categories) {
      if (textCategory.toString() == "") {
        textCategory.write(item.name);
      } else {
        textCategory.write(", ${item.name}");
      }
    }

    return Card(
      color: secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: Text(
            textCategory.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
          )),
    );
  }
}

class RatingResto extends StatelessWidget {
  final num value;
  const RatingResto({Key? key, required this.value}) : super(key: key);

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= value) {
      icon = Icon(
        Icons.star_border,
        color: Colors.yellow[800],
      );
    } else if (index > value - 1 && index < value) {
      icon = Icon(
        Icons.star_half,
        color: Colors.yellow[800],
      );
    } else {
      icon = Icon(
        Icons.star,
        color: Colors.yellow[800],
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Flexible(child: buildStar(context, index)),
      ),
    );
  }
}

class BuildMenuItem extends StatelessWidget {
  final String name;
  final String icon;
  const BuildMenuItem({Key? key, required this.name, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'images/$icon',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyText2,
              )),
        ],
      ),
    );
  }
}

Future<DetailCustomerReview> addReview(
    String id, String name, String review) async {
  final response =
      await http.post(Uri.parse("https://restaurant-api.dicoding.dev/review"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(<String, String>{
            "id": id,
            "name": name,
            "review": review,
          }));
  if (response.statusCode == 201) {
    return DetailCustomerReview.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Customer Review Results');
  }
}

class FavoriteButton extends StatefulWidget {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  num rating;
  FavoriteButton(
      {Key? key,
      required this.id,
      required this.name,
      required this.description,
      required this.pictureId,
      required this.city,
      required this.rating})
      : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;
  @override
  void initState() {
    getStatusFavorite(widget.id);
    super.initState();
  }

  Future<bool> getStatusFavorite(String id) async {
    dynamic result;
    try {
      result = await Provider.of<DbProvider>(context, listen: false)
          .getFavoriteRestoById(id);
      if (result == null) {
        setState(() {
          isFavorite = false;
        });
        return false;
      } else {
        setState(() {
          isFavorite = true;
        });
        return true;
      }
    } catch (e) {
      setState(() {
        isFavorite = false;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 17,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              blurRadius: 3,
              color: onSecondaryColor,
              spreadRadius: 1,
              blurStyle: BlurStyle.outer)
        ],
      ),
      child: IconButton(
        onPressed: () async {
          if (isFavorite) {
            Provider.of<DbProvider>(context, listen: false)
                .deleteFavoriteResto(widget.id);
          } else {
            final fav = FavoriteResto(
                id: widget.id,
                city: widget.city,
                description: widget.description,
                name: widget.name,
                pictureId: widget.pictureId,
                rating: widget.rating);
            Provider.of<DbProvider>(context, listen: false)
                .addFavoriteResto(fav);
          }
          setState(() {
            isFavorite = !isFavorite;
          });
        },
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          size: MediaQuery.of(context).size.width / 15,
        ),
        color: Colors.red,
      ),
    );
  }
}
