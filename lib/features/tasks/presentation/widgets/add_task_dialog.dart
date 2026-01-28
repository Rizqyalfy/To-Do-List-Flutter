import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_list_bloc.dart';
import '../bloc/task_list_state.dart';

class AddTaskDialog extends StatefulWidget {
  final TaskEntity? task;

  const AddTaskDialog({super.key, this.task});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  int _selectedPriority = 0;
  late String _listId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedDate = widget.task?.dueDate;
    _selectedPriority = widget.task?.priority ?? 0;

    final taskListState = context.read<TaskListBloc>().state;
    if (taskListState is TaskListLoaded) {
      _listId = widget.task?.listId ?? taskListState.selectedListId ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.task == null ? 'Add Task' : 'Edit Task',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (widget.task != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<TaskBloc>().add(
                          DeleteTask(widget.task!.id),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter task title',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _selectedDate == null
                            ? 'Set due date'
                            : 'Due: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                    ),
                  ),
                  if (_selectedDate != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                        });
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Text('Priority', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('None'),
                    selected: _selectedPriority == 0,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedPriority = 0);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Low'),
                    selected: _selectedPriority == 1,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedPriority = 1);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Medium'),
                    selected: _selectedPriority == 2,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedPriority = 2);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('High'),
                    selected: _selectedPriority == 3,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedPriority = 3);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _saveTask,
                    child: Text(widget.task == null ? 'Add' : 'Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    final now = DateTime.now();
    final task = TaskEntity(
      id: widget.task?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      isCompleted: widget.task?.isCompleted ?? false,
      dueDate: _selectedDate,
      priority: _selectedPriority,
      listId: _listId,
      createdAt: widget.task?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.task == null) {
      context.read<TaskBloc>().add(AddTask(task));
    } else {
      context.read<TaskBloc>().add(UpdateTask(task));
    }

    Navigator.of(context).pop();
  }
}
