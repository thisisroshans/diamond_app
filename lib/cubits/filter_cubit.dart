import 'package:diamond_app/models/diamond_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/diamond_service.dart';

class FilterState {
  final double caratFrom;
  final double caratTo;
  final String lab;
  final String shape;
  final String color;
  final String clarity;
  final List<Diamond> diamonds;

  FilterState({
    this.caratFrom = 0.5,
    this.caratTo = 5.0,
    this.lab = 'GIA',
    this.shape = 'Round',
    this.color = 'D',
    this.clarity = 'IF',
    this.diamonds = const [],
  });

  FilterState copyWith({
    double? caratFrom,
    double? caratTo,
    String? lab,
    String? shape,
    String? color,
    String? clarity,
    List<Diamond>? diamonds,
  }) {
    return FilterState(
      caratFrom: caratFrom ?? this.caratFrom,
      caratTo: caratTo ?? this.caratTo,
      lab: lab ?? this.lab,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      clarity: clarity ?? this.clarity,
      diamonds: diamonds ?? this.diamonds,
    );
  }
}

class FilterCubit extends Cubit<FilterState> {
  final DiamondService diamondService;

  FilterCubit(this.diamondService) : super(FilterState());

  void updateFilters({
    double? caratFrom,
    double? caratTo,
    String? lab,
    String? shape,
    String? color,
    String? clarity,
  }) {
    emit(state.copyWith(
      caratFrom: caratFrom,
      caratTo: caratTo,
      lab: lab,
      shape: shape,
      color: color,
      clarity: clarity,
    ));
  }

  Future<void> fetchDiamonds() async {
    try {
      final diamonds = await diamondService.fetchDiamonds(
        caratFrom: state.caratFrom,
        caratTo: state.caratTo,
        lab: state.lab,
        shape: state.shape,
        color: state.color,
        clarity: state.clarity,
      );
      emit(state.copyWith(diamonds: diamonds));
    } catch (e) {
      print("Error fetching diamonds: $e");
    }
  }
}