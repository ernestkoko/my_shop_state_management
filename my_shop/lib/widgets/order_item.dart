import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({Key key, this.order}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyy  hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4 ),
              height: min(widget.order.products.length * 20.0 + 10, 180),
              child: ListView(
                  children: widget.order.products
                      .map((product) =>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                        children: <Widget>[
                          Text(
                            product.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                          ,
                          Text('${product.quantity}x \$${product.price}',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey),)
                        ],
                      ))
                      .toList()),
            )
        ],
      ),
    );
  }
}
