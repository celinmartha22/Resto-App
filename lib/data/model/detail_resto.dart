class DetailResto {
  DetailResto({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  late bool error;
  late String message;
  late Restaurant restaurant;

  DetailResto.fromJson(Map<String, dynamic> detailresto) {
    error = detailresto['error'];
    message = detailresto['message'];
    restaurant = Restaurant.fromJson(detailresto['restaurant']);
  }
  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}

class Restaurant {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  num rating;
  List<Category> categories;
  Menu menus;
  List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> restaurant) => Restaurant(
        id: restaurant["id"],
        name: restaurant["name"],
        description: restaurant["description"],
        city: restaurant["city"],
        address: restaurant["address"],
        pictureId: restaurant["pictureId"],
        rating: restaurant["rating"],
        categories: List<Category>.from(
            restaurant["categories"].map((x) => Category.fromJson(x))),
        menus: Menu.fromJson(restaurant["menus"]),
        customerReviews: List<CustomerReview>.from(restaurant["customerReviews"]
            .map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "rating": rating,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "menus": menus.toJson(),
        "customerReviews": List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
      
}

class Category {
  String name;
  Category({
    required this.name,
  });
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class CustomerReview {
  String name;
  String review;
  String date;
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });
  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );
  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}

class Menu {
  List<Food> food;
  List<Drink> drink;
  Menu({
    required this.food,
    required this.drink,
  });
  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        food: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
        drink: List<Drink>.from(json["drinks"].map((x) => Drink.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "food": List<dynamic>.from(food.map((x) => x.toJson())),
        "drink": List<dynamic>.from(drink.map((x) => x.toJson())),
      };
}

class Food {
  String name;
  Food({
    required this.name,
  });
  factory Food.fromJson(Map<String, dynamic> json) => Food(
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Drink {
  String name;
  Drink({
    required this.name,
  });
  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
