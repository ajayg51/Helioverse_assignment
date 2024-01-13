import 'dart:ui';

import 'package:emp_data/employee_info_screen.dart';
import 'package:emp_data/models/team.dart';
import 'package:emp_data/models/team_hive_adapter.dart';
import 'package:emp_data/team_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive
    ..init("./")
    ..registerAdapter(TeamHiveAdapter());
  await Hive.openBox<Team>("team");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Employee Info',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: "/",
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: const TextTheme(
              bodyLarge: TextStyle(
            fontSize: 10,
          ))),
      getPages: [
        GetPage(name: "/", page: () => EmployeeInfoScreen()),
        GetPage(name: "/team-member-list", page: () => TeamInfoScreen()),
      ],
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
