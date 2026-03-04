import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Edit Profile page
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyPhoneController;

  String? _selectedAgeGroup;
  String? _selectedHikerType;
  File? _selectedImage;
  bool _isLoading = false;

  final List<String> _ageGroups = ['18-24', '24-35', '35-44', '45-54', '55-64', '65+'];
  final List<String> _hikerTypes = ['new', 'experienced'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    _emergencyNameController = TextEditingController();
    _emergencyPhoneController = TextEditingController();

    // Load current user data
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _loadUserData(authState.user);
    }
  }

  void _loadUserData(UserEntity user) {
    _nameController.text = user.name;
    _phoneController.text = user.phone ?? '';
    _bioController.text = user.bio;
    _selectedAgeGroup = user.ageGroup;
    _selectedHikerType = user.hikerType;
    _emergencyNameController.text = user.emergencyContact?.name ?? '';
    _emergencyPhoneController.text = user.emergencyContact?.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                _ImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (source != null) {
      final image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isLoading = true;
        });
        print('📁 Image selected: ${image.path}');
        // Upload image
        context.read<AuthBloc>().add(UploadProfileImageEvent(filePath: image.path));
      }
    }
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    context.read<AuthBloc>().add(UpdateProfileEvent(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          bio: _bioController.text.trim().isEmpty
              ? null
              : _bioController.text.trim(),
          ageGroup: _selectedAgeGroup,
          hikerType: _selectedHikerType,
          emergencyContactName: _emergencyNameController.text.trim().isEmpty
              ? null
              : _emergencyNameController.text.trim(),
          emergencyContactPhone: _emergencyPhoneController.text.trim().isEmpty
              ? null
              : _emergencyPhoneController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated && _isLoading) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          // Navigate back to profile instead of pop to avoid navigation stack issues
          if (_selectedImage == null) {
            context.go('/profile');
          }
        } else if (state is AuthError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        String? profileImageUrl;
        if (state is AuthAuthenticated) {
          final imageUrl = state.user.profileImageUrl;
          profileImageUrl = imageUrl.isNotEmpty &&
              (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))
              ? imageUrl
              : null;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (profileImageUrl != null
                                  ? CachedNetworkImageProvider(profileImageUrl)
                                  : null),
                          child: _selectedImage == null && profileImageUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name
                  _buildSectionTitle('Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(hint: 'Your full name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Phone
                  _buildSectionTitle('Phone Number'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(hint: 'Your phone number'),
                  ),
                  const SizedBox(height: 20),

                  // Bio
                  _buildSectionTitle('Bio'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _bioController,
                    maxLines: 3,
                    decoration: _inputDecoration(hint: 'Tell us about yourself...'),
                  ),
                  const SizedBox(height: 20),

                  // Age Group
                  _buildSectionTitle('Age Group'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedAgeGroup,
                    decoration: _inputDecoration(hint: 'Select age group'),
                    items: _ageGroups.map((age) {
                      return DropdownMenuItem(value: age, child: Text(age));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedAgeGroup = value);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Hiker Type
                  _buildSectionTitle('Experience Level'),
                  const SizedBox(height: 8),
                  Row(
                    children: _hikerTypes.map((type) {
                      final isSelected = _selectedHikerType == type;
                      final label = type == 'new' ? 'Beginner' : 'Experienced';
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(label),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _selectedHikerType = type);
                            },
                            selectedColor: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Emergency Contact Section
                  _buildSectionTitle('Emergency Contact'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emergencyNameController,
                    decoration: _inputDecoration(hint: 'Emergency contact name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emergencyPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(hint: 'Emergency contact phone'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
