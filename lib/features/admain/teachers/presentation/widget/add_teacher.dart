import 'package:academy_management_system/features/admain/teachers/presentation/cubit/teachers_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/models/entities.dart';
import '../../../groups/presentation/cubit/groups_cubit.dart';

/// ===============================================================
/// ADD / EDIT TEACHER DIALOG
/// ===============================================================
///
/// Fields:
/// 1. name
/// 2. phone
/// 3. gender
/// 4. address
/// 5. hireDate
/// 6. status
/// 7. salary
/// 8. groups
/// 9. notes
///
/// Groups are loaded from the existing GroupsCubit.
/// No hardcoded group names are used.
/// ===============================================================

Future<void> showTeacherDialog(BuildContext context, {Teacher? item}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<TeachersCubit>()),
          BlocProvider.value(value: context.read<GroupsCubit>()),
        ],
        child: _TeacherDialog(teacher: item),
      );
    },
  );
}

class _TeacherDialog extends StatefulWidget {
  const _TeacherDialog({this.teacher});

  final Teacher? teacher;

  @override
  State<_TeacherDialog> createState() => _TeacherDialogState();
}

class _TeacherDialogState extends State<_TeacherDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _salaryController;
  late final TextEditingController _notesController;

  String? _gender;
  RecordStatus _status = RecordStatus.active;
  DateTime? _hireDate;

  final Set<int> _selectedGroupIds = {};

  bool _saving = false;

  bool get _editing => widget.teacher != null;

  @override
  void initState() {
    super.initState();

    final teacher = widget.teacher;

    _nameController = TextEditingController(text: teacher?.name ?? '');

    _phoneController = TextEditingController(text: _teacherPhone(teacher));

    _addressController = TextEditingController(text: _teacherAddress(teacher));

    _salaryController = TextEditingController(text: _teacherSalary(teacher));

    _notesController = TextEditingController(text: _teacherNotes(teacher));

    _gender = _teacherGender(teacher);
    _hireDate = _teacherHireDate(teacher);

    if (teacher != null) {
      _status = teacher.status;

      for (final id in _teacherGroupIds(teacher)) {
        _selectedGroupIds.add(id);
      }
    }

    /*
     * If your GroupsCubit requires an explicit fetch call,
     * keep it here, e.g.:
     *
     * context.read<GroupsCubit>().loadGroups();
     *
     * If groups are already loaded by the page/provider,
     * no additional request is required.
     */
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _salaryController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: mediaQuery.size.width < 600 ? 14 : 40,
          vertical: 24,
        ),
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820, maxHeight: 840),
          child: Material(
            color: const Color(0xFFFFFCF8),
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _buildHeader(context),
                const Divider(height: 1, color: Color(0xFFE8E0D7)),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _SectionTitle(
                            title: 'البيانات الأساسية',
                            subtitle: 'أدخل بيانات المدرس الأساسية.',
                          ),

                          const SizedBox(height: 20),

                          _ResponsiveFields(
                            children: [
                              _AppTextField(
                                controller: _nameController,
                                label: 'اسم المدرس',
                                hint: 'أدخل الاسم الكامل',
                                icon: Icons.person_outline,
                                requiredField: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى إدخال اسم المدرس';
                                  }

                                  if (value.trim().length < 3) {
                                    return 'اسم المدرس قصير جداً';
                                  }

                                  return null;
                                },
                              ),
                              _AppTextField(
                                controller: _phoneController,
                                label: 'رقم الهاتف',
                                hint: 'مثال: 01012345678',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                requiredField: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9+\-\s]'),
                                  ),
                                ],
                                validator: (value) {
                                  final phone =
                                      value?.replaceAll(' ', '').trim() ?? '';

                                  if (phone.isEmpty) {
                                    return 'يرجى إدخال رقم الهاتف';
                                  }

                                  if (phone.length < 8) {
                                    return 'رقم الهاتف غير صحيح';
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          _ResponsiveFields(
                            children: [
                              _GenderField(
                                value: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                },
                              ),
                              _StatusField(
                                value: _status,
                                onChanged: (value) {
                                  if (value == null) return;

                                  setState(() {
                                    _status = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          _AppTextField(
                            controller: _addressController,
                            label: 'العنوان',
                            hint: 'أدخل عنوان المدرس',
                            icon: Icons.location_on_outlined,
                            requiredField: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى إدخال العنوان';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 28),

                          const _SectionDivider(),

                          const SizedBox(height: 24),

                          const _SectionTitle(
                            title: 'بيانات العمل',
                            subtitle:
                                'حدد تاريخ التعيين والراتب والحالة الوظيفية.',
                          ),

                          const SizedBox(height: 20),

                          _ResponsiveFields(
                            children: [
                              _DateField(
                                value: _hireDate,
                                onTap: _selectHireDate,
                              ),
                              _AppTextField(
                                controller: _salaryController,
                                label: 'الراتب',
                                hint: '0.00',
                                icon: Icons.payments_outlined,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                requiredField: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى إدخال الراتب';
                                  }

                                  final salary = double.tryParse(value.trim());

                                  if (salary == null) {
                                    return 'يرجى إدخال راتب صحيح';
                                  }

                                  if (salary < 0) {
                                    return 'الراتب لا يمكن أن يكون سالباً';
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          const _SectionDivider(),

                          const SizedBox(height: 24),

                          const _SectionTitle(
                            title: 'المجموعات',
                            subtitle: 'اختر مجموعة واحدة أو أكثر للمدرس.',
                          ),

                          const SizedBox(height: 16),

                          _GroupsSelector(
                            selectedIds: _selectedGroupIds,
                            onChanged: (ids) {
                              setState(() {
                                _selectedGroupIds
                                  ..clear()
                                  ..addAll(ids);
                              });
                            },
                          ),

                          const SizedBox(height: 28),

                          const _SectionDivider(),

                          const SizedBox(height: 24),

                          const _SectionTitle(
                            title: 'ملاحظات',
                            subtitle: 'يمكن إضافة أي معلومات إضافية عن المدرس.',
                          ),

                          const SizedBox(height: 16),

                          _AppTextField(
                            controller: _notesController,
                            label: 'الملاحظات',
                            hint: 'اكتب أي ملاحظات إضافية...',
                            icon: Icons.notes_outlined,
                            maxLines: 4,
                            minLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE8E0D7)),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE1F0ED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_add_alt_1_outlined,
              color: Color(0xFF237F76),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _editing ? 'تعديل بيانات المدرس' : 'إضافة مدرس',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF293B50),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _editing
                      ? 'قم بتحديث البيانات المطلوبة ثم احفظ التغييرات.'
                      : 'أدخل بيانات المدرس ثم اضغط حفظ المدرس.',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7B8796),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _saving
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            icon: const Icon(Icons.close, size: 21),
            color: const Color(0xFF6B7889),
            tooltip: 'إغلاق',
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: _saving
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4C5D70),
              side: const BorderSide(color: Color(0xFFDCD5CD)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF25877D),
              disabledBackgroundColor: const Color(0xFFAACAC6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _saving
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      key: const ValueKey('text'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          _editing ? 'حفظ التعديلات' : 'حفظ المدرس',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectHireDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _hireDate ?? now,
      firstDate: DateTime(1980),
      lastDate: DateTime(now.year + 1),
      helpText: 'اختر تاريخ التعيين',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (picked == null) return;

    setState(() {
      _hireDate = picked;
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) {
      return;
    }

    if (_gender == null) {
      _showError('يرجى تحديد النوع');
      return;
    }

    if (_hireDate == null) {
      _showError('يرجى تحديد تاريخ التعيين');
      return;
    }

    if (_selectedGroupIds.isEmpty) {
      _showError('يرجى اختيار مجموعة واحدة على الأقل');
      return;
    }

    final salary = double.tryParse(_salaryController.text.trim());

    if (salary == null) {
      _showError('يرجى إدخال راتب صحيح');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final cubit = context.read<TeachersCubit>();

      /*
       * ---------------------------------------------------------
       * CONNECT THIS TO YOUR EXISTING TeachersCubit METHOD
       * ---------------------------------------------------------
       *
       * Do not create a second repository.
       *
       * Use your existing Cubit/repository save method here.
       *
       * Example expected payload:
       */

      // await cubit.save(
      //   id: _teacherId(widget.teacher),
      //   name: _nameController.text.trim(),
      //   phone: _phoneController.text.trim(),
      //   gender: _gender!,
      //   address: _addressController.text.trim(),
      //   hireDate: _hireDate!,
      //   status: _status,
      //   salary: salary,
      //   groups: _selectedGroupIds.toList(),
      //   notes: _notesController.text.trim(),
      // );

      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editing ? 'تم تحديث بيانات المدرس بنجاح' : 'تم إضافة المدرس بنجاح',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      _showError(
        _editing
            ? 'تعذر تحديث بيانات المدرس. حاول مرة أخرى.'
            : 'تعذر إضافة المدرس. حاول مرة أخرى.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFB4534A),
        ),
      );
  }

  // =============================================================
  // ADAPTER HELPERS
  // =============================================================
  //
  // These helpers keep the dialog isolated from unnecessary model
  // modifications.
  //
  // If these properties already exist on Teacher, simply replace
  // the helper bodies with the direct property.
  // =============================================================

  String _teacherPhone(Teacher? teacher) {
    if (teacher == null) return '';

    try {
      return (teacher as dynamic).phone?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  String _teacherAddress(Teacher? teacher) {
    if (teacher == null) return '';

    try {
      return (teacher as dynamic).address?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  String _teacherSalary(Teacher? teacher) {
    if (teacher == null) return '';

    try {
      final value = (teacher as dynamic).salary;

      return value?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  String _teacherNotes(Teacher? teacher) {
    if (teacher == null) return '';

    try {
      return (teacher as dynamic).notes?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  String? _teacherGender(Teacher? teacher) {
    if (teacher == null) return null;

    try {
      return (teacher as dynamic).gender?.toString();
    } catch (_) {
      return null;
    }
  }

  DateTime? _teacherHireDate(Teacher? teacher) {
    if (teacher == null) return null;

    try {
      final value = (teacher as dynamic).hireDate;

      if (value is DateTime) {
        return value;
      }

      if (value is String) {
        return DateTime.tryParse(value);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  List<int> _teacherGroupIds(Teacher teacher) {
    try {
      final groups = (teacher as dynamic).groups;

      if (groups is Iterable) {
        return groups
            .map<int?>((item) {
              if (item is int) return item;

              try {
                return (item as dynamic).id as int?;
              } catch (_) {
                return int.tryParse(item.toString());
              }
            })
            .whereType<int>()
            .toList();
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  dynamic _teacherId(Teacher? teacher) {
    if (teacher == null) return null;

    try {
      return (teacher as dynamic).id;
    } catch (_) {
      return null;
    }
  }
}

/// ===============================================================
/// GROUP SELECTOR
/// ===============================================================

class _GroupsSelector extends StatefulWidget {
  const _GroupsSelector({required this.selectedIds, required this.onChanged});

  final Set<int> selectedIds;
  final ValueChanged<Set<int>> onChanged;

  @override
  State<_GroupsSelector> createState() => _GroupsSelectorState();
}

class _GroupsSelectorState extends State<_GroupsSelector> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsCubit, GroupsState>(
      builder: (context, state) {
        final cubit = context.read<GroupsCubit>();

        /*
         * Use the GroupsCubit's already loaded collection.
         *
         * If your property is named items/groups/allGroups instead
         * of visible, change ONLY this line.
         */
        final groups = cubit.visible;

        final filtered = groups.where((group) {
          if (_query.isEmpty) {
            return true;
          }

          return group.name.toLowerCase().contains(_query.toLowerCase());
        }).toList();

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE3DCD3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _query = value.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ابحث في المجموعات...',
                    prefixIcon: const Icon(Icons.search, size: 19),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();

                              setState(() {
                                _query = '';
                              });
                            },
                            icon: const Icon(Icons.close, size: 17),
                          ),
                    filled: true,
                    fillColor: const Color(0xFFFFFCF8),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE3DCD3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE3DCD3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF25877D)),
                    ),
                  ),
                ),
              ),

              if (widget.selectedIds.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                  child: Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: groups
                        .where((group) => widget.selectedIds.contains(group.id))
                        .map(
                          (group) => Chip(
                            label: Text(
                              group.name,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF247970),
                              ),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 15),
                            onDeleted: () {
                              final updated = Set<int>.from(widget.selectedIds)
                                ..remove(group.id);

                              widget.onChanged(updated);
                            },
                            backgroundColor: const Color(0xFFE1F0ED),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFEAE4DC)),
              ],

              if (groups.isEmpty)
                const _GroupsEmptyState()
              else if (filtered.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_outlined,
                        color: Color(0xFF9AA5B1),
                        size: 30,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'لا توجد مجموعات مطابقة للبحث',
                        style: TextStyle(
                          color: Color(0xFF7C8795),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 245),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) {
                      return const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFF0EBE5),
                      );
                    },
                    itemBuilder: (context, index) {
                      final group = filtered[index];

                      final selected = widget.selectedIds.contains(group.id);

                      return InkWell(
                        onTap: () {
                          final updated = Set<int>.from(widget.selectedIds);

                          if (selected) {
                            updated.remove(group.id);
                          } else {
                            updated.add(int.tryParse(group.id) ?? 0);
                          }

                          widget.onChanged(updated);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 130),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          color: selected
                              ? const Color(0xFFF1F8F6)
                              : Colors.transparent,
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 130),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF25877D)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: selected
                                        ? const Color(0xFF25877D)
                                        : const Color(0xFFD4CDC5),
                                  ),
                                ),
                                child: selected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  group.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: const Color(0xFF34475B),
                                  ),
                                ),
                              ),
                              if (selected)
                                const Text(
                                  'محدد',
                                  style: TextStyle(
                                    color: Color(0xFF25877D),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              if (groups.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFEAE4DC))),
                  ),
                  child: Text(
                    widget.selectedIds.isEmpty
                        ? 'لم يتم اختيار أي مجموعة'
                        : 'تم اختيار ${widget.selectedIds.length} مجموعة',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: widget.selectedIds.isEmpty
                          ? const Color(0xFF7E8996)
                          : const Color(0xFF25877D),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _GroupsEmptyState extends StatelessWidget {
  const _GroupsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        children: [
          Icon(Icons.groups_outlined, size: 32, color: Color(0xFF9DA8B3)),
          SizedBox(height: 9),
          Text(
            'لا توجد مجموعات متاحة',
            style: TextStyle(
              color: Color(0xFF687687),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'قم بإضافة المجموعات أولاً من صفحة المجموعات.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF919BA6), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// FORM CONTROLS
/// ===============================================================

class _ResponsiveFields extends StatelessWidget {
  const _ResponsiveFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) const SizedBox(height: 16),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < children.length; i++) ...[
              Expanded(child: children[i]),
              if (i != children.length - 1) const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.requiredField = false,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool requiredField;
  final int maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(text: label, requiredField: requiredField),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          minLines: minLines,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 12, color: Color(0xFF34475B)),
          decoration: _inputDecoration(hint: hint, icon: icon),
        ),
      ],
    );
  }
}

class _GenderField extends StatelessWidget {
  const _GenderField({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _FieldLabel(text: 'النوع', requiredField: true),
        const SizedBox(height: 7),
        Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCF8),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: const Color(0xFFE0D8CF)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _GenderButton(
                  title: 'ذكر',
                  icon: Icons.male,
                  selected: value == 'male',
                  onTap: () {
                    onChanged('male');
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _GenderButton(
                  title: 'أنثى',
                  icon: Icons.female,
                  selected: value == 'female',
                  onTap: () {
                    onChanged('female');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE1F0ED) : Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? const Color(0xFF25877D)
                    : const Color(0xFF778595),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? const Color(0xFF25877D)
                      : const Color(0xFF596A7D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusField extends StatelessWidget {
  const _StatusField({required this.value, required this.onChanged});

  final RecordStatus value;
  final ValueChanged<RecordStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _FieldLabel(text: 'الحالة', requiredField: true),
        const SizedBox(height: 7),
        DropdownButtonFormField<RecordStatus>(
          value: value,
          onChanged: onChanged,
          decoration: _inputDecoration(
            hint: 'اختر الحالة',
            icon: Icons.toggle_on_outlined,
          ),
          items: const [
            DropdownMenuItem(value: RecordStatus.active, child: Text('نشط')),
            DropdownMenuItem(
              value: RecordStatus.inactive,
              child: Text('غير نشط'),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.value, required this.onTap});

  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _FieldLabel(text: 'تاريخ التعيين', requiredField: true),
        const SizedBox(height: 7),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: InputDecorator(
            decoration: _inputDecoration(
              hint: 'اختر تاريخ التعيين',
              icon: Icons.calendar_today_outlined,
            ),
            child: Text(
              value == null ? 'اختر تاريخ التعيين' : _formatDate(value!),
              style: TextStyle(
                fontSize: 12,
                color: value == null
                    ? const Color(0xFF9A9FA6)
                    : const Color(0xFF34475B),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, this.requiredField = false});

  final String text;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF435468),
          ),
        ),
        if (requiredField) ...[
          const SizedBox(width: 3),
          const Text(
            '*',
            style: TextStyle(
              color: Color(0xFFC65F52),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D4054),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: Color(0xFF89939E)),
        ),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: Color(0xFFE8E1D9));
  }
}

InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF9A9FA6), fontSize: 11),
    prefixIcon: Icon(icon, size: 18, color: const Color(0xFF718194)),
    filled: true,
    fillColor: const Color(0xFFFFFCF8),
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
    errorStyle: const TextStyle(color: Color(0xFFB9534A), fontSize: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFE0D8CF)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFE0D8CF)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFF25877D), width: 1.3),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFB9534A)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFB9534A), width: 1.3),
    ),
  );
}
