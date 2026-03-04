import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/admin_trail_bloc.dart';
import '../bloc/admin_trail_event.dart';
import '../bloc/admin_trail_state.dart';

/// Create new trail page
class CreateTrailPage extends StatefulWidget {
  const CreateTrailPage({Key? key}) : super(key: key);

  @override
  State<CreateTrailPage> createState() => _CreateTrailPageState();
}

class _CreateTrailPageState extends State<CreateTrailPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _distanceController = TextEditingController();
  final _elevationController = TextEditingController();
  final _durationMinController = TextEditingController();
  final _durationMaxController = TextEditingController();

  String _difficulty = 'Moderate';
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    final images = await _imagePicker.pickMultiImage();
    if (images.isEmpty) return;

    setState(() {
      _selectedImages.addAll(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trail'),
      ),
      body: BlocListener<AdminTrailBloc, AdminTrailState>(
        listener: (context, state) {
          if (state is TrailCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trail created successfully')),
            );
            Navigator.pop(context);
          } else if (state is AdminTrailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<AdminTrailBloc, AdminTrailState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Trail Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _distanceController,
                            decoration: const InputDecoration(
                              labelText: 'Distance (km)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _elevationController,
                            decoration: const InputDecoration(
                              labelText: 'Elevation (m)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 600;
                        final difficultyField = DropdownButtonFormField<String>(
                          value: _difficulty,
                          decoration: const InputDecoration(
                            labelText: 'Difficulty',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Easy',
                              child: Text('Easy'),
                            ),
                            DropdownMenuItem(
                              value: 'Moderate',
                              child: Text('Moderate'),
                            ),
                            DropdownMenuItem(
                              value: 'Hard',
                              child: Text('Hard'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _difficulty = value ?? 'Moderate';
                            });
                          },
                        );

                        final durationMinField = TextFormField(
                          controller: _durationMinController,
                          decoration: const InputDecoration(
                            labelText: 'Duration Min (days)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        );

                        final durationMaxField = TextFormField(
                          controller: _durationMaxController,
                          decoration: const InputDecoration(
                            labelText: 'Duration Max (days)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        );

                        if (isNarrow) {
                          return Column(
                            children: [
                              difficultyField,
                              const SizedBox(height: 12),
                              durationMinField,
                              const SizedBox(height: 12),
                              durationMaxField,
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(child: difficultyField),
                            const SizedBox(width: 12),
                            Expanded(child: durationMinField),
                            const SizedBox(width: 12),
                            Expanded(child: durationMaxField),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickImages,
                            icon: const Icon(Icons.photo_library_outlined),
                            label: Text(
                              _selectedImages.isEmpty
                                  ? 'Add Images'
                                  : 'Add More Images (${_selectedImages.length})',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_selectedImages.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 72,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final image = _selectedImages[index];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(image.path),
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is AdminTrailLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final distanceValue = double.tryParse(
                                    _distanceController.text.trim().replaceAll(',', '.'),
                                  );
                                  final elevationValue = double.tryParse(
                                    _elevationController.text.trim().replaceAll(',', '.'),
                                  );

                                  if (distanceValue == null || elevationValue == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter valid numbers for distance and elevation.'),
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<AdminTrailBloc>().add(
                                    CreateTrailEvent(
                                      name: _nameController.text,
                                      description: _descriptionController.text,
                                      location: _locationController.text,
                                      distance: distanceValue,
                                      elevation: elevationValue,
                                      difficulty: _difficulty,
                                      durationMin: int.tryParse(
                                        _durationMinController.text.trim(),
                                      ),
                                      durationMax: int.tryParse(
                                        _durationMaxController.text.trim(),
                                      ),
                                      imagePaths: _selectedImages
                                          .map((image) => image.path)
                                          .toList(),
                                    ),
                                  );
                                }
                              },
                        child: state is AdminTrailLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Create Trail'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _distanceController.dispose();
    _elevationController.dispose();
    _durationMinController.dispose();
    _durationMaxController.dispose();
    super.dispose();
  }
}
