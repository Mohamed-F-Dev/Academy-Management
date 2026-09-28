import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../models/entities.dart';

/// Standard page scaffold: title, subtitle, optional action and animated body.
class PageFrame extends StatelessWidget {
  const PageFrame({
    required this.title,
    required this.subtitle,
    required this.child,
    this.action,
    super.key,
  });
  final String title, subtitle;
  final Widget child;
  final Widget? action;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeOutCubic,
    builder: (context, value, _) => Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, (1 - value) * 8),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 26, 28, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.ink,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (action != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 2, 0),
                      child: action!,
                    ),
                ],
              ),
              const SizedBox(height: 26),
              child,
            ],
          ),
        ),
      ),
    ),
  );
}

/// Search field + optional filter chips for list pages.
class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    required this.onChanged,
    this.filters = const [],
    this.onFilter,
    this.hint = 'ابحث بالاسم أو رقم الهاتف...',
    super.key,
  });
  final ValueChanged<String> onChanged;
  final List<String> filters;
  final ValueChanged<String>? onFilter;
  final String hint;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Wrap(
      spacing: 14,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            onChanged: onChanged,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12.5,
                color: AppTheme.subtle,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 18,
                color: AppTheme.muted,
              ),
            ),
          ),
        ),
        if (filters.isNotEmpty)
          ...filters.map(
            (filter) => ChoiceChip(
              label: Text(
                filter,
                style: const TextStyle(fontSize: 12.5, color: AppTheme.body),
              ),
              selected: false,
              onSelected: (_) => onFilter?.call(filter),
            ),
          ),
      ],
    ),
  );
}

/// Pill-style status indicator with a colored dot.
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});
  final RecordStatus status;
  @override
  Widget build(BuildContext context) {
    final (label, color, soft) = switch (status) {
      RecordStatus.active => ('نشط', AppTheme.success, AppTheme.successSoft),
      RecordStatus.present => ('حاضر', AppTheme.success, AppTheme.successSoft),
      RecordStatus.paid => ('مدفوع', AppTheme.success, AppTheme.successSoft),
      RecordStatus.inactive => ('غير نشط', AppTheme.muted, AppTheme.hover),
      RecordStatus.partial => ('جزئي', AppTheme.warning, AppTheme.warningSoft),
      RecordStatus.pending => ('قادم', AppTheme.info, AppTheme.infoSoft),
      RecordStatus.absent => ('غائب', AppTheme.danger, AppTheme.dangerSoft),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// KPI metric card with icon tile, headline value and optional trend caption.
class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.caption,
    super.key,
  });
  final String title, value;
  final IconData icon;
  final Color color;
  final String? caption;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, color: color, size: 21)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
                const SizedBox(height: 6),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ink,
                    height: 1.2,
                  ),
                ),
                if (caption != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 13,
                          color: AppTheme.success,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          caption!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.success,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Friendly empty state with a soft icon tile.
class EmptyState extends StatelessWidget {
  const EmptyState({this.message = 'لا توجد نتائج', super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(44),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.hover,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Center(
              child: Icon(
                Icons.inbox_outlined,
                size: 28,
                color: AppTheme.muted,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.body,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'لا توجد بيانات لعرضها حالياً',
            style: TextStyle(fontSize: 12.5, color: AppTheme.subtle),
          ),
        ],
      ),
    ),
  );
}

/// Card with a standardized section header (title + optional subtitle/action).
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    super.key,
  });
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(fontSize: 12, color: AppTheme.muted),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );
}

/// Export / print actions used across tables.
class ExportActions extends StatelessWidget {
  const ExportActions({super.key});
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 10,
    children: [
      OutlinedButton.icon(
        onPressed: () => _simulate(context, 'PDF'),
        icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
        label: const Text('تصدير PDF'),
      ),
      OutlinedButton.icon(
        onPressed: () => _simulate(context, 'Excel'),
        icon: const Icon(Icons.table_view_outlined, size: 16),
        label: const Text('تصدير Excel'),
      ),
      IconButton(
        onPressed: () => _simulate(context, 'الطباعة'),
        icon: const Icon(Icons.print_outlined),
        tooltip: 'طباعة',
      ),
    ],
  );
  void _simulate(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تصدير $type'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري تجهيز الملف...'),
          ],
        ),
      ),
    ).then((_) {});
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تجهيز ملف $type بنجاح (تجريبي)')),
        );
      }
    });
  }
}
