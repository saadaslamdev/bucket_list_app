import 'package:bucket_list_app/edit_bucket_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'utils/dialog_helper.dart';

class ShowBucketList extends StatefulWidget {
  final String item;
  final String imageURL;
  final double price;
  final String description;
  final int index;
  final bool isCompleted;
  const ShowBucketList(
      {super.key,
      required this.item,
      required this.imageURL,
      required this.price,
      required this.description,
      required this.index,
      required this.isCompleted});

  @override
  State<ShowBucketList> createState() => _ShowBucketListState();
}

class _ShowBucketListState extends State<ShowBucketList> {
  bool isLoading = false;

  Future<void> _deleteBucket() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Dio().delete(
          'https://fluttertestapi-d485a-default-rtdb.firebaseio.com/bucketList/${widget.index}.json');
      if (mounted) {
        Navigator.pop(context, 'refresh');
      }
    } catch (e) {
      if (mounted) {
        DialogHelper.showAlertDialog(
          context,
          'Delete Bucket Error',
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

  Future<void> _completeBucket() async {
    setState(() {
      isLoading = true;
    });
    try {
      Map completedBucket = {
        'completed': true,
      };
      await Dio().patch(
          'https://fluttertestapi-d485a-default-rtdb.firebaseio.com/bucketList/${widget.index}.json',
          data: completedBucket);
      if (mounted) {
        Navigator.pop(context, 'refresh');
      }
    } catch (e) {
      if (mounted) {
        DialogHelper.showAlertDialog(
          context,
          'Complete Bucket Error',
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
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditBucketList(
                      item: widget.item,
                      imageURL: widget.imageURL,
                      price: widget.price,
                      description: widget.description);
                }));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
              ];
            },
          )
        ],
        title: Text(widget.item),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.imageURL),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                spreadRadius: 5.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6.0,
                                      spreadRadius: 2.0,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.attach_money,
                                        color: Colors.green, size: 24),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.price.toString(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: widget.isCompleted
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8.0,
                                      spreadRadius: 3.0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Status: ',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: widget.isCompleted
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      widget.isCompleted
                                          ? Icons.check_circle
                                          : Icons.hourglass_bottom,
                                      color: widget.isCompleted
                                          ? Colors.green
                                          : Colors.red,
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: isLoading || widget.isCompleted
          ? null
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        _completeBucket();
                      },
                      tooltip: 'Mark as Done',
                      heroTag: 'add',
                      child: const Icon(Icons.done),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        DialogHelper.showAlertDialog(
                          context,
                          'Delete Bucket',
                          'Are you sure you want to delete this bucket?',
                          () {
                            _deleteBucket();
                          },
                        );
                      },
                      tooltip: 'Delete Bucket',
                      heroTag: 'delete',
                      child: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
