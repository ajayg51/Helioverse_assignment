import 'package:emp_data/employee_card.dart';
import 'package:emp_data/employee_info_screen_controller.dart';
import 'package:emp_data/utils/common_background.dart';
import 'package:emp_data/utils/emp_filter_extension.dart';
import 'package:emp_data/utils/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeInfoScreen extends StatelessWidget {
  EmployeeInfoScreen({super.key});
  final controller = Get.put(EmployeeInfoScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        automaticallyImplyLeading: false,
        title: Text(
          "Employee Details",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
        ),
        flexibleSpace: const CommonBackground(),
        // backgroundColor: const Color.fromARGB(255, 84, 86, 84),
        actions: [
          Row(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Get.toNamed("team-member-list");
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.brown.withOpacity(0.4),
                        Colors.purple.withOpacity(0.6),
                        Colors.red.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "View team members",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              20.horizontalSpace,
            ],
          ),
        ],
      ),
      // backgroundColor: const Color.fromARGB(255, 114, 121, 115),
      body: CommonBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSearchBar(context: context),
              ],
            ),
            10.verticalSpace,
            buildFiltersAndResetFiltersBtn(context),
            10.verticalSpace,
            buildSelectedFilterSection(context: context),
            10.verticalSpace,
            Row(
              children: [
                Expanded(
                    child: Container(
                  height: 3,
                  color: Colors.black,
                )),
              ],
            ),
            Expanded(
              child: Obx(() {
                final data = controller.filteredData().toList();
                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      "No data for current search/selcted filter",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  );
                }
                return GridView.extent(
                  maxCrossAxisExtent: 300,
                  controller: controller.scrollController,
                  children: List.generate(
                    data.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Obx(() {
                        return EmployeeCard(
                          data: data[index],
                          isShowCheckbox: controller.isShowCheckbox.value,
                          employeeAlreadyInTeamList:
                              controller.employeeAlreadyInTeamList,
                          addedToTeamDataSet:
                              controller.employeeSetToBeAddedInTeam,
                          onEmployeeSelect: (value) =>
                              controller.onEmployeeSelect(
                            value: value,
                            datum: data[index],
                          ),
                        );
                      }),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar({required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: TextFormField(
          textAlign: TextAlign.center,
          cursorColor: Colors.black,
          onChanged: controller.onSearch,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
          decoration: const InputDecoration(
            hintText: "Search by name",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildFiltersAndResetFiltersBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildDropDown(context: context),
                20.horizontalSpace,
                buildDropDown(
                  context: context,
                  type: "DOMAIN",
                ),
                20.horizontalSpace,
                buildDropDown(
                  context: context,
                  type: "AVAILABILITY",
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(() {
                String addToTeamOrRemoveText = "Select team members";
                if (controller.isShowCheckbox.value) {
                  addToTeamOrRemoveText = "Clear selection";
                }
                return Row(
                  children: [
                    if (controller.employeeSetToBeAddedInTeam.isNotEmpty) ...[
                      InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: controller.onAddToTeamBtnTap,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.brown.withOpacity(0.4),
                                Colors.purple.withOpacity(0.6),
                                Colors.red.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Add to team",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    ],
                    6.horizontalSpace,
                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: controller.onSelectTeamMembersTap,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.brown.withOpacity(0.4),
                              Colors.purple.withOpacity(0.6),
                              Colors.red.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          addToTeamOrRemoveText,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                    if (controller.genderSelectedFilterList.isNotEmpty ||
                        controller.domainSelectedFilterList.isNotEmpty ||
                        controller
                            .availabilitySelectedFilterList.isNotEmpty) ...[
                      12.horizontalSpace,
                      InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: controller.onTapResetAllFilters,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.brown.withOpacity(0.4),
                                Colors.purple.withOpacity(0.6),
                                Colors.red.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Reset All Filters",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    ]
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSelectedFilterSection({required BuildContext context}) {
    return Obx(() {
      final genderSelectedFilterList = controller.genderSelectedFilterList;
      final domainSelectedFilterList = controller.domainSelectedFilterList;
      final availabilitySelectedFilterList =
          controller.availabilitySelectedFilterList;
      final allSelectedFilterList = [
        ...genderSelectedFilterList,
        ...domainSelectedFilterList,
        ...availabilitySelectedFilterList
      ];
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: List.generate(
              allSelectedFilterList.length,
              (index) {
                final filter = allSelectedFilterList[index];
                String filterLabel = "";
                if (filter.runtimeType == GenderFilterEnums) {
                  final selectedFilter = filter as GenderFilterEnums;
                  filterLabel = selectedFilter.name;
                } else if (filter.runtimeType == DomainFilterEnums) {
                  final selectedFilter = filter as DomainFilterEnums;
                  filterLabel = selectedFilter.name;
                } else if (filter.runtimeType == AvailabilityFilterEnums) {
                  final selectedFilter = filter as AvailabilityFilterEnums;
                  filterLabel = selectedFilter.name;
                }
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Colors.brown.withOpacity(0.4),
                            Colors.purple.withOpacity(0.6),
                            Colors.red.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            filterLabel[0].toUpperCase() +
                                filterLabel.substring(1),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          6.horizontalSpace,
                          InkWell(
                            onTap: () =>
                                controller.onIndividualFilterReset(filter),
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                    ),
                    12.horizontalSpace,
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Widget buildDropDown({
    required BuildContext context,
    String? type,
  }) {
    return Obx(() {
      final genderFilterList = controller.genderFilterList.toList();
      final domainFilterList = controller.domainFilterList.toList();
      final availabilityFilterList = controller.availabilityFilterList.toList();
      final list = type == "DOMAIN"
          ? domainFilterList
          : type == "AVAILABILITY"
              ? availabilityFilterList
              : genderFilterList;
      final dropDownController = type == "DOMAIN"
          ? controller.domainFilterController
          : type == "AVAILABILITY"
              ? controller.availabilityFilterController
              : controller.genderFilterController;
      return DropdownMenu(
        width: 200,
        controller: dropDownController,
        enableFilter: true,
        onSelected: (filterType) =>
            controller.onDropDownMenuItemTap(filterType: filterType),
        textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 14,
            ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        label: Text(
          type == "DOMAIN"
              ? "Select domain"
              : type == "AVAILABILITY"
                  ? "Select availability"
                  : "Select gender",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 14,
              ),
        ),
        dropdownMenuEntries: list.map<DropdownMenuEntry>(
          (e) {
            return DropdownMenuEntry(
              value: e,
              label: e.name[0].toUpperCase() + e.name.substring(1),
            );
          },
        ).toList(),
      );
    });
  }
}
