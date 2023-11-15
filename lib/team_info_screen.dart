import 'package:emp_data/employee_card.dart';
import 'package:emp_data/team_info_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamInfoScreen extends StatelessWidget {
  TeamInfoScreen({super.key});
  final controller = Get.put(TeamInfoScreenController());
  @override
  Widget build(BuildContext context) {
    final data = controller.teamMemberList;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        automaticallyImplyLeading: false,
        title: Text(
          "Selected team members",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
        ),
        backgroundColor: const Color.fromARGB(255, 84, 86, 84),
      ),
      backgroundColor: const Color.fromARGB(255, 114, 121, 115),
      body: data.isEmpty
          ? Center(
              child: Text(
                "No employee in team",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            )
          : GridView.extent(
              maxCrossAxisExtent: 300,
              controller: controller.scrollController,
              children: List.generate(
                data.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: EmployeeCard(data: data[index]),
                ),
              ),
            ),
    );
  }
}
