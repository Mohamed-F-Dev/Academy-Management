import 'package:flutter/material.dart';

/// ===============================================================
/// TOOLBAR
/// ===============================================================

class StudentsToolbar extends StatefulWidget {
  const StudentsToolbar({
    super.key,
    required this.onSearch,
    required this.onFilter,
  });

  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFilter;

  @override
  State<StudentsToolbar> createState() => StudentsToolbarState();
}

class StudentsToolbarState extends State<StudentsToolbar> {
  String selectedFilter = 'الكل';

  static const Color primary = Color(0xFF247C72);
  static const Color border = Color(0xFFE9E4DC);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 850;

          if (mobile) {
            return Column(
              children: [
                _buildSearch(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildFilters(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildAdvancedFilter(),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 4, child: _buildSearch()),
              const SizedBox(width: 16),
              _buildFilters(),
              const Spacer(),
              _buildAdvancedFilter(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearch() {
    return SizedBox(
      height: 42,
      child: TextField(
        onChanged: widget.onSearch,
        decoration: InputDecoration(
          hintText: 'ابحث بالاسم أو كودالطالب أو الهاتف...',
          hintStyle: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 12),
          prefixIcon: const Icon(
            Icons.search,
            size: 19,
            color: Color(0xFF71808C),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: primary),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    const filters = ['الكل', 'نشط', 'غير نشط'];

    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3EF),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: filters.map((filter) {
          final selected = selectedFilter == filter;

          return InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });

              widget.onFilter(filter);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? const Color(0xFF2B3943)
                      : const Color(0xFF777777),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdvancedFilter() {
    return OutlinedButton.icon(
      onPressed: () {
        // Add your advanced filter dialog here.
      },
      icon: const Icon(Icons.filter_alt_outlined, size: 18),
      label: const Text('تصفية متقدمة', style: TextStyle(fontSize: 11)),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF40515C),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }
}
