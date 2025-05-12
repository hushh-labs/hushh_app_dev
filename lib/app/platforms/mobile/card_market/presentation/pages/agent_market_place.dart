import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/agent_list_tile.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_sign_up_list_view.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentMarketPlace extends StatefulWidget {
  const AgentMarketPlace({super.key});

  @override
  State<AgentMarketPlace> createState() => _AgentMarketPlaceState();
}

class _AgentMarketPlaceState extends State<AgentMarketPlace> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  final controller = sl<CardMarketBloc>();
  CardModel? selectedCard;

  @override
  void initState() {
    if (controller.brandCardData?.isEmpty ?? true) {
      controller.add(FetchCardMarketEvent());
    }
    controller.add(FetchAgentsEvent());
    super.initState();
  }

  List<AgentModel> get filteredAgents => selectedCard == null
      ? controller.agents ?? []
      : (controller.agents ?? [])
          .where((element) => element.agentCard?.id == selectedCard!.id)
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connect with our Agents")),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: BlocBuilder(
            bloc: controller,
            builder: (context, state) {
              return IgnorePointer(
                ignoring: controller.brandCardData?.isEmpty ?? true,
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (controller.brandCardData?.isEmpty ?? true)
                            ? Colors.grey
                            : null,
                        gradient: (controller.brandCardData?.isEmpty ?? true)
                            ? null
                            : const LinearGradient(colors: [
                                Color(0xFFE54D60),
                                Color(0xFFA342FF),
                              ])),
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (!(controller.brandCardData?.isEmpty ?? true)) {
                      selectedCard = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          constraints: BoxConstraints(maxHeight: 80.h),
                          builder: (context) => BlocBuilder(
                              bloc: controller,
                              builder: (context, state) {
                                return BrandSignUpListView(
                                  brands: (controller.featuredCard ?? []) +
                                      (controller.brandCardData ?? []),
                                );
                              }));
                      setState(() {});
                    }
                  },
                ),
              );
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CustomTextField(
              hintText: 'Search for agents',
              onChanged: (value) {
                controller.add(SearchAgentsEvent(value));
              },
            ),
            if (selectedCard != null) ...[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    label: Text(selectedCard!.brandName),
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 18,
                    ),
                    onDeleted: () {
                      selectedCard = null;
                      setState(() {});
                    },
                  )),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: BlocBuilder(
                  bloc: controller,
                  builder: (context, state) {
                    if (controller.agents != null) {
                      return ListView.builder(
                        itemCount: filteredAgents.length,
                        itemBuilder: (context, index) {
                          return AgentListTile(agent: filteredAgents[index]);
                        },
                      );
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
