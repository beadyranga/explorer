import '../../models/places_model.dart';

abstract class BasePlacesRepository {
  Stream<List<Places>> getAllPlaces();
}