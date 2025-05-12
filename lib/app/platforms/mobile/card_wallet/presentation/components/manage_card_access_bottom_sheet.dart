import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class ManageCardAccessBottomSheet extends StatefulWidget {
  const ManageCardAccessBottomSheet({super.key});

  @override
  State<ManageCardAccessBottomSheet> createState() =>
      _ManageCardAccessBottomSheetState();
}

class _ManageCardAccessBottomSheetState
    extends State<ManageCardAccessBottomSheet> {
  final controller = sl<CardWalletPageBloc>();

  @override
  void initState() {
    controller.add(FetchAgentsWithAccessToTheCard());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Manage Card Access',
                style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 20,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w600),
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'You can view and manage all the agents who have purchased your card. This section allows you to control access to your data fully.',
            style: TextStyle(color: Color(0xFF4C4C4C)),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          BlocBuilder(
              bloc: controller,
              builder: (context, state) {
                final agents = controller.agentsWithAccess;
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: agents?.length ?? 0,
                    itemBuilder: (context, index) {
                      AgentModel agent = agents![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: agent.agentImage != null
                              ? CachedNetworkImageProvider(agent.agentImage!)
                              : null,
                        ),
                        title: Text(agent.agentName ?? "N/A"),
                        subtitle:
                            Text("${agent.agentBrand!.brandName.trim()}'s Agent"),
                      );
                    },
                  ),
                );
              }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
