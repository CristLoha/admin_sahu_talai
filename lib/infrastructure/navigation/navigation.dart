import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/admin_detail/admin_detail.screen.dart';
import '../../presentation/detail/detail.screen.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/admin_detail.controller.binding.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'bindings/controllers/detail.controller.binding.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  const EnvironmentsBadge({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.production
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.qas ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: LoginControllerBinding(),
    ),
    GetPage(
      name: Routes.admin,
      page: () => const AdminScreen(),
      binding: AdminControllerBinding(),
    ),
    GetPage(
      name: Routes.addwords,
      page: () => const AddWordsScreen(),
      binding: AddWordsControllerBinding(),
    ),
    GetPage(
      name: Routes.detail,
      page: () => DetailScreen(),
      binding: DetailControllerBinding(),
    ),
    GetPage(
      name: Routes.admin_detail,
      page: () => AdminDetailScreen(),
      binding: AdminDetailControllerBinding(),
    ),
  ];
}
