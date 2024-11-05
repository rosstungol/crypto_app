import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../widgets/add_asset_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const CircleAvatar(
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.dialog(const AddAssetDialog());
          },
          icon: const Icon(Icons.add),
        )
      ],
    );
  }
}
