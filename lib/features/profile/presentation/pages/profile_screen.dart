import 'package:flutter/material.dart';
import 'package:nextrep/auth_wrapper.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';
import 'package:nextrep/core/services/user_profile/profile_sync_service.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/auth/data/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileService = UserProfileService();
  final _authService = AuthService();
  final _syncService = ProfileSyncService();

  bool _isEditing = false;
  bool _isSyncing = false;

  // Controllers for the text fields in edit mode
  late final TextEditingController _nameController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _targetWeightController;
  String? _selectedExperience;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _targetWeightController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _toggleEditMode(UserProfile? profile) {
    if (profile == null) return;

    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        // When entering edit mode, populate controllers with current data
        _nameController.text = profile.name;
        _heightController.text = profile.height.toString();
        _weightController.text = profile.weight.toString();
        _targetWeightController.text = profile.targetWeight?.toString() ?? '';
        _selectedExperience = profile.experience;
        _selectedGender = profile.gender;
      }
    });
  }

  Future<void> _saveProfileChanges() async {
    // Basic validation could be added here
    final newName = _nameController.text;
    final newHeight = double.tryParse(_heightController.text) ?? 0.0;
    final newWeight = double.tryParse(_weightController.text) ?? 0.0;
    final newTargetWeight = double.tryParse(_targetWeightController.text);

    await _profileService.updateName(newName);
    await _profileService.updateHeight(newHeight);
    await _profileService.updateWeight(newWeight);
    if (newTargetWeight != null) {
      await _profileService.updateTargetWeight(newTargetWeight);
    }
    if (_selectedExperience != null) {
      await _profileService.updateExperience(_selectedExperience!);
    }
    if (_selectedGender != null) {
      await _profileService.updateGender(_selectedGender!);
    }

    showSnackBar(context, 'Profile updated successfully!');
    setState(() {
      _isEditing = false; // Exit edit mode after saving
    });
  }

  Future<void> _handleSync() async {
    setState(() => _isSyncing = true);
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      final result = await _syncService.syncProfileOnCommand(uid);
      result.fold(
        (failure) => showSnackBar(context, 'Sync failed: ${failure.message}'),
        (_) => showSnackBar(context, 'Profile synced with cloud!'),
      );
    }
    setState(() => _isSyncing = false);
  }

  Future<void> _handleLogout() async {
    final didConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out? Your local data will be synced to the cloud before you are signed out.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Logout')),
        ],
      ),
    );

    if (didConfirm == true && mounted) {
      showSnackBar(context, 'Syncing data before logout...');
      final uid = _authService.currentUser!.uid;
      await _syncService.syncProfileOnLogout(uid);
      await _authService.signOut();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: _profileService.getProfileListenable(),
      builder: (context, profile, child) {
        if (profile == null) {
          return const Scaffold(body: Center(child: Text('No profile found.')));
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                  title: Text(
                    _isEditing ? 'Edit Profile' : profile.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                actions: [
                  if (_isEditing)
                    IconButton(icon: const Icon(Icons.save), tooltip: 'Save', onPressed: _saveProfileChanges)
                  else
                    IconButton(icon: const Icon(Icons.edit), tooltip: 'Edit', onPressed: () => _toggleEditMode(profile)),
                  IconButton(
                    icon: _isSyncing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.cloud_sync),
                    tooltip: 'Sync with Cloud',
                    onPressed: _isSyncing ? null : _handleSync,
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // --- Biometrics Section ---
                    _ProfileSectionCard(
                      title: 'Biometrics',
                      children: [
                        _ProfileDetailTile(
                          icon: Icons.height,
                          label: 'Height (cm)',
                          value: '${profile.height} cm',
                          isEditing: _isEditing,
                          child: TextField(controller: _heightController, keyboardType: TextInputType.number),
                        ),
                        _ProfileDetailTile(
                          icon: Icons.monitor_weight_outlined,
                          label: 'Weight (kg)',
                          value: '${profile.weight} kg',
                          isEditing: _isEditing,
                          child: TextField(controller: _weightController, keyboardType: TextInputType.number),
                        ),
                        _ProfileDetailTile(
                          icon: Icons.flag,
                          label: 'Target Weight (kg)',
                          value: profile.targetWeight != null ? '${profile.targetWeight} kg' : 'Not set',
                          isEditing: _isEditing,
                          child: TextField(controller: _targetWeightController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'e.g. 75.0')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // --- Fitness Profile Section ---
                    _ProfileSectionCard(
                      title: 'Fitness Profile',
                      children: [
                        _ProfileDetailTile(
                          icon: Icons.bar_chart,
                          label: 'Experience',
                          value: profile.experience,
                          isEditing: _isEditing,
                          child: DropdownButtonFormField<String>(
                            value: _selectedExperience,
                            items: ['Beginner', 'Intermediate', 'Advanced']
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) => setState(() => _selectedExperience = value),
                          ),
                        ),
                        _ProfileDetailTile(
                          icon: Icons.person_outline,
                          label: 'Gender',
                          value: profile.gender,
                          isEditing: _isEditing,
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender,
                            items: ['Male', 'Female', 'Other', 'Prefer not to say']
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) => setState(() => _selectedGender = value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // --- Logout Button ---
                    ElevatedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout and Sync'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.error,
                        foregroundColor: AppPalette.onError,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LoginPage {
  const LoginPage();
}

// Helper widget for a section card
class _ProfileSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _ProfileSectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

// Helper widget for displaying a single profile detail
class _ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEditing;
  final Widget child;

  const _ProfileDetailTile({
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
                const SizedBox(height: 2),
                if (isEditing)
                  child // Show the text field or dropdown in edit mode
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