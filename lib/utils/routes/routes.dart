



import 'package:flutter/material.dart';
import 'package:image_uploader/utils/routes/routes_name.dart';
import 'package:image_uploader/view/home_screen.dart';
import 'package:image_uploader/view/image_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.image:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ImageScreen(),
        );
      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('no such routes'),
              ),
            );
          },
        );
    }
  }
}
