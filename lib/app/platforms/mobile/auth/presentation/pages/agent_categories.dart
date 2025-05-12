import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class AgentCategories extends StatelessWidget {
  const AgentCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 56,
          child: HushhLinearGradientButton(
            text: 'Continue',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CategoriesView(),
      ),
    );
  }
}

class CategoriesView extends StatefulWidget {
  final bool hideSearch;
  final Function()? onUpdated;
  const CategoriesView({super.key, this.hideSearch = false, this.onUpdated});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final controller = sl<AgentSignUpPageBloc>();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(!widget.hideSearch)
                CustomTextField(
                  controller: textController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                if (controller.suggestedCategorySections != null &&
                    controller.suggestedCategorySections!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Suggested',
                        style: context.titleLarge,
                      ),
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 2.0,
                        children: List.generate(
                          controller.suggestedCategorySections!.length,
                              (index) {
                            final category = controller
                                .suggestedCategorySections![index];
                            return CustomChip(
                              label: category.name,
                              isEnabled: controller.selectedCategories
                                  .contains(category),
                              onTap: () {
                                if (controller.selectedCategories
                                    .contains(category)) {
                                  controller.selectedCategories
                                      .remove(category);
                                } else {
                                  controller.selectedCategories
                                      .add(category);
                                }
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.allCategorySections.length,
                  itemBuilder: (context, sectionIndex) {
                    final sectionName = controller.allCategorySections.keys
                        .elementAt(sectionIndex);
                    if(controller
                        .allCategorySections[sectionName]!.any((element) => element.name.toLowerCase().contains(textController.text.toLowerCase()))) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            sectionName,
                            style: context.titleLarge,
                          ),
                          Wrap(
                            spacing: 4.0,
                            runSpacing: 2.0,
                            children: List.generate(
                              controller
                                  .allCategorySections[sectionName]!.length,
                                  (index) {
                                final category = controller
                                    .allCategorySections[sectionName]![index];
                                if (textController.text.trim().isEmpty) {
                                  return CustomChip(
                                    label: category.name,
                                    isEnabled: controller.selectedCategories
                                        .contains(category),
                                    onTap: () {
                                      controller.emit(SelectingCategoryState());
                                      if (controller.selectedCategories
                                          .contains(category)) {
                                        controller.selectedCategories
                                            .remove(category);
                                      } else {
                                        controller.selectedCategories
                                            .add(category);
                                      }
                                      controller.emit(CategorySelectedState());
                                      setState(() {});
                                    },
                                  );
                                } else if (textController.text
                                    .trim()
                                    .isNotEmpty &&
                                    category.name.toLowerCase().contains(
                                        textController.text.toLowerCase())) {
                                  return CustomChip(
                                    label: category.name,
                                    isEnabled: controller.selectedCategories
                                        .contains(category),
                                    onTap: () {
                                      controller.emit(SelectingCategoryState());
                                      if (controller.selectedCategories
                                          .contains(category)) {
                                        controller.selectedCategories
                                            .remove(category);
                                      } else {
                                        controller.selectedCategories
                                            .add(category);
                                      }
                                      controller.emit(CategorySelectedState());
                                      setState(() {});
                                    },
                                  );
                                } else {
                                  return const SizedBox();
                                }
                                // final category = controller
                                //     .allCategorySections[sectionName]![index];
                                // return CustomChip(
                                //   label: category.name,
                                //   isEnabled: controller.selectedCategories
                                //       .contains(category),
                                //   onTap: () {
                                //     if (controller.selectedCategories
                                //         .contains(category)) {
                                //       controller.selectedCategories
                                //           .remove(category);
                                //     } else {
                                //       controller.selectedCategories
                                //           .add(category);
                                //     }
                                //     setState(() {});
                                //   },
                                // );
                              },
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ],
            ),
          );
        });
  }
}


class CustomChip extends StatelessWidget {
  final String label;
  final Function() onTap;
  final bool isEnabled;

  const CustomChip(
      {super.key,
      required this.label,
      required this.onTap,
      required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: isEnabled ? Colors.black : null,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: isEnabled
              ? const BorderSide(color: Colors.black)
              : const BorderSide(color: Color(0xFFA2A09D))),
      label: Text(
        label,
        style: TextStyle(
            color: isEnabled ? Colors.white : const Color(0xFFA2A09D)),
      ),
      onPressed: onTap,
    );
  }
}
