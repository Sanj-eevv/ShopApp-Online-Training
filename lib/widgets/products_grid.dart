import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/Product_item.dart';
import '../Providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid({
    required this.showFavs,
  });

  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavs ? productsData.showFavoritesItem : productsData.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}
