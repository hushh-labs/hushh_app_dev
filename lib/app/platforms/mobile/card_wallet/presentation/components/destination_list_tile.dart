import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class DestinationListTile extends StatelessWidget {
  final String departureDestination;
  final String arrivalDestination;

  const DestinationListTile({
    Key? key,
    required this.departureDestination,
    required this.arrivalDestination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: JustTheTooltip(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$departureDestination - $arrivalDestination',
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        triggerMode: TooltipTriggerMode.tap,
        enableFeedback: true,
        child: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              letterSpacing: 0.5,
              color: Colors.black, // Set default text color
            ),
            children: [
              TextSpan(
                text: departureDestination.length > 10
                    ? '${departureDestination.substring(0, 10)}...'
                    : departureDestination,
              ),
              const TextSpan(text: ' - '),
              TextSpan(
                text: arrivalDestination.length > 10
                    ? '${arrivalDestination.substring(0, 10)}...'
                    : arrivalDestination,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
