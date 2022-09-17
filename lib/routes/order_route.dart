import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class OrderRoute extends StatelessWidget {
  static const routeName = '/order';
  const OrderRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
        backgroundColor: Colors.purple,
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(order: orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
