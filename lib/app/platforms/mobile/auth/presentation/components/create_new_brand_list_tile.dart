import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/create_new_brand_bottom_sheet.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class CreateNewBrandListTile extends StatelessWidget {
  const CreateNewBrandListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        sl<AgentSignUpPageBloc>().add(FetchBrandCategoriesEvent());
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (BuildContext context) => CreateBrandBottomSheet(),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
            color: const Color(0xFFE51A5E),
            borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            DottedBorder(
              color: Colors.white,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create & Customize Your Brand',
                    style: context.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const Text(
                    'Ready to Make Your Mark? Create and Customize Your Brand Now!',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
