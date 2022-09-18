import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user_item.dart';
import '../providers/products.dart';
import '../widgets/drawer.dart';
import '../routes/add_edit_product.dart';

class UserRoute extends StatelessWidget {
  static const routeName = '/manage';
  const UserRoute({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fecthProducts();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: 'newProduct');
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ListView.builder(
            itemBuilder: ((_, index) => Column(
                  children: [
                    UserItem(
                        id: product.items[index].id,
                        title: product.items[index].title,
                        imageUrl: product.items[index].imageUrl),
                    const Divider()
                  ],
                )),
            itemCount: product.items.length,
          ),
        ),
      ),
    );
  }
}
