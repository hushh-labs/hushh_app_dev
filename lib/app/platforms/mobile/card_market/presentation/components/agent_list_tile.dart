import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class AgentListTile extends StatelessWidget {
  final AgentModel agent;

  const AgentListTile({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: agent.agentImage != null
          ? CircleAvatar(
              radius: 24,
              backgroundImage: CachedNetworkImageProvider(agent.agentImage!),
            )
          : null,
      titleAlignment: ListTileTitleAlignment.titleHeight,
      title: Text(agent.agentName!),
      subtitle: agent.agentDesc != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${agent.agentBrand!.brandName.trim()}'s Agent",
                  style: const TextStyle(color: Color(0xFF637087)),
                ),
                Text(
                  agent.agentDesc!,
                  style: const TextStyle(color: Color(0xFF637087)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )
          : null,
      onTap: () {
        sl<CardWalletPageBloc>().selectedAgent = agent;
        Navigator.pushNamed(context, AppRoutes.agentProfile, arguments: agent);
      },
    );
  }
}
