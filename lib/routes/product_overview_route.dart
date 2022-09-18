import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../routes/cart_route.dart';
import '../widgets/drawer.dart';

enum filterOptions { Favorites, All }

class ProductOverViewRoute extends StatefulWidget {
  const ProductOverViewRoute({Key? key}) : super(key: key);

  @override
  State<ProductOverViewRoute> createState() => _ProductOverViewRouteState();
}

class _ProductOverViewRouteState extends State<ProductOverViewRoute> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fecthProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  var showFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        backgroundColor: Colors.purple,
        actions: [
          PopupMenuButton(
            onSelected: ((filterOptions value) => {
                  setState(() {
                    if (value == filterOptions.Favorites) {
                      showFavorite = true;
                    } else {
                      showFavorite = false;
                    }
                  })
                }),
            itemBuilder: ((_) => [
                  const PopupMenuItem(
                    value: filterOptions.Favorites,
                    child: Text('Show Favorites'),
                  ),
                  const PopupMenuItem(
                    value: filterOptions.All,
                    child: Text('Show All'),
                  )
                ]),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.itemCount.toString(),
              child: ch as Widget,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CardRoute.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            )
          : ProductGrid(showFavorite),
    );
  }
}
