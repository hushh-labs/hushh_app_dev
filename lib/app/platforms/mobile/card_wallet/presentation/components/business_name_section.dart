import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class BusinessNameSection extends StatefulWidget {
  final CardModel cardData;
  final Function(String) onChange;

  const BusinessNameSection(
      {super.key, required this.cardData, required this.onChange});

  @override
  State<BusinessNameSection> createState() => _BusinessNameSectionState();
}

class _BusinessNameSectionState extends State<BusinessNameSection> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Business Name",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.black),
                      ),
                    ],
                  ),
                  Text("provide the name of your business"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            height: 50,
            edgeInsets: EdgeInsets.zero,
            showPrefix: false,
            trailing: const Icon(Icons.edit_outlined, size: 14,),
            controller: TextEditingController(
                text: widget.cardData.brandPreferences.firstOrNull?.metadata?['answers']
                    ['business_name']),
            hintText: 'Business name',
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 800), () {
                sl<CardWalletPageBloc>()
                    .add(UpdateBusinessCardNameEvent(widget.cardData, value, context));
                widget.onChange(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
