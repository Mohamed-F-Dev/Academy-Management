import 'package:academy_management_system/core/config/business_config.dart';
import 'package:academy_management_system/core/theme/app_colors.dart';
import 'package:academy_management_system/core/theme/apptypography.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final String? dufultlabel;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final int? maxLength;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final TextDirection? textDirection;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.dufultlabel,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLength,
    this.readOnly = false,
    this.textInputAction,
    this.textAlign = .start,
    this.textDirection,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isShowPassWord = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          textInputAction: widget.textInputAction,
          readOnly: widget.readOnly,
          maxLength: widget.maxLength,
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted,
          controller: widget.controller,
          obscureText: widget.obscureText && !isShowPassWord,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,

          keyboardType: widget.keyboardType,
          validator: widget.validator,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),

          decoration: InputDecoration(
            hintText: widget.hint,
            isDense: true,

            labelStyle: AppTypography.h6.copyWith(
              color: Colors.black.withValues(alpha: 0.6),
            ),
            errorStyle: AppTypography.h6.copyWith(color: Colors.red),
            labelText: widget.label,
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: buildSuffixIcon(),
            filled: true,
            fillColor: AppColors.surface,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.6),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSuffixIcon() {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon!;
    } else if (widget.obscureText) {
      return IconButton(
        onPressed: () {
          isShowPassWord = !isShowPassWord;
          setState(() {});
        },
        icon: isShowPassWord
            ? const Icon(Icons.visibility_rounded)
            : const Icon(Icons.visibility_off_outlined),
        color: AppColors.textSecondary,
      );
    }
    return const SizedBox.shrink();
  }
}

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
