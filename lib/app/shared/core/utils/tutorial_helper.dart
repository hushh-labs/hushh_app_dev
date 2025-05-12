import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialHelper {
  static final TutorialHelper _instance = TutorialHelper._internal();
  late TutorialCoachMark _tutorialCoachMark;
  final List<_TutorialTarget> _targets = [];
  bool _hasRun = false;

  bool get isStarted => _hasRun;

  TutorialHelper._internal();

  factory TutorialHelper() {
    return _instance;
  }

  /// Adds a target to the global list
  void addTarget({
    required GlobalKey key,
    required String identifier,
    required List<Widget> contents,
    required int priority, // Priority for sorting and order
    ShapeLightFocus shape = ShapeLightFocus.RRect,
    double radius = 5,
    Color color = Colors.black,
    Alignment alignSkip = Alignment.topRight,
    bool enableOverlayTab = true,
  }) {
    if(!_targets.any((element) => element.priority == priority)) {
      _targets.add(
      _TutorialTarget(
        priority: priority,
        key: key,
        target: TargetFocus(
          identify: identifier,
          keyTarget: key,
          shape: shape,
          radius: radius,
          color: color,
          alignSkip: alignSkip,
          enableOverlayTab: enableOverlayTab,
          contents: contents
              .map(
                (content) => TargetContent(
              align: ContentAlign.bottom,
              child: content,
            ),
          )
              .toList(),
        ),
      ),
    );
    }
    _targets.sort((a, b) => a.priority.compareTo(b.priority)); // Sort by priority
  }

  /// Starts the tutorial (only once)
  void startTutorial(BuildContext context, {ScrollController? scrollController}) {

    print(":_targets:${_targets.map((e) => e.key).toList()}");
    if (_hasRun || _targets.isEmpty) return;
    _hasRun = true;

    _tutorialCoachMark = TutorialCoachMark(
      targets: _targets.map((t) => t.target).toList(), // Extract sorted targets
      colorShadow: Colors.black,
      textSkip: "SKIP",
      opacityShadow: 0.8,
      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      onFinish: () {
        _hasRun = true;
        debugPrint("Tutorial finished");
        AppLocalStorage.tutorialWatched();
      },
      onSkip: () {
        _hasRun = true;
        debugPrint("Tutorial skipped");
        AppLocalStorage.tutorialWatched();
        return true;
      },

      pulseEnable: false,
      onClickOverlay: (target) async {
        if (scrollController != null) {
          await _scrollToTarget(target, scrollController);
        }
      },
    );

    _tutorialCoachMark.show(context: context);
  }

  /// Auto-scroll to the target widget
  Future<void> _scrollToTarget(TargetFocus target, ScrollController controller) async {
    final RenderBox renderBox = target.keyTarget!.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero).dy + controller.offset;
    // Scroll to bring the widget into view
    await controller.animateTo(
      offset + 50, // Adjust offset to avoid cutting off widget
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

/// Internal class to store targets with priority
class _TutorialTarget {
  final int priority;
  final GlobalKey key;
  final TargetFocus target;

  _TutorialTarget({
    required this.priority,
    required this.key,
    required this.target,
  });
}


extension TutorialTargetExtension on Widget {
  Widget withTutorial({
    required BuildContext context,
    required List<Widget> contents,
    required int priority, // Priority used as identifier and for order
    GlobalKey? gkey,
    ShapeLightFocus shape = ShapeLightFocus.RRect,
    double radius = 5,
    Color color = Colors.black,
    Alignment alignSkip = Alignment.topRight,
    bool enableOverlayTab = true,
    Function? onTargetClick,
  }) {
    // Create a GlobalKey using the priority as a unique identifier
    GlobalKey key = gkey ?? GlobalKey(debugLabel: "tutorial_target_$priority");

    // Register this widget as a tutorial target
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TutorialHelper().addTarget(
        key: key,
        identifier: "tutorial_target_$priority",
        // Auto-generated identifier
        contents: contents,
        priority: priority,
        // Priority determines both order and uniqueness
        shape: shape,
        radius: radius,
        color: color,
        alignSkip: alignSkip,
        enableOverlayTab: enableOverlayTab,
      );
    });

    // Wrap the widget with a `RepaintBoundary` and use the generated GlobalKey
    return GestureDetector(
      key: key,
      onTap: () {
        if (onTargetClick != null) {
          onTargetClick();
        }
      },
      child: this, // The original widget
    );
  }
}
