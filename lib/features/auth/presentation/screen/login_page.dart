import 'package:academy_management_system/core/common/custom_textfield.dart';
import 'package:academy_management_system/core/common/logo.dart';
import 'package:academy_management_system/core/config/business_config.dart';
import 'package:academy_management_system/core/layout/app_responsive.dart';
import 'package:academy_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:academy_management_system/features/auth/presentation/widget/brand_panel.dart';
import 'package:academy_management_system/features/auth/presentation/widget/role_selector.dart';
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
  ValueNotifier<LoginRole> selectedRole = ValueNotifier(LoginRole.admin);

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
              ValueListenableBuilder(
                valueListenable: selectedRole,
                builder: (context, value, child) {
                  return RoleSelector(
                    selectedRole: value,
                    onChanged: (role) {
                      selectedRole.value = role;
                    },
                  );
                },
              ),

              const SizedBox(height: 25),

              // Email
              ValueListenableBuilder(
                valueListenable: selectedRole,
                builder: (context, value, child) {
                  if (value == LoginRole.admin) {
                    return _textforms();
                  } else {
                    return _teacherCode();
                  }
                },
              ),
              const SizedBox(height: 8),

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

  //teacher
  Widget _teacherCode() {
    return Column(
      children: [
        const FieldLabel(text: 'الكود', required: true),

        const SizedBox(height: 8),
        CustomTextField(
          controller: username,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,

          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'أدخل البريد الإلكتروني';
            }
            return null;
          },
        ),
      ],
    );
  }

  //admain
  Widget _textforms() {
    return Column(
      children: [
        const FieldLabel(text: 'البريد الإلكتروني', required: true),

        const SizedBox(height: 8),
        CustomTextField(
          controller: username,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,

          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'أدخل البريد الإلكتروني';
            }
            return null;
          },
        ),

        const SizedBox(height: 17),

        // Password
        const FieldLabel(text: 'كلمة المرور', required: true),

        const SizedBox(height: 8),
        CustomTextField(
          controller: password,
          obscureText: true,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right,
          hint: "••••••••",

          validator: (value) {
            if (value == null || value.length < 6) {
              return 'كلمة المرور 6 أحرف على الأقل';
            }
            return null;
          },
        ),
      ],
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
// Shared widgets
// ==========================================================

class FieldLabel extends StatelessWidget {
  final String text;
  final bool required;

  const FieldLabel({super.key, required this.text, this.required = false});

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
