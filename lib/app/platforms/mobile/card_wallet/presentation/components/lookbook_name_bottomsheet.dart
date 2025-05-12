import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';

class LookbookNameBottomSheet extends StatefulWidget {
  const LookbookNameBottomSheet({super.key});

  @override
  State<LookbookNameBottomSheet> createState() =>
      _LookbookNameBottomSheetState();
}

class _LookbookNameBottomSheetState extends State<LookbookNameBottomSheet> {
  TextEditingController controller = TextEditingController();

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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Provide Business Name',
                style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 20,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w600),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFEAE4D9),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  size: 18,
                ),
              )
            ],
          ),
          const Divider(
            color: Color(0xFF50555C),
          ),
          const SizedBox(height: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Business name'),
              const SizedBox(height: 5),
              CustomTextField(
                controller: controller,
                edgeInsets: EdgeInsets.zero,
                hintText: 'Add name here',
                showPrefix: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
              height: 46,
              child: HushhLinearGradientButton(
                text: 'Continue',
                onTap: () async {
                  Navigator.pop(context, controller.text);
                },
              ))
        ],
      ),
    );
  }
}
