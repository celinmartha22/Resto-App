class FavoriteResto {
  late String id;
  late String name;
  late String description;
  late String pictureId;
  late String city;
  late num rating;

  FavoriteResto({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
    };
  }

  FavoriteResto.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
    pictureId = map['pictureId'];
    city = map['city'];
    rating = map['rating'];
  }
}
