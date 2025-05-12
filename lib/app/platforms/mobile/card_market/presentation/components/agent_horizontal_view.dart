import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentHorizontalView extends StatelessWidget {
  final List<AgentModel> agents;

  const AgentHorizontalView({super.key, required this.agents});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Connect with Agents',
              style: context.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  isDismissible: true,
                  enableDrag: true,
                  backgroundColor: Colors.transparent,
                  constraints: BoxConstraints(maxHeight: 70.h),
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "All Agents",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: agents.length,
                              itemBuilder: (context, index) {
                                final agent = agents[index];
                                return ListTile(
                                  leading: agent.agentImage != null
                                      ? CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(agent.agentImage!),
                                  )
                                      : const CircleAvatar(child: Icon(Icons.person)),
                                  title: Text(agent.agentName ?? 'Unknown'),
                                  subtitle: Text(agent.agentBrand?.brandName ?? ''),
                                  onTap: () {
                                    // Handle list tile tap if needed
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('SEE ALL',
                    style: TextStyle(
                        color: Color(0xFFE51A5E),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFE51A5E))),
              ),
            )
          ],
        ),
        const Text(
          'Explore all our specialized Agents',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                agents.length,
                (index) => Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Container(
                        width: 30.h * 0.667,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.agentProfile,
                                    arguments: agents[index]);
                              },
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: CachedNetworkImageProvider(
                                    agents[index].agentImage ?? ''),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              agents[index].agentName ?? '',
                              style: context.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              agents[index].agentBrand?.brandName ?? '',
                              style: context.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )),
          ),
        ),
        const SizedBox(height: 24)
      ],
    );
  }
}
