import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
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
      name: Routes.admindDetail,
      page: () => AdminDetailScreen(),
      binding: AdminDetailControllerBinding(),
    ),
    GetPage(
      name: Routes.editAdmin,
      page: () => const EditAdminScreen(),
      binding: EditAdminControllerBinding(),
    ),
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashControllerBinding(),
    ),
  ];
}
