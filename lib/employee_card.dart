import 'package:emp_data/models/team.dart';
import 'package:emp_data/utils/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class EmployeeCard extends StatefulWidget {
  const EmployeeCard({
    super.key,
    required this.data,
    this.addedToTeamDataSet,
    this.employeeAlreadyInTeamList,
    this.isShowCheckbox,
    this.onEmployeeSelect,
  });
  final Map<String, Object> data;
  final Set<Map<String, Object>>? addedToTeamDataSet;
  final bool? isShowCheckbox;
  final Function(bool?)? onEmployeeSelect;
  final List<Team>? employeeAlreadyInTeamList;
  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  bool isHovered = false;
  bool isCheckboxTapped = false;
  @override
  Widget build(BuildContext context) {
    final isEmployeeAlreadyInTeam = widget.addedToTeamDataSet != null &&
        widget.addedToTeamDataSet!
            .where((element) => element["domain"] == widget.data["domain"])
            .isNotEmpty;
    final isCurrentEmployeeAlreadyTaken =
        widget.employeeAlreadyInTeamList != null &&
            widget.employeeAlreadyInTeamList!
                .where((element) =>
                    element.id == widget.data["id"].toString() &&
                    element.domain == widget.data["domain"])
                .isNotEmpty;
    return MouseRegion(
      onEnter: (details) => setState(() {
        isHovered = true;
      }),
      onExit: (details) => setState(() {
        isHovered = false;
      }),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink.withOpacity(0.2),
                Colors.black.withOpacity(0.1),
                Colors.teal.withOpacity(0.4),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topLeft,
            ),
          ),
          child: Stack(
            children: [
              FadeInImage.memoryNetwork(
                width: 300,
                height: 400,
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: widget.data["avatar"] as String,
                imageErrorBuilder: (_, __, ___) => const Center(
                  child: Text("Failed to load image"),
                ),
              ),
              if (widget.isShowCheckbox == true &&
                  widget.data["available"] == true) ...[
                Positioned(
                  right: 0,
                  child: Checkbox(
                    hoverColor: Colors.transparent,
                    activeColor: Colors.black,
                    value: isCheckboxTapped || isCurrentEmployeeAlreadyTaken,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          if (isEmployeeAlreadyInTeam ||
                              widget.employeeAlreadyInTeamList != null &&
                                  widget.employeeAlreadyInTeamList!
                                      .where((element) =>
                                          element.domain ==
                                          widget.data["domain"].toString())
                                      .isNotEmpty) return;
                          isCheckboxTapped = true;
                        } else {
                          isCheckboxTapped = false;
                        }
                      });
                      widget.onEmployeeSelect?.call(value);
                    },
                  ),
                ),
              ],
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(10),
                  color: isHovered
                      ? Colors.black87.withOpacity(0.7)
                      : Colors.black87.withOpacity(0.3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.data["first_name"] as String} ${widget.data["last_name"] as String}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                            10.verticalSpace,
                            Text(
                              widget.data["domain"] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                            10.verticalSpace,
                            Text(
                              "Email ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      5.horizontalSpace,
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.data["gender"] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                            10.verticalSpace,
                            if (widget.data["available"] == true) ...[
                              Text(
                                "Available",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ] else ...[
                              Text(
                                "Unavailable",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                            10.verticalSpace,
                            Text(
                              widget.data["email"] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
