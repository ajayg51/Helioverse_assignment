import 'package:emp_data/data/dummy_data.dart';
import 'package:emp_data/models/team.dart';
import 'package:emp_data/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class TeamInfoScreenController extends GetxController {
  late Box<Team> boxTeam;
  final data = DummyData.empData;
  List<Map<String, Object>> teamMemberAllList = [];
  RxList<Map<String, Object>> teamMemberList = <Map<String, Object>>[].obs;

  int offset = 1;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    boxTeam = Hive.box("team");
    final boxTeamValueList = boxTeam.values.toList();

    scrollController.addListener(scrollControllerMethod);
    for (var teamMember in boxTeamValueList) {
      teamMemberAllList.addAll(
          data.where((element) => element["id"].toString() == teamMember.id));
    }
    teamMemberList.addAll(teamMemberAllList.take(15));
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(scrollControllerMethod);
  }

  void scrollControllerMethod() {
    scrollController.position.isScrollingNotifier.addListener(() {
      if (!scrollController.position.isScrollingNotifier.value) {
        MyAppToast.showAppToast("No more data");
        return;
      }
    });
    if (scrollController.position.maxScrollExtent < offset * 1000) {
      final count = offset == 1 ? 15 : 10;
      teamMemberList.addAll(teamMemberAllList.skip(offset * count).take(10));
      offset++;
    }
  }
}
