import 'package:diamond_app/cubits/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          }

          return ListView(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.cartItems.length,
                itemBuilder: (context, index) {
                  final diamondKey = state.cartItems.keys.elementAt(index);
                  final diamond = state.cartItems[diamondKey]!;
                  return ListTile(
                    title: Text('${diamond.shape} - ${diamond.carat} ct'),
                    subtitle: Text(
                        'Price: \$${diamond.finalAmount}, Qty: ${diamond.qty}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () => context
                          .read<CartCubit>()
                          .deleteFromCart(diamond, context),
                    ),
                  );
                },
              ),
              Divider(),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                children: [
                  Text('Summary',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Total Carat: ${state.totalCarat.toStringAsFixed(2)}'),
                  Text('Total Price: \$${state.totalPrice.toStringAsFixed(2)}'),
                  Text(
                      'Average Price: \$${state.averagePrice.toStringAsFixed(2)}'),
                  Text(
                      'Average Discount: ${state.averageDiscount.toStringAsFixed(2)}%'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
