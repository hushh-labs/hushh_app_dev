// ignore_for_file: unrelated_type_equality_checks, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hushh_app/app/shared/core/hushh_story_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:hushh_app/app/shared/core/hushh_story_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:hushh_app/app/shared/core/hushh_story_editor/src/presentation/utils/constants/font_family.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    FocusNode _textNode = FocusNode();
    return Consumer2<TextEditingNotifier, ControlNotifier>(
      builder: (context, editorNotifier, controlNotifier, child) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _size.width - 100,
            ),
            child: IntrinsicWidth(

                /// textField Box decoration
                child: Stack(
              alignment: Alignment.center,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 2),
                //   child: _text(
                //     editorNotifier: editorNotifier,
                //     textNode: _textNode,
                //     controlNotifier: controlNotifier,
                //     paintingStyle: PaintingStyle.fill,
                //   ),
                // ),
                _textField(
                  editorNotifier: editorNotifier,
                  textNode: _textNode,
                  controlNotifier: controlNotifier,
                  paintingStyle: PaintingStyle.fill,
                )
              ],
            )),
          ),
        );
      },
    );
  }

  // Widget _text({
  //   required TextEditingNotifier editorNotifier,
  //   required FocusNode textNode,
  //   required ControlNotifier controlNotifier,
  //   required PaintingStyle paintingStyle,
  // }) {
  //   return Text(
  //     editorNotifier.textController.text,
  //     textAlign: editorNotifier.textAlign,
  //     style: TextStyle(
  //       fontFamily: controlNotifier.fontList![editorNotifier.fontFamilyIndex],
  //       shadows: <Shadow>[
  //         Shadow(
  //             offset: const Offset(1.0, 1.0),
  //             blurRadius: 3.0,
  //             color: editorNotifier.textColor == Colors.black
  //                 ? Colors.white54
  //                 : Colors.black)
  //       ],
  //     ).copyWith(
  //         color: controlNotifier.colorList![editorNotifier.textColor],
  //         fontSize: editorNotifier.textSize,
  //         background: Paint()
  //           ..strokeWidth = 20.0
  //           ..color = editorNotifier.backGroundColor
  //           ..style = paintingStyle
  //           ..strokeJoin = StrokeJoin.round
  //           ..filterQuality = FilterQuality.high
  //           ..strokeCap = StrokeCap.round
  //           ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1)),
  //   );
  // }

  Widget _textField({
    required TextEditingNotifier editorNotifier,
    required FocusNode textNode,
    required ControlNotifier controlNotifier,
    required PaintingStyle paintingStyle,
  }) {
    return TextField(
      focusNode: textNode,
      autofocus: true,
      textInputAction: TextInputAction.newline,
      controller: editorNotifier.textController,
      textAlign: editorNotifier.textAlign,
      style: AppFonts.getTextThemeENUM(
              controlNotifier.fontList![editorNotifier.fontFamilyIndex])
          .bodyLarge!
          .merge(
            TextStyle(
              // fontFamily:
              //     controlNotifier.fontList![editorNotifier.fontFamilyIndex],
              // package:
              //     controlNotifier.isCustomFontList ? null : 'vs_story_designer',
              shadows: !controlNotifier.enableTextShadow
                  ? []
                  : <Shadow>[
                      Shadow(
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: editorNotifier.textColor == Colors.black
                              ? Colors.white54
                              : Colors.black)
                    ],
              backgroundColor: Colors.redAccent,
            ),
          )
          .copyWith(
        color: controlNotifier.colorList![editorNotifier.textColor],
        fontSize: editorNotifier.textSize,
        background: Paint()
          ..strokeWidth = 20.0
          ..color = editorNotifier.backGroundColor
          ..style = paintingStyle
          ..strokeJoin = StrokeJoin.round
          ..filterQuality = FilterQuality.high
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1),
        shadows: <Shadow>[
          Shadow(
              offset: const Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: editorNotifier.textColor == Colors.black
                  ? Colors.white54
                  : Colors.black)
        ],
      ),
      cursorColor: controlNotifier.colorList![editorNotifier.textColor],
      minLines: 1,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: null,
      onChanged: (value) {
        editorNotifier.text = value;
      },
    );
  }
}
