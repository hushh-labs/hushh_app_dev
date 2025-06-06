// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/core/hushh_story_editor/src/domain/models/editable_items.dart';
import 'package:hushh_app/app/shared/core/hushh_story_editor/src/presentation/utils/constants/item_type.dart';

class DeleteItem extends StatelessWidget {
  const DeleteItem({
    super.key,
    required EditableItem? activeItem,
    required this.isDeletePosition,
    required this.animationsDuration,
  }) : _activeItem = activeItem;

  final EditableItem? _activeItem;
  final bool isDeletePosition;
  final Duration animationsDuration;

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);

    return Visibility(
      visible: _activeItem != null && _activeItem!.type != ItemType.image,
      child: Positioned(
          bottom: 130,
          child: SizedBox(
            width: _mediaQuery.size.width,
            child: Center(
              child: AnimatedContainer(
                alignment: Alignment.center,
                duration: animationsDuration,
                height: isDeletePosition ? 55.0 : 45,
                width: isDeletePosition ? 55.0 : 45,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const ImageIcon(
                  AssetImage('assets/hushh_story_assets/icons/trash.png'),
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          )),
    );
  }
}
