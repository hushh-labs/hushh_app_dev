import 'package:auto_size_text/auto_size_text.dart';
import 'package:hushh_app/currency_converter/currency.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';

class AgentUpdateBidValueBottomSheet extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double currentValue;
  final Currency currency;

  const AgentUpdateBidValueBottomSheet({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.currentValue, required this.currency,
  });

  @override
  _AgentUpdateBidValueBottomSheetState createState() =>
      _AgentUpdateBidValueBottomSheetState();
}

class _AgentUpdateBidValueBottomSheetState
    extends State<AgentUpdateBidValueBottomSheet> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          const AutoSizeText(
            'Update the Hushh discount',
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'Figtree',
              fontSize: 20,
              letterSpacing: -0.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: Color(0xFF4C4C4C),
                  fontFamily: 'Figtree',
                ),
                children: [
                  TextSpan(
                    text:
                    'This provides customers with an incentive to share their information with the brand.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.currency.shorten()}${_currentValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Slider(
                    value: _currentValue,
                    min: widget.minValue,
                    max: widget.maxValue,
                    divisions: (widget.maxValue - widget.minValue).toInt(),
                    activeColor: Colors.black,
                    inactiveColor: Colors.grey,
                    thumbColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        _currentValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          HushhLinearGradientButton(
            text: 'Update discount',
            height: 46,
            color: Colors.black,
            trailing: true,
            radius: 6,
            onTap: () {
              Navigator.pop(context, _currentValue);
            },
          ),
        ],
      ),
    );
  }
}
