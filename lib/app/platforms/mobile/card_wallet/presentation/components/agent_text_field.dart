import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_task_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class AgentTextField extends StatefulWidget {
  final String? title;
  final TextEditingController controller;
  final String hintText;
  final CustomFormType fieldType;
  final int? maxLines;
  final Function()? onTap;
  final Function(String)? onChanged;
  final bool isAuthTextField;
  final TextInputType? textInputType;
  final bool addBelowPadding;
  final FocusNode? focusNode;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? trailing;

  const AgentTextField({
    super.key,
    this.title,
    required this.controller,
    required this.hintText,
    required this.fieldType,
    this.maxLines,
    this.onTap,
    this.isAuthTextField = false,
    this.onChanged,
    this.textInputType,
    this.addBelowPadding = true,
    this.focusNode,
    this.maxLength,
    this.inputFormatters,
    this.trailing,
  });

  @override
  State<AgentTextField> createState() => _AgentTextFieldState();
}

class _AgentTextFieldState extends State<AgentTextField> {
  final controller = sl<AgentTaskBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: controller,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null) ...[
              Text(widget.title!),
              const SizedBox(height: 8)
            ],
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: widget.isAuthTextField
                    ? Border.all(color: const Color(0xFFD6D6D6))
                    : null,
                color: widget.isAuthTextField ? null : const Color(0xFFE8EDF5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  if (widget.fieldType == CustomFormType.web) ...[
                    Center(
                        child: Text('https://',
                            style: TextStyle(
                                color:
                                    const Color(0xFF4A789C).withOpacity(0.7)))),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: TextField(
                        keyboardType: widget.textInputType,
                        focusNode: widget.focusNode,
                        onChanged: widget.onChanged,
                        maxLines: widget.maxLines,
                        maxLength: widget.maxLength,
                        inputFormatters: widget.inputFormatters,
                        controller: widget.controller,
                        readOnly: widget.fieldType != CustomFormType.text && widget.fieldType != CustomFormType.web
                            ? true
                            : false,
                        onTap: () {
                          widget.fieldType == CustomFormType.date
                              ? controller.add(SelectDateAndTimeEvent(context))
                              : widget.fieldType == CustomFormType.filter
                                  ? controller.add(UpdateTaskTypeEvent(context))
                                  : widget.onTap?.call();
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                                color: widget.isAuthTextField
                                    ? null
                                    : const Color(0xFF4A789C)
                                        .withOpacity(0.7))),
                      ),
                    ),
                  ),
                  getTrailingWidget(),
                  const SizedBox(width: 12)
                ],
              ),
            ),
            if (widget.addBelowPadding) const SizedBox(height: 24)
          ],
        );
      },
    );
  }

  Widget getTrailingWidget() {
    if(widget.trailing != null) return widget.trailing!;
    switch (widget.fieldType) {
      case CustomFormType.text:
        return const SizedBox();
      case CustomFormType.date:
        return Image.asset(
          "assets/meeting_icon.png",
          color: const Color(0xFF4A789C),
          width: 20,
        );
      case CustomFormType.list:
        return const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A789C));
      case CustomFormType.dateTime:
        return const Icon(Icons.calendar_month_outlined,
            color: Color(0xFF4A789C));
      case CustomFormType.duration:
        return const Icon(Icons.timelapse_outlined, color: Color(0xFF4A789C));
      case CustomFormType.web:
        return const Icon(Icons.web, color: Color(0xFF4A789C));
      case CustomFormType.filter:
        return const Icon(
          Icons.filter_alt_outlined,
          color: Color(0xFF4A789C),
          size: 20,
        );
    }
  }
}
