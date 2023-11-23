import 'package:emp_data/data/dummy_data.dart';
import 'package:emp_data/debouncer.dart';
import 'package:emp_data/models/team.dart';
import 'package:emp_data/utils/app_toast.dart';
import 'package:emp_data/utils/emp_filter_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class EmployeeInfoScreenController extends GetxController {
  final data = DummyData.empData.take(15).toList();
  final filteredData = (DummyData.empData.take(15).toList()).obs;
  RxSet<Map<String, Object>> employeeSetToBeAddedInTeam =
      <Map<String, Object>>{}.obs;

  final employeeAlreadyInTeamList = <Team>[].obs;
  final debouncer = Debouncer();
  final genderFilterList = <GenderFilterEnums>{}.obs;
  final domainFilterList = <DomainFilterEnums>{}.obs;
  final availabilityFilterList = <AvailabilityFilterEnums>{}.obs;

  final genderSelectedFilterList = <GenderFilterEnums>[].obs;
  final domainSelectedFilterList = <DomainFilterEnums>[].obs;
  final availabilitySelectedFilterList = <AvailabilityFilterEnums>[].obs;

  String searchedText = "";
  final genderFilterController = TextEditingController();
  final domainFilterController = TextEditingController();
  final availabilityFilterController = TextEditingController();
  final isShowCheckbox = false.obs;
  late Box<Team> box;
  int offset = 1;
  final scrollController = ScrollController();

  @override
  void onInit() async {
    super.onInit();
    box = Hive.box("team");
    final boxTeamValueList = box.values.toList();
    employeeAlreadyInTeamList.assignAll(boxTeamValueList);
    setupFilters();
    scrollController.addListener(scrollControllerMethod);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(scrollControllerMethod);
  }

  void scrollControllerMethod() {
    scrollController.position.isScrollingNotifier.addListener(() {
      if (!scrollController.position.isScrollingNotifier.value) {
        return;
      }
    });
    if (scrollController.position.maxScrollExtent < offset * 1000) {
      final count = offset == 1 ? 15 : 10;
      data.addAll(DummyData.empData.skip(offset * count).take(10));
      filterData();
      offset++;
    }
  }

  void onAddToTeamBtnTap() async {
    for (var item in employeeSetToBeAddedInTeam) {
      Team teamMember =
          Team(item["id"].toString(), domain: item["domain"] as String);
      await box.add(teamMember);
      final boxTeamValueList = box.values.toList();
      employeeAlreadyInTeamList.assignAll(boxTeamValueList);
    }
    employeeSetToBeAddedInTeam.clear();
    isShowCheckbox.value = false;
    MyAppToast.showAppToast("Successfully added to team");
  }

  void onSelectTeamMembersTap() {
    if (isShowCheckbox.value) {
      // Clear selection
      employeeSetToBeAddedInTeam.clear();
    }
    isShowCheckbox.toggle();
  }

  void onEmployeeSelect({
    bool? value,
    required Map<String, Object> datum,
  }) {
    if (value == true) {
      final boxTeamValueList = box.values.toList();
      final employeeList = boxTeamValueList
          .where((element) => element.domain == datum["domain"])
          .toList();
      final isMemberAlreadyInTeam = employeeList.isNotEmpty ||
          employeeSetToBeAddedInTeam
              .where((element) => element["domain"] == datum["domain"])
              .isNotEmpty;
      if (isMemberAlreadyInTeam) {
        MyAppToast.showAppToast("Same domain employee already exists in team");
        return;
      }
      employeeSetToBeAddedInTeam.add(datum);
    } else {
      employeeSetToBeAddedInTeam
          .removeWhere((element) => element["id"] == datum["id"]);
    }
  }

  void onTapResetAllFilters() {
    genderFilterController.clear();
    domainFilterController.clear();
    availabilityFilterController.clear();
    genderSelectedFilterList.clear();
    domainSelectedFilterList.clear();
    availabilitySelectedFilterList.clear();

    filteredData.assignAll(data);
  }

  void onIndividualFilterReset(dynamic filter) {
    final filterRuntimeType = filter.runtimeType;
    if (filterRuntimeType == GenderFilterEnums) {
      final selectedFilter = filter as GenderFilterEnums;
      genderSelectedFilterList
          .removeWhere((element) => element == selectedFilter);
      if (genderSelectedFilterList.isEmpty) {
        genderFilterController.clear();
      } else {
        final currentSelectedFilter = genderSelectedFilterList
            .elementAt(genderSelectedFilterList.length - 1)
            .name;
        genderFilterController.value = TextEditingValue(
          text: (currentSelectedFilter[0].toUpperCase() +
              currentSelectedFilter.substring(1)),
        );
      }

      filterData();
    } else if (filterRuntimeType == DomainFilterEnums) {
      final selectedFilter = filter as DomainFilterEnums;

      domainSelectedFilterList
          .removeWhere((element) => element == selectedFilter);
      if (domainSelectedFilterList.isEmpty) {
        domainFilterController.clear();
      } else {
        final currentSelectedFilter = domainSelectedFilterList
            .elementAt(domainSelectedFilterList.length - 1)
            .name;
        domainFilterController.value = TextEditingValue(
          text: (currentSelectedFilter[0].toUpperCase() +
              currentSelectedFilter.substring(1)),
        );
      }

      filterData();
    } else if (filterRuntimeType == AvailabilityFilterEnums) {
      final selectedFilter = filter as AvailabilityFilterEnums;

      availabilitySelectedFilterList
          .removeWhere((element) => element == selectedFilter);
      if (availabilitySelectedFilterList.isEmpty) {
        availabilityFilterController.clear();
      } else {
        final currentSelectedFilter = availabilitySelectedFilterList
            .elementAt(availabilitySelectedFilterList.length - 1)
            .name;
        availabilityFilterController.value = TextEditingValue(
          text: (currentSelectedFilter[0].toUpperCase() +
              currentSelectedFilter.substring(1)),
        );
      }

      filterData();
    }
  }

  void onSearch(String query) {
    query = query.trim();
    searchedText = query;
    debouncer.run(() => filterData());
  }

  void onDropDownMenuItemTap({dynamic filterType}) {
    if (filterType.runtimeType == GenderFilterEnums) {
      if (genderSelectedFilterList.contains(filterType)) {
        return;
      }
      genderSelectedFilterList.add(filterType);
    } else if (filterType.runtimeType == DomainFilterEnums) {
      if (domainSelectedFilterList.contains(filterType)) {
        return;
      }
      domainSelectedFilterList.add(filterType);
    } else if (filterType.runtimeType == AvailabilityFilterEnums) {
      if (availabilitySelectedFilterList.contains(filterType)) {
        return;
      }
      availabilitySelectedFilterList.add(filterType);
    }
    filterData();
  }

  void filterData() {
    List<Map<String, Object>> searchedTextFilteredData = [];
    List<Map<String, Object>> genderFilteredData = [];
    List<Map<String, Object>> domainFilteredData = [];
    List<Map<String, Object>> availabilityFilteredData = [];
    for (var datum in data) {
      final String fname = datum["first_name"] as String;
      final String lname = datum["last_name"] as String;
      final String genderStr = datum["gender"] as String;
      final String domainStr = datum["domain"] as String;
      final bool isAvailable = datum["available"] as bool;
      bool isFnameOrLnameContainsQuery = false;
      if (searchedText.isNotEmpty) {
        isFnameOrLnameContainsQuery =
            fname.contains(searchedText) || lname.contains(searchedText);
      }
      final isDatumOfSelectedGenderFilterType = genderSelectedFilterList
          .contains(genderStr.getGenderFilterEnumfromString);
      final isDatumOfSelectedDomainFilterType = domainSelectedFilterList
          .contains(domainStr.getDomainFilterEnumfromString);

      final isDatumOfSelectedAvailabilityFilterType =
          availabilitySelectedFilterList
              .contains(isAvailable.getAvailbilityEnumFromBool);
      if (isFnameOrLnameContainsQuery) {
        searchedTextFilteredData.add(datum);
      }
      if (isDatumOfSelectedGenderFilterType) {
        genderFilteredData.add(datum);
      }
      if (isDatumOfSelectedDomainFilterType) {
        domainFilteredData.add(datum);
      }
      if (isDatumOfSelectedAvailabilityFilterType) {
        availabilityFilteredData.add(datum);
      }
    }
    removeUncommonData(
      data: searchedText.isEmpty ? data : searchedTextFilteredData,
      genderFilteredData: genderFilteredData,
      domainFilteredData: domainFilteredData,
      availabilityFilteredData: availabilityFilteredData,
    );
  }

  void removeUncommonData({
    required List<Map<String, Object>> data,
    required List<Map<String, Object>> genderFilteredData,
    required List<Map<String, Object>> domainFilteredData,
    required List<Map<String, Object>> availabilityFilteredData,
  }) {
    List<Map<String, Object>> tempData = [];
    tempData.assignAll(data);
    if (genderFilteredData.isNotEmpty &&
        domainFilteredData.isNotEmpty &&
        availabilityFilteredData.isNotEmpty) {
      tempData.removeWhere((element) => !genderFilteredData.contains(element));
      tempData.removeWhere((element) => !domainFilteredData.contains(element));
      tempData.removeWhere(
          (element) => !availabilityFilteredData.contains(element));
    } else if (genderFilteredData.isNotEmpty && domainFilteredData.isNotEmpty) {
      tempData.removeWhere((element) => !genderFilteredData.contains(element));
      tempData.removeWhere((element) => !domainFilteredData.contains(element));
    } else if (genderFilteredData.isNotEmpty &&
        availabilityFilteredData.isNotEmpty) {
      tempData.removeWhere((element) => !genderFilteredData.contains(element));
      tempData.removeWhere(
          (element) => !availabilityFilteredData.contains(element));
    } else if (domainFilteredData.isNotEmpty &&
        availabilityFilteredData.isNotEmpty) {
      tempData.removeWhere((element) => !domainFilteredData.contains(element));
      tempData.removeWhere(
          (element) => !availabilityFilteredData.contains(element));
    } else if (genderFilteredData.isNotEmpty) {
      tempData.removeWhere((element) => !genderFilteredData.contains(element));
    } else if (domainFilteredData.isNotEmpty) {
      tempData.removeWhere((element) => !domainFilteredData.contains(element));
    } else if (availabilityFilteredData.isNotEmpty) {
      tempData.removeWhere(
          (element) => !availabilityFilteredData.contains(element));
    }
    filteredData.assignAll(tempData);
  }

  void setupFilters() {
    final dataBasisSearchedText = searchedText.isEmpty ? data : filteredData;
    genderFilterList.clear();
    domainFilterList.clear();
    availabilityFilterList.clear();
    for (var datum in dataBasisSearchedText) {
      final String genderStr = datum["gender"] as String;
      final String domainStr = datum["domain"] as String;
      if (datum["available"] == true) {
        availabilityFilterList.add(AvailabilityFilterEnums.available);
      } else {
        availabilityFilterList.add(AvailabilityFilterEnums.unavailable);
      }
      genderFilterList.add(genderStr.getGenderFilterEnumfromString);

      domainFilterList.add(domainStr.getDomainFilterEnumfromString);
    }
  }
}
