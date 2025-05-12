import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/chrome_extension_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/settings.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BrowsingBehaviorWidget extends StatelessWidget {
  const BrowsingBehaviorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final section = !AppLocalStorage.user!.isHushhExtensionUser
        ? SectionItem(
            label: 'Connect to chrome extension',
            onTap: () => showModalBottomSheet(
              backgroundColor: Colors.white,
              constraints: BoxConstraints(maxHeight: 70.h),
              context: context,
              isDismissible: true,
              builder: (context) => ChromeExtensionBottomSheet(
                onScanned: (_) {},
              ),
            ),
          )
        : SectionItem(
            label: 'View your Browsing Analytics',
            onTap: () => Navigator.pushNamed(
                context, AppRoutes.browsingAnalytics,
                arguments: AppLocalStorage.hushhId),
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 16),
      child: InkWell(
        onTap: section.onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            // border: Border.all(color: const Color(0xFF737373)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(section.label),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right_sharp),
            ],
          ),
        ),
      ),
    );
  }
}
