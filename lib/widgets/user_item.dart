import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/provider.dart';
import '../routes/add_edit_product.dart';
import '../providers/cart.dart';

class UserItem extends StatelessWidget {
  final String? id;
  final String title;
  final String imageUrl;
  const UserItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProduct.routeName, arguments: id);
            },
            icon: const Icon(Icons.edit),
            color: Colors.purple,
          ),
          IconButton(
            onPressed: () {
              Provider.of<Products>(context, listen: false)
                  .deleteProduct(id as String);
            },
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          )
        ]),
      ),
    );
  }
}
