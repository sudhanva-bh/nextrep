import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ProfileHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: false,
      titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
