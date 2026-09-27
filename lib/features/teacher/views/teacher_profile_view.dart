import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/cubit/teacher_cubit.dart';
import '../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../shared/widgets/management_widgets.dart';

class TeacherProfileView extends StatelessWidget {
  const TeacherProfileView({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<TeacherCubit, TeacherState>(
        builder: (context, state) => PageFrame(
          title: 'حسابي',
          subtitle: 'بياناتك الشخصية والمجموعات المسندة إليك',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Color(0xFFF7DDD3),
                        child: Text('أح', style: TextStyle(color: Color(0xFF287A78), fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 5),
                            Text(state.specialty, style: const TextStyle(color: Color(0xFF8B8D8A), fontSize: 11)),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/teacher/profile/edit'),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('تعديل البيانات'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Wrap(
                    spacing: 60,
                    runSpacing: 20,
                    children: [
                      _ProfileData(label: 'الهاتف', value: state.phone),
                      _ProfileData(label: 'البريد الإلكتروني', value: state.email),
                      _ProfileData(label: 'المواد', value: state.specialty),
                      _ProfileData(label: 'المجموعات', value: '${state.groups.length} مجموعات'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  context.go('/login');
                },
                icon: const Icon(Icons.logout_outlined),
                label: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        ),
      );
}

class _ProfileData extends StatelessWidget {
  const _ProfileData({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF8B8D8A), fontSize: 10)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}