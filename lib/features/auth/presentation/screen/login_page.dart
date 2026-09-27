import 'package:academy_management_system/core/common/logo.dart';
import 'package:academy_management_system/core/config/business_config.dart';
import 'package:academy_management_system/core/layout/app_responsive.dart';
import 'package:academy_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:academy_management_system/features/auth/presentation/widget/brand_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController(text: 'admin@academy.com');
  final password = TextEditingController(text: 'admin123');
  final formKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  LoginRole selectedRole = LoginRole.admin;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F4EB),
        body: Responsive(
          builder: (context, type, constraints) {
            // Desktop
            if (type == .desktopLarge) {
              return const _DesktopLayoutWrapper();
            }

            // Tablet / Mobile
            return _MobileTabletLayout(
              form: _buildLoginForm(compact: constraints.maxWidth < 600),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm({bool compact = false}) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'حدث خطأ أثناء تسجيل الدخول'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Small heading
              Text(
                'تسجيل الدخول',
                style: TextStyle(
                  color: LoginColors.teal,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'أهلاً بك مرة أخرى',
                style: TextStyle(
                  color: LoginColors.navy,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'سجّل الدخول للوصول إلى مساحة العمل الخاصة بك.',
                style: TextStyle(
                  color: LoginColors.muted,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 28),

              // Roles
              _RoleSelector(
                selectedRole: selectedRole,
                onChanged: (role) {
                  setState(() => selectedRole = role);
                },
              ),

              const SizedBox(height: 25),

              // Email
              const _FieldLabel(text: 'البريد الإلكتروني', required: true),

              const SizedBox(height: 8),

              TextFormField(
                controller: username,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.right,
                decoration: _inputDecoration(hintText: 'admin@academy.com'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل البريد الإلكتروني';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 17),

              // Password
              const _FieldLabel(text: 'كلمة المرور', required: true),

              const SizedBox(height: 8),

              TextFormField(
                controller: password,
                obscureText: obscurePassword,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.right,
                decoration: _inputDecoration(
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => obscurePassword = !obscurePassword);
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: LoginColors.muted,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'كلمة المرور 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Login button
              SizedBox(
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: LoginColors.teal,
                    disabledBackgroundColor: LoginColors.teal.withValues(
                      alpha: .55,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: state.status == AuthStatus.loading ? null : _login,
                  child: state.status == AuthStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'دخول إلى مساحة العمل',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.arrow_back_ios_new_rounded, size: 13),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 22),

              // Demo box
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDE5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE3DED3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'ليس لديك حساب جاهز؟',
                      style: TextStyle(color: LoginColors.muted, fontSize: 11),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'استخدم البيانات التجريبية',
                      style: TextStyle(
                        color: LoginColors.teal,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selectedRole == LoginRole.admin
                          ? 'admin@academy.com  ·  admin123'
                          : 'teacher@academy.com  ·  teacher123',
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        color: LoginColors.muted,
                        fontSize: 9,
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _login() {
    if (!formKey.currentState!.validate()) return;

    context.read<AuthCubit>().login(username.text.trim(), password.text);
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9C9A94)),
      filled: true,
      fillColor: const Color(0xFFFBF8F1),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFDED9CF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: LoginColors.teal, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

// ==========================================================
// Desktop
// ==========================================================

class _DesktopLayoutWrapper extends StatelessWidget {
  const _DesktopLayoutWrapper();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_LoginPageState>();

    if (state == null) {
      return const SizedBox.shrink();
    }

    return Row(
      textDirection: TextDirection.ltr,
      children: [
        // LEFT - Login
        Expanded(
          flex: 48,
          child: Container(
            color: LoginColors.cream,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 550),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: state._buildLoginForm(),
                  ),
                ),
              ),
            ),
          ),
        ),

        // RIGHT - Branding
        const Expanded(flex: 52, child: BrandPanel()),
      ],
    );
  }
}

// ==========================================================
// Mobile + Tablet
// ==========================================================

class _MobileTabletLayout extends StatelessWidget {
  final Widget form;

  const _MobileTabletLayout({required this.form});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MobileLogo(),

                const SizedBox(height: 45),

                form,

                const SizedBox(height: 30),

                const Text(
                  'منصة إدارة الأكاديميات التعليمية',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: LoginColors.muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// Role selector
// ==========================================================

enum LoginRole { admin, teacher }

class _RoleSelector extends StatelessWidget {
  final LoginRole selectedRole;
  final ValueChanged<LoginRole> onChanged;

  const _RoleSelector({required this.selectedRole, required this.onChanged});

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

// ==========================================================
// Shared widgets
// ==========================================================

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;

  const _FieldLabel({required this.text, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: LoginColors.navy,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        if (required) ...[
          const SizedBox(width: 3),
          const Text(
            '*',
            style: TextStyle(
              color: Color(0xFFD44335),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
