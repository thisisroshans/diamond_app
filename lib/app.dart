import 'package:diamond_app/cubits/cart_bloc.dart';
import 'package:diamond_app/cubits/filter_cubit.dart';
import 'package:diamond_app/utils/injection.dart';
import 'package:diamond_app/view/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KgkDiamondApp extends StatelessWidget {
  const KgkDiamondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FilterCubit>(
          create: (context) => getIt<FilterCubit>(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => getIt<CartCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'KGK Diamonds',
        home: FilterPage(), // Set your initial page
      ),
    );
  }
}
