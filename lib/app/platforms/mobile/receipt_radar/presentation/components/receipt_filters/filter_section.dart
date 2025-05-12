import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/filter_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_filters/filter_choice.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';

class FilterSection extends StatefulWidget {
  final String title;
  final List<FilterModel> filters;
  final bool multipleSelection;
  final bool selectOneMandatory;
  final Function(List<FilterModel>) onSelectionChanged;

  const FilterSection({
    super.key,
    required this.title,
    required this.filters,
    this.multipleSelection = false,
    required this.onSelectionChanged, this.selectOneMandatory = false,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: context.headlineSmall),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.filters.map((filter) {
              return FilterChoice(
                name:
                    '${filter.name} ${filter.ids != null ? '(${filter.ids?.length ?? 0})' : ''}',
                isSelected: filter.isSelected,
                onTap: () {
                  setState(() {
                    if (widget.multipleSelection) {
                      filter.isSelected = !filter.isSelected;
                    } else {
                      for (var f in widget.filters) {
                        if(widget.selectOneMandatory) {
                          f.isSelected = f == filter;
                        } else if(f == filter) {
                          f.isSelected = !f.isSelected;
                        }
                      }
                    }
                  });
                  widget.onSelectionChanged(widget.filters);
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 22)
      ],
    );
  }
}
