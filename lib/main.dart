import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/cart_screen.dart';
import 'Providers/products.dart';
import 'Providers/cart.dart';
import 'Providers/orders.dart';
import 'screens/orders_screen.dart';

void main() {
  return runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          accentColor: Colors.deepOrange,
          primarySwatch: Colors.purple,
          fontFamily: 'Lato',
        ),
        routes: {
          ProductDetailScreen.routeName: (context) {
            return ProductDetailScreen();
          },
          CartScreen.routeName: (context) {
            return CartScreen();
          },
          OrdersScreen.routeName: (context) {
            return OrdersScreen();
          }
        },
        home: ProductsOverviewScreen(),
      ),
    );
  }
}
