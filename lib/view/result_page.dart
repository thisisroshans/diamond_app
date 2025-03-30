import 'package:diamond_app/cubits/cart_bloc.dart';
import 'package:diamond_app/view/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/filter_cubit.dart';
import '../models/diamond_model.dart';


class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diamond Results'),
        actions: [
          IconButton(
            icon: BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                int totalItems = cartState.cartItems.values
                    .fold(0, (sum, diamond) => sum + diamond.qty);
                return Badge(
                  label: Text(totalItems.toString()),
                  child: Icon(Icons.shopping_cart),
                );
              },
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<FilterCubit, FilterState>(
        builder: (context, filterState) {
          if (filterState.diamonds.isEmpty) {
            return Center(child: Text("No diamonds found"));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: filterState.diamonds.length,
            separatorBuilder: (context, index) => SizedBox(height: 16),
            itemBuilder: (context, index) {
              return DiamondListTile(diamond: filterState.diamonds[index]);
            },
          );
        },
      ),
    );
  }
}

class DiamondListTile extends StatelessWidget {
  final Diamond diamond;
  const DiamondListTile({required this.diamond, super.key});

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final quantity = cartCubit.getQuantity(diamond);
        return ListTile(
          contentPadding: EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text("Carat: ${diamond.carat}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Shape: ${diamond.shape}"),
              Text("Color: ${diamond.color}"),
              Text("Clarity: ${diamond.clarity}"),
              Text("Lab: ${diamond.lab}"),
            ],
          ),
          trailing: quantity == 0
              ? ElevatedButton(
                  onPressed: () => cartCubit.addToCart(diamond, context),
                  child: Text("Add to Cart"),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => cartCubit.removeFromCart(diamond, context),
                    ),
                    Text("$quantity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => cartCubit.addToCart(diamond, context),
                    ),
                  ],
                ),
        );
      },
    );
  }
}