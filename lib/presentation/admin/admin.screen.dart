import 'package:admin_sahu_talai/infrastructure/navigation/routes.dart';
import 'package:admin_sahu_talai/infrastructure/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'components/table_admin.dart';
import 'controllers/admin.controller.dart';

class AdminScreen extends GetView<AdminController> {
  const AdminScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: shamrockGreen,
        title: const Text('Daftar Kata'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TableAdmin(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.addwords),
        backgroundColor: vividYellow,
        child: const Icon(Icons.add),
      ),
    );
  }
}
