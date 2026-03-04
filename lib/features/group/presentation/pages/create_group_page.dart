import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../injection/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../trail/presentation/bloc/trail_bloc.dart';
import '../../../trail/presentation/bloc/trail_event.dart';
import '../../../trail/presentation/bloc/trail_state.dart';
import '../../domain/entities/group_entity.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';

/// Page for creating a new trekking group
class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late final GroupBloc _groupBloc;
  late final TrailBloc _trailBloc;
  final ImagePicker _imagePicker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxSizeController = TextEditingController(text: '10');
  final _meetingPointController = TextEditingController();
  final _requirementsController = TextEditingController();

  String? _selectedTrailId;
  String? _selectedTrailName;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  String _difficulty = 'Moderate';
  bool _isLoading = false;
  List<File> _selectedPhotos = [];

  @override
  void initState() {
    super.initState();
    _groupBloc = sl<GroupBloc>();
    _trailBloc = sl<TrailBloc>();
    _trailBloc.add(const LoadTrailsEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxSizeController.dispose();
    _meetingPointController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        maxHeight: 1080,
        maxWidth: 1080,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedPhotos = pickedFiles.map((xFile) => File(xFile.path)).toList();
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking images: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showTrailSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Trail',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<TrailBloc, TrailState>(
                bloc: _trailBloc,
                builder: (context, state) {
                  if (state is TrailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is TrailsLoaded) {
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.trails.length,
                      itemBuilder: (context, index) {
                        final trail = state.trails[index];
                        final isSelected = _selectedTrailId == trail.id;
                        return Card(
                          color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : null,
                          child: ListTile(
                            leading: Icon(
                              Icons.terrain,
                              color: isSelected
                                ? AppColors.primary
                                : Colors.grey,
                            ),
                            title: Text(
                              trail.name,
                              style: TextStyle(
                                fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              '${trail.location} - ${trail.difficulty.toDisplayString()}',
                            ),
                            trailing: isSelected
                              ? const Icon(Icons.check_circle, color: AppColors.primary)
                              : null,
                            onTap: () {
                              setState(() {
                                _selectedTrailId = trail.id;
                                _selectedTrailName = trail.name;
                                _difficulty = trail.difficulty.toDisplayString();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text('No trails available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTrailId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a trail'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login again to create a group'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    _groupBloc.add(CreateGroupEvent(
      name: _titleController.text.trim(),
      trailId: _selectedTrailId!,
      startDate: _selectedDate,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      maxParticipants: int.tryParse(_maxSizeController.text) ?? 10,
      meetingPoint: _meetingPointController.text.trim().isNotEmpty
          ? MeetingPoint(
              odlName: _meetingPointController.text.trim(),
              odlLatitude: 0.0, // Default - will be set by map selection in future
              odlLongitude: 0.0,
            )
          : null,
      leaderId: authState.user.id,
      photos: _selectedPhotos,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      bloc: _groupBloc,
      listener: (context, state) {
        if (state is GroupCreating) {
          setState(() => _isLoading = true);
        } else if (state is GroupCreated) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Group created successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) context.pop();
          });
        } else if (state is GroupError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Group'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Title
                _buildSectionTitle('Group Title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration(
                    hint: 'Enter group title',
                    icon: Icons.group,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a group title';
                    }
                    if (value.length < 3) {
                      return 'Title must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Select Trail
                _buildSectionTitle('Select Trail'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _showTrailSelector,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.terrain,
                          color: _selectedTrailId != null
                            ? AppColors.primary
                            : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedTrailName ?? 'Select a trail',
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedTrailId != null
                                ? Colors.black
                                : Colors.grey,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Date Selection
                _buildSectionTitle('Trekking Date'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Description
                _buildSectionTitle('Description'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration(
                    hint: 'Describe your trekking group...',
                    icon: Icons.description,
                  ),
                ),
                const SizedBox(height: 24),

                // Photos Section
                _buildSectionTitle('Group Photos (Optional)'),
                const SizedBox(height: 8),
                _buildPhotoSelector(),
                const SizedBox(height: 24),

                // Max Group Size
                _buildSectionTitle('Max Group Size'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _maxSizeController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                    hint: 'Maximum participants',
                    icon: Icons.people,
                  ),
                  validator: (value) {
                    final size = int.tryParse(value ?? '');
                    if (size == null || size < 2 || size > 20) {
                      return 'Group size must be between 2 and 20';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Meeting Point
                _buildSectionTitle('Meeting Point'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _meetingPointController,
                  decoration: _inputDecoration(
                    hint: 'Where will the group meet?',
                    icon: Icons.location_on,
                  ),
                ),
                const SizedBox(height: 24),

                // Difficulty
                _buildSectionTitle('Difficulty'),
                const SizedBox(height: 8),
                Row(
                  children: ['Easy', 'Moderate', 'Hard'].map((level) {
                    final isSelected = _difficulty == level;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(level),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _difficulty = level),
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Requirements
                _buildSectionTitle('Requirements (optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _requirementsController,
                  decoration: _inputDecoration(
                    hint: 'e.g., Trekking boots, Water bottle (comma separated)',
                    icon: Icons.checklist,
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Create Group',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
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
    );
  }

  Widget _buildPhotoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _pickPhotos,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Add Photos (up to 10)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_selectedPhotos.length} photo(s) selected',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_selectedPhotos.isNotEmpty) ...[
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _selectedPhotos.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedPhotos[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }}