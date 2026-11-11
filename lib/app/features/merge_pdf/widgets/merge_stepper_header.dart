import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class MergeStepperHeader extends StatelessWidget {
  final int fileCount;
  final bool isMerging;

  const MergeStepperHeader({
    super.key,
    required this.fileCount,
    this.isMerging = false,
  });

  @override
  Widget build(BuildContext context) {
    final step1Done = fileCount >= 2;
    final step2Active = fileCount >= 2 && !isMerging;
    final step3Active = isMerging;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              // Step 1 Circle
              _buildStepCircle(
                isDone: step1Done,
                isActive: fileCount < 2,
                label: '1',
              ),

              // Connecting Line 1-2
              Expanded(
                child: Container(
                  height: 2.5,
                  color: step1Done ? AppColors.primary : const Color(0xFFE2E8F0),
                ),
              ),

              // Step 2 Circle
              _buildStepCircle(
                isDone: step3Active,
                isActive: step2Active,
                label: '2',
              ),

              // Connecting Line 2-3
              Expanded(
                child: Container(
                  height: 2.5,
                  color: step3Active ? AppColors.primary : const Color(0xFFE2E8F0),
                ),
              ),

              // Step 3 Circle
              _buildStepCircle(
                isDone: false,
                isActive: step3Active,
                label: '3',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Files',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: step1Done ? AppColors.primary : const Color(0xFF64748B),
                ),
              ),
              Text(
                'Reorder',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: step2Active ? AppColors.primary : const Color(0xFF64748B),
                ),
              ),
              Text(
                'Merge',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: step3Active ? AppColors.primary : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle({
    required bool isDone,
    required bool isActive,
    required String label,
  }) {
    if (isDone) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.check_rounded, color: Colors.white, size: 16),
        ),
      );
    }

    if (isActive) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFFE2E8F0),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

