import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/management_dialogs.dart';
import '../../../../shared/widgets/management_widgets.dart';
import '../../../academy/presentation/cubit/academy_cubit.dart';
import '../cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'الإعدادات',
    subtitle: 'إدارة بيانات الأكاديمية وتفضيلات النظام',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: BlocBuilder<AcademyCubit, AcademyState>(
              builder: (context, state) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'بيانات الأكاديمية',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'هذه البيانات تظهر في التقارير والإيصالات',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(Icons.school, color: Colors.blue),
                    ),
                    title: Text(
                      state.data['name'] ?? 'أكاديمية بلس',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${state.data['phone'] ?? ''} • ${state.data['email'] ?? ''}\n${state.data['address'] ?? ''}',
                    ),
                    trailing: OutlinedButton.icon(
                      onPressed: () => showAcademyDialog(context),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('تعديل'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تفضيلات النظام',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const SwitchListTile(
                  value: true,
                  onChanged: null,
                  title: Text('التنبيهات اليومية'),
                  subtitle: Text('إشعارات الحضور والمدفوعات المتأخرة'),
                ),
                const SwitchListTile(
                  value: true,
                  onChanged: null,
                  title: Text('الواجهة العربية'),
                  subtitle: Text('استخدام العربية واتجاه RTL'),
                ),
                BlocConsumer<SettingsCubit, SettingsState>(
                  listener: (context, state) {
                    if (state.saved)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حفظ التفضيلات')),
                      );
                  },
                  builder: (context, state) => Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      onPressed: state.loading
                          ? null
                          : () => context.read<SettingsCubit>().save(),
                      child: Text(
                        state.loading ? 'جارٍ الحفظ...' : 'حفظ التفضيلات',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
