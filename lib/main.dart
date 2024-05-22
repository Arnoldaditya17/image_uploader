import 'package:flutter/material.dart';
import 'package:image_uploader/utils/routes/routes.dart';
import 'package:image_uploader/utils/routes/routes_name.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RoutesName.home,
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
