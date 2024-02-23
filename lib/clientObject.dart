import 'package:cloud_firestore/cloud_firestore.dart';

class MyClient {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? carNumber;
  String? bookingDate;
  String? bookingTime;
  String? service;
  double? price;

  MyClient(
      {
        this.id,
        this.name,
        this.phone,
        this.email,
        this.address,
        this.carNumber,
        this.bookingDate,
        this.bookingTime,
        this.service,
        this.price});

  MyClient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    carNumber = json['carNumber'];
    bookingDate = json['bookingDate'];
    bookingTime = json['bookingTime'];
    service = json['service'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['carNumber'] = carNumber;
    data['bookingDate'] = bookingDate;
    data['bookingTime'] = bookingTime;
    data['service'] = service;
    data['price'] = price;
    return data;
  }


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
      "carNumber":carNumber,
      "bookingDate":bookingDate,
      "bookingTime":bookingTime,
      "service":service,
      "price":price
    };
  }

  factory MyClient.fromDocument(DocumentSnapshot doc) {

    int id = 0;
    String name = "";
    String phone = "";
    String address = "";
    String carNumber = "";
    String bookingDate = "";
    String bookingTime = "";
    String service = "";
    double price = 0.0;

    try{
      id = doc.get('id');
    }catch(e){}

    try{
      name = doc.get('name');
    }catch(e){}

    try{
      phone = doc.get('phone');
    }catch(e){}

    try{
      address = doc.get('address');
    }catch(e){}

    try{
      carNumber = doc.get('carNumber');
    }catch(e){}

    try{
      bookingDate = doc.get('bookingDate');
    }catch(e){}

    try{
      bookingTime = doc.get('bookingTime');
    }catch(e){}

    try{
      service = doc.get('service');
    }catch(e){}

    try{
      price = doc.get('price');
    }catch(e){}


    return MyClient(
      id:id,
      name:name,
      phone:phone,
      address:address,
      bookingDate:bookingDate,
      bookingTime:bookingTime,
      price:price,
      service:service,
      carNumber:carNumber
    );
  }
}