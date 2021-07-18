import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../Providers/cart.dart';
import 'cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../Providers/products.dart';

enum FilterOptions {
  All,
  Favorites,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = true;

  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<Products>(context).fetchAndSetProduct();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'My Shop',
          ),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text('All items'),
                    value: FilterOptions.All,
                  ),
                  PopupMenuItem(
                    child: Text('Favorites'),
                    value: FilterOptions.Favorites,
                  )
                ];
              },
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
            ),
            Consumer<Cart>(
              builder: (ctx, cart, child) {
                return Badge(
                  child: child!,
                  value: cart.itemCount.toString(),
                );
              },
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: Icon(Icons.shopping_cart),
              ),
            ),
          ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(
              showFavs: _showOnlyFavorites,
            ),
    );
  }
}
