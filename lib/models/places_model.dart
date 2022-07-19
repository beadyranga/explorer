import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Places extends Equatable {
  final String name;
  final String category;
  final String city;
  final String images;
  final String country;
  final String province;

  const Places({required this.country, required this.city,required this.name, required this.category,required this.images,required this.province});

  static Places fromSnapshot(DocumentSnapshot snapshot)  {
      Places places =
      Places(name: snapshot['name'],
          category: snapshot['category'],
          city: snapshot['city'],
          images:snapshot['images'],
          province:snapshot['province'],
          country:snapshot['country']);

    return places;
  }

  @override
  List<Object?> get props => [name,images,category,city,province,country];

}