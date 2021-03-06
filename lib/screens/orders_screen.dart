import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/orders.dart';
import '../widgets/order_item.dart' as orderItem;
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders_screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetProduct();
  }

  // var _isLoading = false;
  void initState() {
    // Future.delayed(Duration.zero).then((value) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   await Provider.of<Orders>(context, listen: false).fetchAndSetProduct();
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });

    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Text('Error');
            } else {
              return ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, i) {
                  return orderItem.OrderItem(
                    order: orderData.orders[i],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
