class Car {
  final String name;
  final String model;
  final String price;

  Car({
    required this.name,
    required this.model,
    required this.price,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      name: json['name'],
      model: json['model'],
      price: json['price'],
    );
  }
}
