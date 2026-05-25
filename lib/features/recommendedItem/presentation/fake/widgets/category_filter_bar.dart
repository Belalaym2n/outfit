import 'package:flutter/material.dart';

class CategoryFilterBar extends StatefulWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onChanged;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length + 1, // +1 for "All"
        itemBuilder: (context, i) {
          final isAll = i == 0;
          final label = isAll ? 'All' : widget.categories[i - 1];
          final active =
              (isAll && widget.selected == null) || label == widget.selected;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterChip(
              label: label,
              active: active,
              onTap: () => widget.onChanged(isAll ? null : label),
            ),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? const Color(0xFF2C2C2C)
                : const Color(0xFFE0DDD8),
          ),
        ),
        child: Text(
          _capitalize(label),
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : const Color(0xFF6B6560),
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
