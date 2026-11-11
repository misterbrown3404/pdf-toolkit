import 'package:flutter/material.dart';

class MergeDocThumbnail extends StatelessWidget {
  final String fileName;

  const MergeDocThumbnail({
    super.key,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final isCert = fileName.toLowerCase().contains('cert');

    return Container(
      width: 36,
      height: 46,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isCert ? _buildCertContent() : _buildStandardDocContent(),
    );
  }

  Widget _buildCertContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Color(0xFFFDE68A),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.star_rounded, size: 9, color: Color(0xFFD97706)),
          ),
        ),
        Container(
          width: 30,
          height: 2,
          color: const Color(0xFFE2E8F0),
        ),
      ],
    );
  }

  Widget _buildStandardDocContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 18,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF64748B),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        Container(width: 32, height: 2, color: const Color(0xFFE2E8F0)),
        Container(width: 28, height: 2, color: const Color(0xFFE2E8F0)),
        Container(width: 30, height: 2, color: const Color(0xFFE2E8F0)),
        Container(width: 20, height: 2, color: const Color(0xFFE2E8F0)),
      ],
    );
  }
}
