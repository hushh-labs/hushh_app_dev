import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/hushh_meet_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class HushhMeetAmountBottomSheet extends StatefulWidget {
  const HushhMeetAmountBottomSheet({super.key});

  @override
  State<HushhMeetAmountBottomSheet> createState() =>
      _HushhMeetAmountBottomSheetState();
}

class _HushhMeetAmountBottomSheetState
    extends State<HushhMeetAmountBottomSheet> {
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
                'Collect Payment',
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
              const Text('Amount'),
              const SizedBox(height: 5),
              CustomTextField(
                controller: controller,
                edgeInsets: EdgeInsets.zero,
                textInputType: TextInputType.number,
                hintText: '${sl<HushhMeetBloc>().meeting!.amount}',
                showPrefix: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: HushhLinearGradientButton(
              text: 'Update',
              onTap: () async {
                Navigator.pop(context, controller.text);
              },
            ),
          )
        ],
      ),
    );
  }
}
