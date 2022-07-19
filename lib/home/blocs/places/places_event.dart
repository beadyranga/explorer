part of 'places_bloc.dart';

abstract class PlacesEvent extends Equatable {
  const PlacesEvent();

  List<Object> get props => [];
}
class LoadPlaces extends PlacesEvent {

}

class UpdatePlaces extends PlacesEvent {
  final List<Places> places;
  UpdatePlaces(this.places);

  List<Object> get props => [places];
}