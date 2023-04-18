class DetailCustomerReview {
  DetailCustomerReview({
    required this.error,
    required this.message,
    required this.customerreview,
  });

  late bool error;
  late String message;
  List<CustomerReview> customerreview;

  factory DetailCustomerReview.fromJson(
          Map<String, dynamic> detailcustomerreview) =>
      DetailCustomerReview(
        error: detailcustomerreview["error"],
        message: detailcustomerreview["message"],
        customerreview: List<CustomerReview>.from(
            detailcustomerreview["customerReviews"]
                .map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "customerReviews": List<dynamic>.from(customerreview.map((x) => x.toJson())),
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
