import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/ai_chat.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/payment_methods.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class PaymentMessage extends StatefulWidget {
  final PaymentModel payment;
  final String hushhId;
  final DateTime dateTime;
  final bool isMyMessage;
  final int? agentBrandId;
  final Function(String) onPaymentMade;
  final Function() onPaymentDeclined;

  const PaymentMessage({
    Key? key,
    required this.payment,
    required this.hushhId,
    required this.dateTime,
    required this.onPaymentMade,
    required this.onPaymentDeclined,
    required this.isMyMessage,
    this.agentBrandId,
  }) : super(key: key);

  @override
  State<PaymentMessage> createState() => _PaymentMessageState();
}

class _PaymentMessageState extends State<PaymentMessage> {
  bool get isSender =>
      widget.payment.initiatedUuid == widget.hushhId ||
      widget.payment.initiatedBrandId == widget.agentBrandId;

  bool get isMyMessage => widget.isMyMessage;

  String get status => {
        PaymentStatus.pending: 'Pending',
        PaymentStatus.accepted: 'Received',
        PaymentStatus.declined: 'Declined',
      }[widget.payment.status]
          .toString();

  IconData get iconData => {
        PaymentStatus.pending: Icons.error_outline,
        PaymentStatus.accepted: Icons.check,
        PaymentStatus.declined: Icons.cancel_outlined,
      }[widget.payment.status] as IconData;

  Color get iconColor => {
        PaymentStatus.pending: Colors.orange,
        PaymentStatus.accepted: Colors.green,
        PaymentStatus.declined: Colors.red,
      }[widget.payment.status] as Color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 6,
        right: isSender ? 0 : 10,
        top: 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment request: ${widget.payment.title}",
            style: TextStyle(color: isSender ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            "${Utils().getCurrencyFromCurrencySymbol(widget.payment.currency)!.shorten()} ${widget.payment.amountRaised}",
            style: context.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSender ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                iconData,
                color: iconColor,
                size: 16,
              ),
              Text(
                ' ● $status ● ',
                style: context.bodySmall
                    ?.copyWith(color: isSender ? Colors.white : Colors.black),
              ),
              Text(DateFormat('MMM dd').format(widget.dateTime),
                  style: context.bodySmall?.copyWith(
                      color: isSender ? Colors.white : Colors.black)),
            ],
          ),
          if (widget.payment.status == PaymentStatus.pending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        padding: EdgeInsets.zero),
                    onPressed: widget.onPaymentDeclined,
                    child: Text(
                      'Decline',
                      style: context.bodySmall,
                    ),
                  ),
                ),
                if (!isSender) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.withOpacity(0.8),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero),
                      onPressed: () {
                        makePayment(context);
                      },
                      child: const Text('Pay'),
                    ),
                  ),
                ]
              ],
            )
          ]
        ],
      ),
    );
  }

  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(context) async {
    try {
      Navigator.pushNamed(context, AppRoutes.shared.paymentMethodsViewer,
          arguments: PaymentMethodsArgs(
            amount: widget.payment.amountRaised,
            currency: Utils().getCurrencyFromCurrencySymbol(widget.payment.currency)!,
            description: "Payment request",
            onPaymentDone: () async {
              widget.onPaymentMade(
                  widget.payment.amountRaised.toStringAsFixed(0));
            },
            onPaymentFailed: () {
              ToastManager(Toast(
                      title: 'Transaction failed!',
                      type: ToastificationType.error))
                  .show(context);
            },
          ));
    } catch (err) {
      throw Exception(err);
    }
  }
}
