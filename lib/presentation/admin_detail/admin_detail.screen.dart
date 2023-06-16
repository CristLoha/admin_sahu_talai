import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/admin_detail.controller.dart';

class AdminDetailScreen extends GetView<AdminDetailController> {
  const AdminDetailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminDetailScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminDetailScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
