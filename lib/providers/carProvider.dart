import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qentdemo/models/car_model.dart';

class CarProvider extends ChangeNotifier{
List<Car> carList = [];
  List<Car> get cars => carList;

Car? _selectedCar;
Car? get selectedCar => _selectedCar;


void selectCar(Car car){
  _selectedCar = car;
  notifyListeners();
}


  Future<void> fetchCars() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('cars')
          .get();
      carList = snapshot.docs
          .map((doc) => Car.fromFirestore(doc.data(), doc.id))
          .toList();
      notifyListeners(); // Cập nhật UI
    } catch (e) {
      print('Error fetching cars: $e');
    }
  }

  List<Car> getCarsByBrand(String? brand) {
    if (brand == null) return cars;
    return cars.where((car) => car.brand == brand).toList();
  }


  

}

