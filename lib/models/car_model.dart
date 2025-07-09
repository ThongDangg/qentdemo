class Car {
  final String id;
  final String name;
  final String brand;
  final String imageUrl;
  final double pricePerDay;
  final int seats;
  final double rating;
  final String location;

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.pricePerDay,
    required this.seats,
    required this.rating,
    required this.location,
  });

  factory Car.fromFirestore(Map<String, dynamic> data, String id) {
    return Car(
      id: id,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      pricePerDay: double.tryParse(data['pricePerDay'].toString()) ?? 0.0,
      seats: int.tryParse(data['seats'].toString()) ?? 0,
      rating: double.tryParse(data['rating'].toString()) ?? 0.0,
      location: data['location'] ?? '',
    );
  }
}
