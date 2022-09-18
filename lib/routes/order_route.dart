import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class OrderRoute extends StatefulWidget {
  static const routeName = '/order';
  const OrderRoute({Key? key}) : super(key: key);

  @override
  State<OrderRoute> createState() => _OrderRouteState();
}

class _OrderRouteState extends State<OrderRoute> {
  late Future ordersFuture;
  Future obtainFutureOrder() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    ordersFuture = obtainFutureOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order'),
          backgroundColor: Colors.purple,
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: ordersFuture,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                        itemBuilder: (ctx, i) =>
                            OrderItem(order: orderData.orders[i]),
                        itemCount: orderData.orders.length,
                      ));
            }
          }),
        ));
  }
}
