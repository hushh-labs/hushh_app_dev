import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReceiptsFetchingBanner extends StatelessWidget {
  final int? count;

  const ReceiptsFetchingBanner({super.key, this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Row(
          children: [
            Lottie.asset('assets/receipt_radar_scan.json', width: 100),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fetching your receipts...',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Text(
                    count == 0
                        ? 'We are analysing your receipts and will notify once the process is completed.'
                        : "We've identified $count receipts & we are analyzing, organizing them for you.",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
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
