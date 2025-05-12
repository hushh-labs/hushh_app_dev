import 'package:flutter/material.dart';

class DeleteConversationBottomSheet extends StatelessWidget {
  final Function() onDelete;
  final Function() onCancel;
  final String name;

  const DeleteConversationBottomSheet(
      {super.key,
      required this.onDelete,
      required this.name,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Delete Conversation?',
            style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 20,
                letterSpacing: -0.4,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style:
                    TextStyle(color: Color(0xFF4C4C4C), fontFamily: 'Figtree'),
                children: [
                  TextSpan(
                    text: 'Are you sure to delete conversation with ',
                  ),
                  TextSpan(
                    text: '$name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '? This action cannot be undone.',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Go back ↩'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEEEEEE),
                          elevation: 0,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: onCancel,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Yeah! Go ahead'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEEEEEE),
                          elevation: 0,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: onDelete,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
