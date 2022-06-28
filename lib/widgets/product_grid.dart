import 'package:flutter/material.dart';

import 'package:flutter_application_20/providers/products.dart';

import 'package:provider/provider.dart';

import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;

  ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //create : (c) => products[i],
        value: products[i],
        child:  ProductItem(
        //Products[i].id,
        //Products[i].title,
        //Products[i].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
         childAspectRatio: 3/2,
         crossAxisSpacing: 10,
         mainAxisSpacing: 10,
         ),
    );
  }
}