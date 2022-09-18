import 'package:flutter/material.dart';
import 'package:shop_app/routes/product_details_route.dart';
import './routes/product_overview_route.dart';
import 'package:provider/provider.dart';
import 'providers/products.dart';
import './providers/cart.dart';
import './routes/cart_route.dart';
import './providers/orders.dart';
import './routes/order_route.dart';
import './routes/user_route.dart';
import './routes/add_edit_product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders())
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primaryColor: Colors.purple,
          fontFamily: 'Lato',
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange),
        ),
        home: ProductOverViewRoute(),
        routes: {
          ProductDetails.routeName: (context) => ProductDetails(),
          CardRoute.routeName: ((context) => CardRoute()),
          OrderRoute.routeName: ((context) => OrderRoute()),
          UserRoute.routeName: (context) => UserRoute(),
          EditProduct.routeName: (context) => EditProduct()
        },
      ),
    );
  }
}
