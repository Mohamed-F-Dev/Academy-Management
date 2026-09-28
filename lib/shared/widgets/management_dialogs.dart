import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/admain/academy/presentation/cubit/academy_cubit.dart';
import '../../features/admain/groups/presentation/cubit/groups_cubit.dart';
import '../../features/admain/payments/presentation/cubit/payments_cubit.dart';
import '../../features/admain/students/presentation/cubit/students_cubit.dart';
import '../../features/admain/teachers/presentation/cubit/teachers_cubit.dart';
import '../models/entities.dart';

Future<void> showStudentDialog(BuildContext context, {Student? item}) async {
  final saved = await showDialog<bool>(
    context: context,
    builder: (_) => StudentDialog(item: item),
  );
  if (saved == true && context.mounted)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ بيانات الطالب بنجاح')));
}

class StudentDialog extends StatefulWidget {
  const StudentDialog({this.item, super.key});
  final Student? item;
  @override
  State<StudentDialog> createState() => _StudentDialogState();
}

class _StudentDialogState extends State<StudentDialog> {
  late final Map<String, TextEditingController> c;
  late RecordStatus status;
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    final s = widget.item;
    status = s?.status ?? RecordStatus.active;
    c = {
      for (final x in [
        'name',
        'phone',
        'guardian',
        'guardianPhone',
        'birthDate',
        'address',
        'notes',
      ])
        x: TextEditingController(
          text: switch (x) {
            'name' => s?.name ?? '',
            'phone' => s?.phone ?? '',
            'guardian' => s?.guardian ?? '',
            'guardianPhone' => s?.guardianPhone ?? '',
            'birthDate' => s?.birthDate ?? '',
            'address' => s?.address ?? '',
            _ => s?.notes ?? '',
          },
        ),
    };
  }

  @override
  void dispose() {
    for (final x in c.values) x.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.item == null ? 'إضافة طالب جديد' : 'تعديل بيانات الطالب',
    ),
    content: SizedBox(
      width: 580,
      child: Form(
        key: key,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _field('name', 'الاسم', Icons.person_outline),
              _field('phone', 'رقم الهاتف', Icons.phone_outlined),
              _field('guardian', 'اسم ولي الأمر', Icons.family_restroom),
              _field(
                'guardianPhone',
                'رقم ولي الأمر',
                Icons.phone_android_outlined,
              ),
              _field('birthDate', 'تاريخ الميلاد', Icons.cake_outlined),
              _field('address', 'العنوان', Icons.location_on_outlined),
              SizedBox(
                width: 275,
                child: DropdownButtonFormField<RecordStatus>(
                  initialValue: status,
                  decoration: const InputDecoration(labelText: 'الحالة'),
                  items: const [
                    DropdownMenuItem(
                      value: RecordStatus.active,
                      child: Text('نشط'),
                    ),
                    DropdownMenuItem(
                      value: RecordStatus.inactive,
                      child: Text('غير نشط'),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => status = v ?? RecordStatus.active),
                ),
              ),
              _field(
                'notes',
                'الملاحظات',
                Icons.notes,
                required: false,
                lines: 2,
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('إلغاء'),
      ),
      FilledButton.icon(
        onPressed: _save,
        icon: const Icon(Icons.check),
        label: const Text('حفظ البيانات'),
      ),
    ],
  );
  Widget _field(
    String name,
    String label,
    IconData icon, {
    bool required = true,
    int lines = 1,
  }) => SizedBox(
    width: 275,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: c[name],
        maxLines: lines,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: required
            ? (v) => v == null || v.trim().isEmpty ? 'هذا الحقل مطلوب' : null
            : null,
      ),
    ),
  );
  void _save() {
    if (!key.currentState!.validate()) return;
    final old = widget.item;
    final item = Student(
      id: old?.id ?? 's${DateTime.now().microsecondsSinceEpoch}',
      name: c['name']!.text,
      phone: c['phone']!.text,
      guardian: c['guardian']!.text,
      guardianPhone: c['guardianPhone']!.text,
      birthDate: c['birthDate']!.text,
      address: c['address']!.text,
      status: status,
      notes: c['notes']!.text,
      group: old?.group ?? 'بدون مجموعة',
    );
    context.read<StudentsCubit>().save(item);
    Navigator.pop(context, true);
  }
}

// Future<void> showTeacherDialog(BuildContext context, {Teacher? item}) async {
//   final saved = await showDialog<bool>(
//     context: context,
//     builder: (_) => TeacherDialog(item: item),
//   );
//   if (saved == true && context.mounted)
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('تم حفظ بيانات المدرس بنجاح')));
// }

// class TeacherDialog extends StatefulWidget {
//   const TeacherDialog({this.item, super.key});
//   final Teacher? item;
//   @override
//   State<TeacherDialog> createState() => _TeacherDialogState();
// }

// class _TeacherDialogState extends State<TeacherDialog> {
//   late final TextEditingController name, email, phone, specialty;
//   final key = GlobalKey<FormState>();
//   late RecordStatus status;
//   @override
//   void initState() {
//     super.initState();
//     final x = widget.item;
//     status = x?.status ?? RecordStatus.active;
//     name = TextEditingController(text: x?.name);
//     email = TextEditingController(text: x?.email);
//     phone = TextEditingController(text: x?.phone);
//     specialty = TextEditingController(text: x?.specialty);
//   }

//   @override
//   void dispose() {
//     name.dispose();
//     email.dispose();
//     phone.dispose();
//     specialty.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => AlertDialog(
//     title: Text(widget.item == null ? 'إضافة مدرس' : 'تعديل مدرس'),
//     content: SizedBox(
//       width: 560,
//       child: Form(
//         key: key,
//         child: Wrap(
//           spacing: 12,
//           runSpacing: 8,
//           children: [
//             _f(name, 'الاسم'),
//             _f(email, 'البريد الإلكتروني', type: TextInputType.emailAddress),
//             _f(phone, 'الهاتف'),
//             _f(specialty, 'التخصص'),
//             SizedBox(
//               width: 270,
//               child: DropdownButtonFormField<RecordStatus>(
//                 initialValue: status,
//                 decoration: const InputDecoration(labelText: 'الحالة'),
//                 items: const [
//                   DropdownMenuItem(
//                     value: RecordStatus.active,
//                     child: Text('نشط'),
//                   ),
//                   DropdownMenuItem(
//                     value: RecordStatus.inactive,
//                     child: Text('غير نشط'),
//                   ),
//                 ],
//                 onChanged: (v) =>
//                     setState(() => status = v ?? RecordStatus.active),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     actions: [
//       TextButton(
//         onPressed: () => Navigator.pop(context),
//         child: const Text('إلغاء'),
//       ),
//       FilledButton(onPressed: _save, child: const Text('حفظ')),
//     ],
//   );
//   Widget _f(TextEditingController x, String label, {TextInputType? type}) =>
//       SizedBox(
//         width: 270,
//         child: TextFormField(
//           controller: x,
//           keyboardType: type,
//           decoration: InputDecoration(labelText: label),
//           validator: (v) =>
//               v == null || v.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
//         ),
//       );
//   void _save() {
//     if (!key.currentState!.validate()) return;
//     final x = widget.item;
//     context.read<TeachersCubit>().save(
//       Teacher(
//         id: x?.id ?? 't${DateTime.now().microsecondsSinceEpoch}',
//         name: name.text,
//         email: email.text,
//         phone: phone.text,
//         specialty: specialty.text,
//         status: status,
//         groups: x?.groups ?? 0,
//       ),
//     );
//     Navigator.pop(context, true);
//   }
// }

Future<void> showGroupDialog(BuildContext context, {Group? item}) async {
  final saved = await showDialog<bool>(
    context: context,
    builder: (_) => GroupDialog(item: item),
  );
  if (saved == true && context.mounted)
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم حفظ المجموعة بنجاح')));
}

class GroupDialog extends StatefulWidget {
  const GroupDialog({this.item, super.key});
  final Group? item;
  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  late final Map<String, TextEditingController> c;
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    final x = widget.item;
    c = {
      'name': TextEditingController(text: x?.name),
      'subject': TextEditingController(text: x?.subject),
      'teacher': TextEditingController(text: x?.teacher),
      'room': TextEditingController(text: x?.room),
      'schedule': TextEditingController(text: x?.schedule),
      'capacity': TextEditingController(text: x?.capacity.toString()),
      'fee': TextEditingController(text: x?.fee.toString()),
    };
  }

  @override
  void dispose() {
    for (final x in c.values) x.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.item == null ? 'إضافة مجموعة' : 'تعديل مجموعة'),
    content: SizedBox(
      width: 590,
      child: Form(
        key: key,
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          children: c.entries
              .map(
                (e) => SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: e.value,
                    keyboardType: ['capacity', 'fee'].contains(e.key)
                        ? TextInputType.number
                        : null,
                    decoration: InputDecoration(
                      labelText: {
                        'name': 'اسم المجموعة',
                        'subject': 'المادة',
                        'teacher': 'المدرس',
                        'room': 'القاعة',
                        'schedule': 'الجدول',
                        'capacity': 'الحد الأقصى',
                        'fee': 'الرسوم الشهرية',
                      }[e.key],
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      FilledButton(onPressed: _save, child: const Text('حفظ')),
    ],
  );
  void _save() {
    if (!key.currentState!.validate()) return;
    final x = widget.item;
    context.read<GroupsCubit>().save(
      Group(
        id: x?.id ?? 'g${DateTime.now().microsecondsSinceEpoch}',
        name: c['name']!.text,
        subject: c['subject']!.text,
        teacher: c['teacher']!.text,
        room: c['room']!.text,
        schedule: c['schedule']!.text,
        capacity: int.tryParse(c['capacity']!.text) ?? 0,
        fee: double.tryParse(c['fee']!.text) ?? 0,
        students: x?.students ?? 0,
      ),
    );
    Navigator.pop(context, true);
  }
}

Future<void> showPaymentDialog(BuildContext context, {Payment? item}) async {
  final saved = await showDialog<bool>(
    context: context,
    builder: (_) => PaymentDialog(item: item),
  );
  if (saved == true && context.mounted)
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم تسجيل الدفعة بنجاح')));
}

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({this.item, super.key});
  final Payment? item;
  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late final Map<String, TextEditingController> c;
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    final x = widget.item;
    c = {
      'student': TextEditingController(text: x?.student),
      'month': TextEditingController(text: x?.month ?? 'سبتمبر 2026'),
      'required': TextEditingController(text: x?.requiredAmount.toString()),
      'paid': TextEditingController(text: x?.paidAmount.toString()),
      'method': TextEditingController(text: x?.method ?? 'نقدي'),
      'date': TextEditingController(text: x?.date ?? '27/09/2026'),
      'notes': TextEditingController(text: x?.notes),
    };
  }

  @override
  void dispose() {
    for (final x in c.values) x.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('تسجيل دفعة'),
    content: SizedBox(
      width: 590,
      child: Form(
        key: key,
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          children: c.entries
              .map(
                (e) => SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: e.value,
                    keyboardType: ['required', 'paid'].contains(e.key)
                        ? TextInputType.number
                        : null,
                    decoration: InputDecoration(
                      labelText: {
                        'student': 'الطالب',
                        'month': 'الشهر',
                        'required': 'المبلغ المطلوب',
                        'paid': 'المبلغ المدفوع',
                        'method': 'طريقة الدفع',
                        'date': 'تاريخ الدفع',
                        'notes': 'ملاحظات',
                      }[e.key],
                    ),
                    validator: e.key == 'notes'
                        ? null
                        : (v) =>
                              v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      FilledButton(onPressed: _save, child: const Text('حفظ')),
    ],
  );
  void _save() {
    if (!key.currentState!.validate()) return;
    final x = widget.item;
    context.read<PaymentsCubit>().save(
      Payment(
        id: x?.id ?? 'p${DateTime.now().microsecondsSinceEpoch}',
        studentId: x?.studentId ?? '',
        student: c['student']!.text,
        month: c['month']!.text,
        requiredAmount: double.tryParse(c['required']!.text) ?? 0,
        paidAmount: double.tryParse(c['paid']!.text) ?? 0,
        method: c['method']!.text,
        date: c['date']!.text,
        notes: c['notes']!.text,
      ),
    );
    Navigator.pop(context, true);
  }
}

Future<void> showAcademyDialog(BuildContext context) async {
  final saved = await showDialog<bool>(
    context: context,
    builder: (_) => const AcademyDialog(),
  );
  if (saved == true && context.mounted)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ إعدادات الأكاديمية')));
}

class AcademyDialog extends StatefulWidget {
  const AcademyDialog({super.key});
  @override
  State<AcademyDialog> createState() => _AcademyDialogState();
}

class _AcademyDialogState extends State<AcademyDialog> {
  late final Map<String, TextEditingController> c;
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    final x = context.read<AcademyCubit>().state.data;
    c = {
      for (final k in [
        'name',
        'logo',
        'phone',
        'email',
        'address',
        'manager',
        'description',
      ])
        k: TextEditingController(text: x[k]),
    };
  }

  @override
  void dispose() {
    for (final x in c.values) x.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('إعدادات الأكاديمية'),
    content: SizedBox(
      width: 570,
      child: Form(
        key: key,
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          children: c.entries
              .map(
                (e) => SizedBox(
                  width: e.key == 'description' ? 552 : 270,
                  child: TextFormField(
                    controller: e.value,
                    maxLines: e.key == 'description' ? 3 : 1,
                    decoration: InputDecoration(
                      labelText: {
                        'name': 'اسم الأكاديمية',
                        'logo': 'الشعار',
                        'phone': 'الهاتف',
                        'email': 'البريد الإلكتروني',
                        'address': 'العنوان',
                        'manager': 'المدير',
                        'description': 'الوصف',
                      }[e.key],
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      FilledButton(
        onPressed: () {
          if (!key.currentState!.validate()) return;
          context.read<AcademyCubit>().save({
            for (final e in c.entries) e.key: e.value.text,
          });
          Navigator.pop(context, true);
        },
        child: const Text('حفظ'),
      ),
    ],
  );
}
