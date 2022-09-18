import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import '../providers/products.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/add-edit-product';

  const EditProduct({Key? key}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  @override
  void initState() {
    _imageUrlFocusNode.addListener(imageUrlFocus);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(imageUrlFocus);
    _priceFocusedNode.dispose();
    _descriptionFocusedNode.dispose();
    _imageUrl.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void imageUrlFocus() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrl.text.startsWith('http') &&
              !_imageUrl.text.startsWith('https')) ||
          (!_imageUrl.text.endsWith('.png') &&
              !_imageUrl.text.endsWith('.jpg') &&
              !_imageUrl.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  var _isLoading = false;

  void saveForm() async {
    final valid = _form.currentState!.validate();
    if (!valid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id as String, _editedProduct);
      setState(() {
        _isLoading = false;
        Navigator.of(context).pop();
      });
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Error Occurred'),
                  content: const Text('Something went wrong!'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _isLoading = false;
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Ok'))
                  ],
                ));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }

    // Navigator.of(context).pop();
  }

  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  bool _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context)?.settings.arguments as String;
      if (id != 'newProduct') {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(id);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrl.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  final _priceFocusedNode = FocusNode();
  final _descriptionFocusedNode = FocusNode();
  final _imageUrl = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        initialValue: _initValues['title'],
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_priceFocusedNode),
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: value as String,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value ';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        initialValue: _initValues['price'],
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusedNode,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusedNode),
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: double.parse(value as String),
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a price ';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please provide valid price';
                          }

                          if (double.parse(value) <= 0) {
                            return 'Please provide value greater dan zero';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        initialValue: _initValues['description'],
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusedNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: value as String,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a description ';
                          }
                          if (value.length < 10) {
                            return 'Please provide at least 10 characters ';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.grey)),
                            child: Container(
                              child: _imageUrl.text.isEmpty
                                  ? const Text('Enter Image Url')
                                  : Image.network(
                                      _imageUrl.text,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrl,
                              focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                saveForm();
                                setState(() {});
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    description: _editedProduct.description,
                                    imageUrl: value as String,
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an image URL.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL.';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid image URL.';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
