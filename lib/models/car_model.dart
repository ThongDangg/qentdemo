class Car {
  final String id;
  final String name;
  final String brand;
  final String imageUrl;
  final List<String> imageCarousel;
  final double pricePerDay;
  final int seats;
  final double rating;
  final String location; 
  final String desc; // 🔥 Mô tả ngắn
  final double horsePower;
  final double maxSpeed;

  Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.imageCarousel,
    required this.pricePerDay,
    required this.seats,
    required this.rating,
    required this.location,
    required this.desc, // 👈 Thêm vào constructor
    required this.horsePower,
    required this.maxSpeed
  });

  factory Car.fromFirestore(Map<String, dynamic> data, String id) {
    return Car(
      id: id,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      imageCarousel: _parseImageCarousel(data['imageCarousel']),
      pricePerDay: double.tryParse(data['pricePerDay'].toString()) ?? 0.0,
      seats: int.tryParse(data['seats'].toString()) ?? 0,
      rating: double.tryParse(data['rating'].toString()) ?? 0.0,
      location: data['location'] ?? '',
      desc: data['desc'] ?? '', // 👈 Lấy từ Firestore
      horsePower: double.tryParse(data['horsePower'].toString()) ?? 0,
      maxSpeed: double.tryParse(data['maxSpeed'].toString()) ?? 0,
    );
  }

  // Helper method để parse imageCarousel từ Firestore
  static List<String> _parseImageCarousel(dynamic imageCarouselData) {
    if (imageCarouselData == null) {
      return [];
    }

    if (imageCarouselData is List) {
      return imageCarouselData
          .map((item) => item?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    }

    // Nếu là string, chuyển thành list có 1 phần tử
    if (imageCarouselData is String && imageCarouselData.isNotEmpty) {
      return [imageCarouselData];
    }

    return [];
  }

  // Helper method để convert Car object thành Map (cho việc lưu vào Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'imageUrl': imageUrl,
      'imageCarousel': imageCarousel,
      'pricePerDay': pricePerDay,
      'seats': seats,
      'rating': rating,
      'location': location,
      'desc': desc,
    };
  }
}
