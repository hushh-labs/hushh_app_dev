import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_filters/filters_bottom_sheet.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:page_transition/page_transition.dart';

class ReceiptRadarTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FiltersPageType filtersPageType;
  final bool showFilter;

  const ReceiptRadarTextField(
      {super.key,
      this.controller,
      this.onChanged,
      this.showFilter = true,
      required this.filtersPageType});

  @override
  State<ReceiptRadarTextField> createState() => _ReceiptRadarTextFieldState();
}

class _ReceiptRadarTextFieldState extends State<ReceiptRadarTextField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB3B3B3)),
        borderRadius: BorderRadius.circular(1.0),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.search,
              color: Color(0xFFB3B3B3),
            ),
          ),
          Flexible(
            child: TextField(
              controller: widget.controller,
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 800), () {
                  widget.onChanged?.call(value);
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
                hintText: 'Search brand receipts',
                contentPadding: EdgeInsets.only(left: 16.0),
              ),
            ),
          ),
          if (widget.showFilter)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                  onTap: () {
                    sl<ReceiptRadarBloc>().add(ResetFiltersEvent());
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: FiltersBottomSheet(
                              filtersPageType: widget.filtersPageType,
                            )));
                  },
                  child: SvgPicture.asset('assets/filter.svg')),
            )
        ],
      ),
    );
  }
}
