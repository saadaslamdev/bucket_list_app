import 'package:flutter/material.dart';

class EditBucketList extends StatefulWidget {
  final String item;
  final String imageURL;
  final double price;
  final String description;
  const EditBucketList(
      {super.key,
      required this.item,
      required this.imageURL,
      required this.price,
      required this.description});

  @override
  State<EditBucketList> createState() => _EditBucketListState();
}

class _EditBucketListState extends State<EditBucketList> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _itemController.text = widget.item;
    _priceController.text = widget.price.toString();
    _imageURLController.text = widget.imageURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit a Bucket List'),
        centerTitle: true,
      ),
      body: Column(children: [
        TextField(
          controller: _itemController,
          decoration: const InputDecoration(labelText: 'Item'),
        ),
        TextField(
          controller: _priceController,
          decoration: const InputDecoration(labelText: 'Price'),
        ),
        TextField(
          controller: _imageURLController,
          decoration: const InputDecoration(labelText: 'Image URL'),
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Save Changes'))
      ]),
    );
  }
}
