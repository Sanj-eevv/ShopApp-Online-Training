import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/orders.dart';
import '../widgets/order_item.dart' as orderItem;
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_screen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, i) {
          return orderItem.OrderItem(
            order: orderData.orders[i],
          );
        },
      ),
    );
  }
}
