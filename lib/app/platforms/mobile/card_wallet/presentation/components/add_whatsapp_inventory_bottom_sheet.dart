import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/fields_inventory_bottom_sheet.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddWhatsappInventoryBottomSheet extends StatefulWidget {
  const AddWhatsappInventoryBottomSheet({super.key});

  @override
  State<AddWhatsappInventoryBottomSheet> createState() =>
      _AddWhatsappInventoryBottomSheetState();
}

class _AddWhatsappInventoryBottomSheetState
    extends State<AddWhatsappInventoryBottomSheet> {
  TextEditingController dialCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Please provide the credentials',
                style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 20,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                        color: Color(0xFF4C4C4C), fontFamily: 'Figtree'),
                    children: [
                      TextSpan(
                        text:
                            'Please share your Whatsapp Business phone number to connect your inventory.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 20.w,
                child: Divider(
                  color: const Color(0xFF50555C).withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                edgeInsets: EdgeInsets.zero,
                controller: phoneController,
                hintText: 'eg +919999999999',
                showPrefix: false,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 46,
                child: BlocBuilder(
                    bloc: sl<InventoryBloc>(),
                    builder: (context, state) {
                      return HushhLinearGradientButton(
                        text: 'Add',
                        enabled: state is! InsertingInventoryConfigurationState,
                        loader: state is InsertingInventoryConfigurationState,
                        radius: 12,
                        onTap: () async {
                          sl<InventoryBloc>().add(ProcessWhatsAppInventoryEvent(
                            dialCodeController.text,
                            phoneController.text,
                            context
                          ));
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
