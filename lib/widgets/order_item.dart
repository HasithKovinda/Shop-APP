import 'dart:math';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expand = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat.yMMMEd().format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expand ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expand = !_expand;
                });
              },
            ),
          ),
          if (_expand)
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: min(widget.order.products.length * 20.00 + 10, 100),
                child: ListView(
                  children: widget.order.products
                      .map((pro) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pro.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${pro.quantity}x \$${pro.price}',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.grey),
                              )
                            ],
                          ))
                      .toList(),
                ))
        ],
      ),
    );
  }
}
