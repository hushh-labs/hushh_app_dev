import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentPaymentRequestSentBottomSheet extends StatefulWidget {
  final String currency;
  final double amount;
  final String pId;

  const AgentPaymentRequestSentBottomSheet(
      {super.key,
      required this.currency,
      required this.amount,
      required this.pId});

  @override
  _AgentPaymentRequestSentBottomSheetState createState() =>
      _AgentPaymentRequestSentBottomSheetState();
}

class _AgentPaymentRequestSentBottomSheetState
    extends State<AgentPaymentRequestSentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      height: 60.h,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/receipt_bg_image.png'),
          fit: BoxFit.fitHeight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Column(
            children: [
              const SizedBox(height: 16),
              Text(
                "Payment Request Sent!",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Your payment request has been successfully shared.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(5),
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
                // child: CustomQrCodeWidget(
                //     data:
                //         "https://hushhapp.com/?uid=${AppLocalStorage.hushhId}&data=${brand.id}"),
                child: PrettyQrView.data(
                    data:
                        "https://hushhapp.com?pid=${widget.pId}",
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(
                          roundFactor: 1,
                          color: PrettyQrBrush.gradient(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.black, Colors.black],
                            ),
                          )),
                    )),
              ),
              const SizedBox(height: 8),
              Text(
                "Total Payment",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${widget.currency} ${widget.amount.toCommaSeparatedString()}",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildPaymentDetailRow("Ref Number", "000085752257"),
              _buildPaymentDetailRow("Request Time",
                  DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())),
              _buildPaymentDetailRow(
                  "Agent Name", AppLocalStorage.agent?.agentName?? 'N/A'),
            ],
          ),
          // const SizedBox(height: 32),
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.white,
          //     elevation: 0,
          //   ),
          //   child: Text(
          //     "Get PDF Receipt",
          //     style: TextStyle(fontSize: 16.sp, color: Colors.black),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
