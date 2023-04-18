class SearchResto {
  SearchResto({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  bool error;
  int founded;
  List<Restaurant> restaurants;

  factory SearchResto.fromJson(Map<String, dynamic> json) => SearchResto(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            (json['restaurants'] as List).map((e) => Restaurant.fromJson(e))
            ),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "list": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class Restaurant {
  late String id;
  late String name;
  late String description;
  late String pictureId;
  late String city;
  late num rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  Restaurant.fromJson(Map<String, dynamic> restaurant) {
    id = restaurant['id'];
    name = restaurant['name'];
    description = restaurant['description'];
    pictureId = restaurant['pictureId'];
    city = restaurant['city'];
    rating = restaurant['rating'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}