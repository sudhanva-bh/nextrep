import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey,
              endIndent: 12,
            ),
          ),
          Text(
            'Or Continue with',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 12,
            ),
          ),
        ],
      ),
    );
  }
}
