import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class ProfileActionRow extends StatelessWidget {
  final bool isEditing;
  final bool isSaving;
  final bool isSyncing;
  final bool hasChanges;
  final VoidCallback onEditToggle;
  final Future<void> Function() onSave;
  final Future<void> Function() onSync;
  final Future<void> Function() onLogout;

  const ProfileActionRow({
    super.key,
    required this.isEditing,
    required this.isSaving,
    required this.isSyncing,
    required this.hasChanges,
    required this.onEditToggle,
    required this.onSave,
    required this.onSync,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isSyncing ? null : onSync,
            icon: isSyncing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(),
                  )
                : const Icon(Icons.cloud_upload),
            label: const Text('Sync Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.primary,
              foregroundColor: AppPalette.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Builder(
            builder: (context) {
              // Show Save when editing & hasChanges
              if (isEditing && hasChanges) {
                return OutlinedButton.icon(
                  onPressed: isSaving ? null : () => onSave(),
                  icon: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Save changes'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                );
              }

              // Show Cancel when editing & no changes (instead of a disabled Save)
              if (isEditing && !hasChanges) {
                return OutlinedButton.icon(
                  onPressed: onEditToggle,
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: AppPalette.outlineEnabled,
                    ),
                  ),
                );
              }

              // Show Edit when not editing
              return OutlinedButton.icon(
                onPressed: onEditToggle,
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: AppPalette.outlineEnabled,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            onPressed: isSyncing ? null : onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout and Sync',
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
