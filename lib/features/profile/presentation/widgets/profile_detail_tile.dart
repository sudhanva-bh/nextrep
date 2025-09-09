import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEditing;
  final Widget child;

  const ProfileDetailTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isEditing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppPalette.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                if (isEditing)
                  child
                else
                  Text(value, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
