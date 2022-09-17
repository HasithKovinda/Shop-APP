import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import './product_item.dart';
import '../providers/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool show;
  ProductGrid(this.show);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = show ? productsData.favorite : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
