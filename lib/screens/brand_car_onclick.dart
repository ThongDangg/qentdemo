import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/models/car_model.dart';
import 'package:qentdemo/providers/carProvider.dart';
import 'package:qentdemo/widgets/car_card.dart';

class BrandCarOnclick extends StatefulWidget {
  final String brand;
  const BrandCarOnclick({super.key, required this.brand});

  @override
  State<BrandCarOnclick> createState() => _BrandCarOnclickState();
}




class _BrandCarOnclickState extends State<BrandCarOnclick> {

    late List<Car> filteredCars;


  @override
  void initState() {
    super.initState();
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    filteredCars = carProvider.getCarsByBrand(widget.brand);
  }
  
  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final filteredCars = carProvider.getCarsByBrand(widget.brand);

    
    return Scaffold(
      appBar: AppBar(title: Text('Xe của hãng ${widget.brand}')),
      body: ListView.builder(
        itemCount: filteredCars.length,
        itemBuilder: (context, index) {
          final car = filteredCars[index];
          return filteredCars.isEmpty
                      ? const Center(child: Text("Không có xe cho hãng này"))
                      : SizedBox(
                          height: 237,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredCars.length,
                            itemBuilder: (context, index) {
                              final car = filteredCars[index];
                              return SizedBox(
                                width: 186,
                                child: CarCard(car: car),
                              );
                            },
                          ),
                        );
        },
      ),
    );
    
  }


  
}