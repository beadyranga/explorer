import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:explorer/repositories/places/places_repository.dart';

import '../../../models/places_model.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final PlacesRepository _placesRepository;
  StreamSubscription? _placesSubscription;

  PlacesBloc({required PlacesRepository placesRepository}) 
      : _placesRepository = placesRepository,
        super(placesLoading());


 Stream<PlacesState> mapEventToState(PlacesEvent event) async* {

    if(event is LoadPlaces) {
      yield* _mapLoadPlacesToState();
    }

    if(event is UpdatePlaces) {
      yield*  _mapUpdatePlacesToState(event);
    }
  }

  Stream<PlacesState> _mapLoadPlacesToState() async* {
    _placesSubscription?.cancel();
    _placesSubscription = _placesRepository.getAllPlaces().listen((categories) => add(UpdatePlaces(categories)));
  }

  Stream<PlacesState> _mapUpdatePlacesToState(UpdatePlaces events) async*{
    yield placesLoded(places: events.places);
  }
}


