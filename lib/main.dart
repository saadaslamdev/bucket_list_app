import 'package:bucket_list_app/providers/screen_utils_provider.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

void main(List<String> args) {
  runApp(const BucketListApp());
}

class BucketListApp extends StatelessWidget {
  const BucketListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilsProvider(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var screenUtils = ScreenUtilsProvider.of(context);
        screenUtils.updateCurrentResolution(Size(
          constraints.maxWidth,
          constraints.maxHeight,
        ));
        return MaterialApp(
          title: 'My Bucket List',
          theme: ThemeData.dark(
            useMaterial3: true,
          ),
          home: const DefaultTabController(length: 2, child: HomeScreen()),
        );
      }),
    );
  }
}
