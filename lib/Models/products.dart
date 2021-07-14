class Service {
  final int price;
  final String description;
  final int id;
  final String name;
  final String image;

  Service({
    required this.price,
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      price: json['price'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }
}