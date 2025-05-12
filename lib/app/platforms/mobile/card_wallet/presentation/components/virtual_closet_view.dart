import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VirtualClosetView extends StatelessWidget {
  final bool removeTitle;

  const VirtualClosetView({super.key, this.removeTitle = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: sl<CardWalletPageBloc>(),
        builder: (context, state) {
          final card = sl<CardWalletPageBloc>().cardData;
          UserPreference? virtualClosetPrompt = card?.brandPreferences
              .where((element) =>
                  element.questionType ==
                  CardQuestionType.multiImageUploadQuestion)
              .firstOrNull;
          if (virtualClosetPrompt?.answers.isEmpty ?? true) return const SizedBox();
          return Padding(
            padding: removeTitle
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                if (!removeTitle)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'your virtual closet'.toUpperCase(),
                        style: context.titleSmall?.copyWith(
                          color: const Color(0xFF737373),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                        ),
                      ),
                      const Spacer(),
                      Material(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: InkWell(
                            onTap: () {},
                            child: const Row(
                              children: [
                                Icon(Icons.edit,
                                    size: 12, color: Color(0xFF737373)),
                                SizedBox(width: 1),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                      color: Color(0xFF737373),
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                if (!removeTitle) const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 120,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: virtualClosetPrompt!.answers.length,
                    itemBuilder: (BuildContext context, int idx) {
                      return Center(
                        child: virtualClosetPrompt.answers[idx]
                                        .toString()
                                        .length >
                                    3 &&
                                virtualClosetPrompt.answers[idx]
                                        .toString()
                                        .substring(0, 4)
                                        .toLowerCase() ==
                                    "http"
                            ? Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8
                                  ),
                                  child: CachedNetworkImage(
                                      imageUrl: virtualClosetPrompt.answers[idx]),
                                ),
                              )
                            : Text(
                                virtualClosetPrompt.answers[idx],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 26),
              ],
            ),
          );
        });
  }
}
