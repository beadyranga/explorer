part of 'places_bloc.dart';

abstract class PlacesState extends Equatable {
  const PlacesState();

  List<Object> get props => [];
}

class placesLoading extends PlacesState {}

class placesLoded extends PlacesState {
  final List<Places> places;

  placesLoded({this.places = const <Places>[]});

  List<Object> get props => [places];
}