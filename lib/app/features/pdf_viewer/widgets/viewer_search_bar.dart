import 'package:flutter/material.dart';

class ViewerSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final int matchCount;
  final int currentMatchIndex;
  final Function(String) onSearchChanged;
  final VoidCallback onNextMatch;
  final VoidCallback onPrevMatch;
  final VoidCallback onClose;

  const ViewerSearchBar({
    super.key,
    required this.searchController,
    required this.matchCount,
    required this.currentMatchIndex,
    required this.onSearchChanged,
    required this.onNextMatch,
    required this.onPrevMatch,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 20, color: Color(0xFF94A3B8)),
          const SizedBox(width: 8),

          // Input Field
          Expanded(
            child: TextField(
              controller: searchController,
              autofocus: true,
              onChanged: onSearchChanged,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: const InputDecoration(
                hintText: 'Search in document...',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),

          // Match Count Badge
          if (searchController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: matchCount > 0 ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                matchCount > 0 ? '${currentMatchIndex + 1}/$matchCount' : '0 found',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: matchCount > 0 ? const Color(0xFF15803D) : const Color(0xFF64748B),
                ),
              ),
            ),

          // Navigation buttons
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: matchCount > 0 ? onPrevMatch : null,
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: matchCount > 0 ? onNextMatch : null,
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            color: const Color(0xFF94A3B8),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
