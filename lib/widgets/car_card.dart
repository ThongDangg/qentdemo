import 'package:flutter/material.dart';
import 'package:qentdemo/models/car_model.dart';
import 'package:intl/intl.dart';


class CarCard extends StatefulWidget {
  final Car car;

  const CarCard({Key? key, required this.car}) : super(key: key);

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  @override
  Widget build(BuildContext context) {

    //format tiền
    final formattedPrice = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    ).format(widget.car.pricePerDay);



    return Container( 
      width: double.infinity, //sửa
      
          margin: const EdgeInsets.only(right: 8, bottom: 8, top: 4), // Điều chỉnh margin //CÓ BỊ CẮT THÌ NHỚ LẠI KHÚC NÀY


      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.1), blurRadius: 7, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hình ảnh xe và icon yêu thích
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.car.imageUrl,
                  height: 120,//sửa từ 120  
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Icon yêu thích
              Positioned(
                top: 8,
                right: 8,
                
                child: InkWell(
                  onTap: (){
                    //ADD TO LIKELIST
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                    child: Icon(Icons.favorite_border,size: 13,),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tên xe
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Text(widget.car.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 4),
          // Rating + sao
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Row(
              children: [
                              
            
                Text(
                  widget.car.rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 13),
                ),
                SizedBox(width: 4,),
                const Icon(Icons.star, size: 14, color: Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 2),
          // Địa điểm
          Row(
            children: [
              const Icon(Icons.location_on, size: 14),
                                SizedBox(width: 2),
      
              Text(widget.car.location, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          // Số chỗ + giá
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
      
                  const Icon(Icons.event_seat, size: 14),
                  SizedBox(width: 3,),
                  Text(
                    '${widget.car.seats} chỗ',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  
                  Text('${formattedPrice} /Ngày'
                    ,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
