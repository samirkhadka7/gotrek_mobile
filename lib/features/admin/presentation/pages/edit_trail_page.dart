import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/admin_trail_entity.dart';
import '../bloc/admin_trail_bloc.dart';
import '../bloc/admin_trail_event.dart';
import '../bloc/admin_trail_state.dart';

/// Edit trail page
class EditTrailPage extends StatefulWidget {
  final AdminTrailEntity trail;

  const EditTrailPage({Key? key, required this.trail}) : super(key: key);

  @override
  State<EditTrailPage> createState() => _EditTrailPageState();
}

class _EditTrailPageState extends State<EditTrailPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _distanceController;
  late final TextEditingController _elevationController;
  late final TextEditingController _durationMinController;
  late final TextEditingController _durationMaxController;

  String _difficulty = 'Moderate';
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    final trail = widget.trail;
    _nameController = TextEditingController(text: trail.name);
    _descriptionController = TextEditingController(text: trail.description);
    _locationController = TextEditingController(text: trail.location);
    _distanceController = TextEditingController(text: trail.distance.toString());
    _elevationController = TextEditingController(text: trail.elevation.toString());
    _difficulty = trail.difficulty.isNotEmpty ? trail.difficulty : 'Moderate';

    final durationParts = _parseDuration(trail.duration);
    _durationMinController = TextEditingController(
      text: durationParts.$1?.toString() ?? '',
    );
    _durationMaxController = TextEditingController(
      text: durationParts.$2?.toString() ?? '',
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

  (int?, int?) _parseDuration(String? duration) {
    if (duration == null || duration.trim().isEmpty) return (null, null);
    final matches = RegExp(r'\d+').allMatches(duration);
    final values = matches.map((m) => int.tryParse(m.group(0) ?? '')).whereType<int>().toList();
    if (values.isEmpty) return (null, null);
    if (values.length == 1) return (values.first, null);
    return (values.first, values[1]);
  }

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
        title: const Text('Edit Trail'),
      ),
      body: BlocListener<AdminTrailBloc, AdminTrailState>(
        listener: (context, state) {
          if (state is TrailUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trail updated successfully')),
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
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
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
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
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
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _difficulty,
                            decoration: const InputDecoration(
                              labelText: 'Difficulty',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                              DropdownMenuItem(value: 'Moderate', child: Text('Moderate')),
                              DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _difficulty = value ?? 'Moderate';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _durationMinController,
                            decoration: const InputDecoration(
                              labelText: 'Duration Min (days)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _durationMaxController,
                            decoration: const InputDecoration(
                              labelText: 'Duration Max (days)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
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
                    if (widget.trail.imageUrl != null && widget.trail.imageUrl!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Current Image',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.trail.imageUrl!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
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
                                        UpdateTrailEvent(
                                          trailId: widget.trail.id,
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
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save Changes'),
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
}
