import 'package:emp_data/employee_card.dart';
import 'package:emp_data/team_info_screen_controller.dart';
import 'package:emp_data/utils/common_background.dart';
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
                color: Colors.black,
              ),
        ),
        flexibleSpace: const CommonBackground(),
      ),
      backgroundColor: const Color.fromARGB(255, 114, 121, 115),
      body: data.isEmpty
          ? CommonBackground(
              child: Center(
                child: Text(
                  "No employee in team",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            )
          : CommonBackground(
              child: GridView.extent(
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
            ),
    );
  }
}
