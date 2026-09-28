import 'package:academy_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/business_config.dart';

class RoleSelector extends StatelessWidget {
  final LoginRole selectedRole;
  final ValueChanged<LoginRole> onChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleButton(
            text: 'مدرس',
            icon: Icons.menu_book_outlined,
            selected: selectedRole == LoginRole.teacher,
            onTap: () => onChanged(LoginRole.teacher),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _RoleButton(
            text: 'مدير الأكاديمية',
            icon: Icons.shield_outlined,
            selected: selectedRole == LoginRole.admin,
            onTap: () => onChanged(LoginRole.admin),
          ),
        ),
      ],
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.text,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFDCEDEA) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? const Color(0xFF8BC6BF)
                  : const Color(0xFFDCD7CD),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? LoginColors.teal : LoginColors.muted,
              ),

              const SizedBox(width: 8),

              Text(
                text,
                style: TextStyle(
                  color: selected ? LoginColors.teal : LoginColors.muted,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
