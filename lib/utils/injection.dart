import 'package:diamond_app/network/api_client.dart';
import 'package:diamond_app/network/diamond_service.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:diamond_app/cubits/filter_cubit.dart';
import 'package:diamond_app/cubits/cart_bloc.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(() => ApiClient().dio);
  getIt.registerLazySingleton<DiamondService>(
      () => DiamondService(getIt<Dio>()));
  getIt.registerLazySingleton<FilterCubit>(
      () => FilterCubit(getIt<DiamondService>()));
  getIt.registerLazySingleton<CartCubit>(() => CartCubit());
}
