import 'package:bucket_list_app/bucket_data.dart';
import 'package:bucket_list_app/show_bucket_screen.dart';
import 'package:bucket_list_app/utils/dialog_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'add_bucket_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isError = false;
  List<BucketData> buckets = [];

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await Dio().get(
          'https://fluttertestapi-d485a-default-rtdb.firebaseio.com/bucketList.json');

      if (response.data is List) {
        buckets = (response.data as List<dynamic>)
            .where((element) => element != null)
            .map((json) => BucketData.fromJson(json))
            .toList();
      } else if (response.data is Map) {
        buckets = (response.data as Map<String, dynamic>)
            .values
            .where((item) => item != null)
            .map((json) => BucketData.fromJson(json))
            .toList();
      } else {
        buckets = [];
      }
      isError = false;
    } catch (e) {
      isError = true;
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> _restoreBucket(int index) async {
    setState(() {
      isLoading = true;
    });
    try {
      Map completedBucket = {
        'completed': false,
      };
      await Dio().patch(
          'https://fluttertestapi-d485a-default-rtdb.firebaseio.com/bucketList/$index.json',
          data: completedBucket);
    } catch (e) {
      if (mounted) {
        DialogHelper.showAlertDialog(
          context,
          'Restore Bucket Error',
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
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isAllTasksCompleted = buckets.every((element) => element.isCompleted!);
    var isAnyTasksCompleted = buckets.any((element) => element.isCompleted!);

    return Scaffold(
      floatingActionButton: isLoading || isError
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddBucketList(index: buckets.length);
                })).then((value) {
                  if (value == 'refresh') {
                    fetchData();
                  }
                });
              },
              child: const Icon(Icons.add),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        bottom: const TabBar(tabs: [
          Tab(icon: Icon(Icons.incomplete_circle)),
          Tab(icon: Icon(Icons.done)),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () {
                fetchData();
              },
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
        title: const Text('My Bucket List'),
      ),
      body: TabBarView(
        children: [
          _buildTabView(context, buckets.isEmpty || isAllTasksCompleted,
              'No items in your bucket list', false),
          _buildTabView(
              context,
              (buckets.isNotEmpty && !isAnyTasksCompleted) || buckets.isEmpty,
              'No Completed items in your bucket list',
              true),
        ],
      ),
    );
  }

  Widget _buildTabView(BuildContext context, bool isEmpty, String emptyMessage,
      bool isCompleted) {
    return RefreshIndicator(
      onRefresh: () async {
        await fetchData();
      },
      child: isLoading
          ? Center(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: const LinearProgressIndicator()))
          : isError
              ? _buildErrorUI()
              : isEmpty
                  ? Center(
                      child: Text(
                      emptyMessage,
                      style: const TextStyle(fontSize: 15),
                    ))
                  : _buildListTile(context, isCompleted),
    );
  }

  Widget _buildListTile(BuildContext context, bool isCompleted) {
    var filteredList = buckets
        .where((bucket) =>
            isCompleted ? bucket.isCompleted! : !(bucket.isCompleted!))
        .toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        var bucket = filteredList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              splashColor: const Color(0xFF4f378b),
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                if (isCompleted) {
                  DialogHelper.showAlertDialog(
                    context,
                    'Restore Bucket',
                    'Are you sure you want to restore this bucket?',
                    () async {
                      await _restoreBucket(bucket.index!);
                      await fetchData();
                    },
                  );
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ShowBucketList(
                    item: bucket.itemName!,
                    price: bucket.price!,
                    imageURL: bucket.imageURL!,
                    description: bucket.description!,
                    index: bucket.index!,
                    isCompleted: bucket.isCompleted!,
                  );
                })).then((value) {
                  if (value == 'refresh') {
                    fetchData();
                  }
                });
              },
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                title: Text(
                  bucket.itemName!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(bucket.imageURL!),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.attach_money, color: Colors.green),
                    Text(
                      bucket.price!.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error),
        const Text(
          'Error fetching data',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              fetchData();
            },
            child: const Text('Retry')),
      ]),
    );
  }
}
