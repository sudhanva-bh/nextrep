import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextrep/auth_wrapper.dart';
import 'package:nextrep/core/common/providers.dart';
import 'package:nextrep/core/common/utils/show_snackbar.dart';
import 'package:nextrep/core/entities/user/user_profile_model.dart';
import 'package:nextrep/core/services/user_profile/profile_sync_service.dart';
import 'package:nextrep/core/services/user_profile/user_profile_service.dart';
import 'package:nextrep/features/auth/data/auth_service.dart';
import 'package:nextrep/features/home/presentation/widgets/bmi/bmi_card.dart';
import 'package:nextrep/features/profile/presentation/widgets/profile_action_row.dart';
import 'package:nextrep/features/profile/presentation/widgets/profile_detail_tile.dart';
import 'package:nextrep/features/profile/presentation/widgets/profile_header.dart';
import 'package:nextrep/features/profile/presentation/widgets/profile_section_card.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late final UserProfileService _profileService;
  final _authService = AuthService();
  final _syncService = ProfileSyncService();

  bool _isEditing = false;
  bool _isSyncing = false;
  bool _isSaving = false;
  bool _hasChanges = false;

  DateTime? _lastSynced;

  // Controllers for the text fields in edit mode
  late final TextEditingController _nameController;
  String? _selectedExperience;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _profileService = ref.read(userProfileServiceProvider);
    _nameController = TextEditingController();
    _nameController.addListener(() {
      if (_isEditing) setState(() => _hasChanges = true);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleEditMode(UserProfile? profile) {
    if (profile == null) return;
    setState(() {
      _isEditing = !_isEditing;
      _hasChanges = false;
      if (_isEditing) {
        _nameController.text = profile.name;

        final validExperiences = ['Beginner', 'Intermediate', 'Advanced'];
        final validGenders = ['Male', 'Female', 'Other', 'Prefer not to say'];

        _selectedExperience = validExperiences.contains(profile.experience)
            ? profile.experience
            : null;

        _selectedGender = validGenders.contains(profile.gender)
            ? profile.gender
            : null;
      }
    });
  }

  Future<void> _saveProfileChanges() async {
    if (!_hasChanges) {
      showSnackBar(context, 'No changes to save.');
      setState(() => _isEditing = false);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final newName = _nameController.text.trim();
      if (newName.isNotEmpty) {
        await _profileService.updateName(newName);
      }
      if (_selectedExperience != null) {
        await _profileService.updateExperience(_selectedExperience!);
      }
      if (_selectedGender != null) {
        await _profileService.updateGender(_selectedGender!);
      }

      showSnackBar(context, 'Profile updated successfully!');
      setState(() {
        _isEditing = false;
        _hasChanges = false;
      });
    } catch (e) {
      showSnackBar(context, 'Failed to save profile: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _handleSync() async {
    setState(() => _isSyncing = true);
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      final result = await _syncService.syncProfileOnCommand(uid);
      result.fold(
        (failure) => showSnackBar(context, 'Sync failed: ${failure.message}'),
        (_) {
          _lastSynced = DateTime.now();
          showSnackBar(context, 'Profile synced with cloud!');
        },
      );
    } else {
      showSnackBar(context, 'Not signed in.');
    }
    setState(() => _isSyncing = false);
  }

  Future<void> _handleLogout() async {
    final didConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text(
          'Are you sure you want to log out? '
          'Your local data will be synced to the cloud before you are signed out.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
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

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  String _formatLastSynced() {
    if (_lastSynced == null) return 'Never backed up';
    final dt = _lastSynced!.toLocal();
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
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
          // Removed edit / sync actions from the AppBar
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                flexibleSpace: ProfileHeader(
                  title: _isEditing ? 'Edit Profile' : profile.name,
                  subtitle: 'Last backup: ${_formatLastSynced()}',
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    BmiCard(),
                    const SizedBox(height: 16),
                    ProfileSectionCard(
                      title: 'Fitness Profile',
                      children: [
                        ProfileDetailTile(
                          icon: Icons.bar_chart,
                          label: 'Experience',
                          value: profile.experience,
                          isEditing: _isEditing,
                          child: DropdownButtonFormField<String>(
                            value: _selectedExperience,
                            items: ['Beginner', 'Intermediate', 'Advanced']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(capitalize(e)),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => setState(() {
                              _selectedExperience = value;
                              _hasChanges = true;
                            }),
                          ),
                        ),
                        ProfileDetailTile(
                          icon: Icons.person_outline,
                          label: 'Gender',
                          value: capitalize(profile.gender),
                          isEditing: _isEditing,
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender,
                            items:
                                ['Male', 'Female', 'Other', 'Prefer not to say']
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(capitalize(e)),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) => setState(() {
                              _selectedGender = value;
                              _hasChanges = true;
                            }),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ProfileActionRow(
                          isEditing: _isEditing,
                          isSaving: _isSaving,
                          isSyncing: _isSyncing,
                          hasChanges: _hasChanges,
                          onEditToggle: () => _toggleEditMode(profile),
                          onSave: _saveProfileChanges,
                          onSync: _handleSync,
                          onLogout: _handleLogout,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
