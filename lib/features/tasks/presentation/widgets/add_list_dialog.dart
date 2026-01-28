import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task_list_entity.dart';
import '../bloc/task_list_bloc.dart';
import '../bloc/task_list_event.dart';
import '../bloc/task_list_state.dart';

class AddListDialog extends StatefulWidget {
  final TaskListEntity? taskList;

  const AddListDialog({super.key, this.taskList});

  @override
  State<AddListDialog> createState() => _AddListDialogState();
}

class _AddListDialogState extends State<AddListDialog> {
  late TextEditingController _nameController;
  String? _selectedColor;

  final List<String> _availableColors = [
    '#FF5252', // Red
    '#FF4081', // Pink
    '#E040FB', // Purple
    '#7C4DFF', // Deep Purple
    '#536DFE', // Indigo
    '#448AFF', // Blue
    '#40C4FF', // Light Blue
    '#18FFFF', // Cyan
    '#64FFDA', // Teal
    '#69F0AE', // Green
    '#B2FF59', // Light Green
    '#EEFF41', // Lime
    '#FFFF00', // Yellow
    '#FFD740', // Amber
    '#FFAB40', // Orange
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.taskList?.name ?? '');
    _selectedColor = widget.taskList?.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskList != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit List' : 'New List'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'List Name',
                hintText: 'Enter list name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            Text('Choose Color', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableColors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(color.substring(1), radix: 16) + 0xFF000000,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        if (isEditing && widget.taskList != null)
          TextButton(
            onPressed: () {
              context.read<TaskListBloc>().add(
                DeleteTaskList(widget.taskList!.id),
              );
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _nameController.text.trim().isEmpty
              ? null
              : () {
                  if (isEditing && widget.taskList != null) {
                    context.read<TaskListBloc>().add(
                      UpdateTaskList(
                        widget.taskList!.copyWith(
                          name: _nameController.text.trim(),
                          color: _selectedColor,
                        ),
                      ),
                    );
                  } else {
                    final state = context.read<TaskListBloc>().state;
                    final order = state is TaskListLoaded
                        ? state.taskLists.length
                        : 0;

                    context.read<TaskListBloc>().add(
                      AddTaskList(
                        TaskListEntity(
                          id: const Uuid().v4(),
                          name: _nameController.text.trim(),
                          color: _selectedColor,
                          order: order,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                },
          child: Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
