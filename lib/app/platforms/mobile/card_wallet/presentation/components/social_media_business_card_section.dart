import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:tuple/tuple.dart';

class SocialMediaBusinessCardSection extends StatefulWidget {
  final CardModel cardData;

  const SocialMediaBusinessCardSection({super.key, required this.cardData});

  @override
  State<SocialMediaBusinessCardSection> createState() =>
      _SocialMediaBusinessCardSectionState();
}

class _SocialMediaBusinessCardSectionState
    extends State<SocialMediaBusinessCardSection> {
  List<Tuple2<String, TextEditingController>> fields = [];
  Timer? _debounce;
  List<String?> websiteIcons = [];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    fields = (List<String>.from(
        widget.cardData.brandPreferences.firstOrNull?.metadata?['answers']['links'] ?? []))
        .map((e) => Tuple2(e, TextEditingController(text: e)))
        .toList();
    websiteIcons =
        fields.map((e) => 'http://www.google.com/s2/favicons?domain=${e.item2
            .text}').toList();
    setState(() {});
    super.initState();
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
            children: [
              Text(
                "Your Business Links",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.black),
              ),
            ],
          ),
          const Text(
              "Explore all the links you've added to enhance your business card."),
          const SizedBox(height: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
                fields.length,
                    (index) =>
                    Padding(
                      padding: EdgeInsets.only(top: index == 0 ? 0 : 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              edgeInsets: EdgeInsets.zero,
                              showPrefix: false,
                              height: 46,
                              controller: fields[index].item2,
                              onChanged: (value) {
                                if (_debounce?.isActive ?? false) {
                                  _debounce?.cancel();
                                }
                                _debounce = Timer(
                                    const Duration(milliseconds: 1200), () {
                                  websiteIcons[index] =
                                  'http://www.google.com/s2/favicons?domain=$value';
                                  setState(() {});
                                  sl<CardWalletPageBloc>().add(
                                      UpdateBusinessCardLinksEvent(
                                          widget.cardData,
                                          fields
                                              .map((e) => e.item2.text)
                                              .toList(),
                                          context));
                                });
                              },
                              trailing: websiteIcons.isEmpty ||
                                  websiteIcons[index] == null
                                  ? null
                                  : Image.network(
                                websiteIcons[index]!,
                                errorBuilder: (context, _, s) =>
                                const SizedBox(),
                              ),
                              hintText: 'Add your link',
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                fields.removeAt(index);
                                websiteIcons.removeAt(index);
                                setState(() {});
                                sl<CardWalletPageBloc>().add(
                                    UpdateBusinessCardLinksEvent(
                                        widget.cardData,
                                        fields
                                            .map((e) => e.item2.text)
                                            .toList(),
                                        context));
                              },
                              icon: const Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.redAccent,
                              ))
                        ],
                      ),
                    )),
          ),
          if (fields.isNotEmpty) const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: () {
                onAdd();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                  foregroundColor: const Color(0xFFE51A5E)),
              child: const Text('Add Link +'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  onAdd() {
    fields.add(Tuple2("", TextEditingController()));
    websiteIcons.add("");
    setState(() {});
  }
}
