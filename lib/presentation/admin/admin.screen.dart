import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/admin.controller.dart';

class AdminScreen extends GetView<AdminController> {
  const AdminScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kerja'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
