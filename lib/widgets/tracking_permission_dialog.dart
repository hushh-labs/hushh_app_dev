// widgets/tracking_permission_dialog.dart
import 'package:flutter/material.dart';
import '../services/tracking_service.dart';

class TrackingPermissionDialog extends StatelessWidget {
  final VoidCallback? onAuthorized;
  final VoidCallback? onDenied;

  const TrackingPermissionDialog({
    Key? key,
    this.onAuthorized,
    this.onDenied,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personalized Experience'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hushh would like to provide you with a personalized experience.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'This helps us:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('• Show you relevant offers and content'),
          Text('• Improve our services based on your preferences'),
          Text('• Provide a better user experience'),
          SizedBox(height: 16),
          Text(
            'Your privacy is important to us. We never share your data with third parties without your consent.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final status = await TrackingService.requestTrackingAuthorization();
            if (status == TrackingStatus.authorized) {
              onAuthorized?.call();
            } else {
              onDenied?.call();
            }
          },
          child: const Text('Continue'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDenied?.call();
          },
          child: const Text('Not Now'),
        ),
      ],
    );
  }
}
