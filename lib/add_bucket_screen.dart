import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils/dialog_helper.dart';

class AddBucketList extends StatefulWidget {
  int index;
  AddBucketList({super.key, required this.index});

  @override
  State<AddBucketList> createState() => _AddBucketListState();
}

class _AddBucketListState extends State<AddBucketList> {
  bool isLoading = false;
  TextEditingController itemController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> saveData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map data = {
        'item': itemController.text,
        'price': priceController.text,
        'image': imageURLController.text,
        'description': descriptionController.text,
        'index': widget.index,
        'completed': false,
      };
      await Dio().patch(
          'https://fluttertestapi-d485a-default-rtdb.firebaseio.com/bucketList/${widget.index}.json',
          data: data);
      if (mounted) {
        Navigator.pop(context, 'refresh');
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        DialogHelper.showAlertDialog(
          context,
          'Save Bucket Error',
          'Something went wrong',
          () {
            print(e);
          },
          showCancelButton: false,
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Bucket List'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                TextField(
                  controller: itemController,
                  decoration: InputDecoration(labelText: 'Item'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter price',
                    prefixText: '\$',
                  ),
                ),
                TextField(
                  controller: imageURLController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter your description here...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      saveData();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.black),
                    )),
              ]),
            ),
    );
  }
}
