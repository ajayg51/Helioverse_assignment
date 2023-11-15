import 'package:flutter/material.dart';

extension SpaceExt on num {
  Widget get horizontalSpace => SizedBox(width: toDouble());

  Widget get verticalSpace => SizedBox(height: toDouble());
}
