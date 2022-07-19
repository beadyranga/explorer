import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/models/places_model.dart';
import 'package:explorer/repositories/places/places_base_repository.dart';

class PlacesRepository extends BasePlacesRepository {

  final FirebaseFirestore _firebaseFirestore;

  PlacesRepository({FirebaseFirestore? firebaseFirestore }):
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Places>> getAllPlaces() {
    return _firebaseFirestore
        .collection('events')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc)=> Places.fromSnapshot(doc)).toList();
    });


  }

}