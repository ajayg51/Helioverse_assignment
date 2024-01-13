import 'package:flutter/material.dart';

class CommonBackground extends StatelessWidget {
  const CommonBackground({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.orange.withOpacity(0.5),
            Colors.teal
          ],
        ),
      ),
      child: child == null
          ? null
          : Row(
              children: [Expanded(child: child!)],
            ),
    );
  }
}
