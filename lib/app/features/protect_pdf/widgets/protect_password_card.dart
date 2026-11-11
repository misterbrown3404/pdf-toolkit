import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../models/password_strength_model.dart';
import '../models/protect_mode_enum.dart';

class ProtectPasswordCard extends StatelessWidget {
  final ProtectMode mode;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final PasswordStrengthModel strength;
  final bool passwordsMatch;
  final Function(String) onPasswordChanged;
  final Function(String) onConfirmPasswordChanged;

  const ProtectPasswordCard({
    super.key,
    required this.mode,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordObscured,
    required this.isConfirmPasswordObscured,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.strength,
    required this.passwordsMatch,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isProtect = mode == ProtectMode.protect;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.vpn_key_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isProtect ? 'Set Password' : 'Enter Password to Decrypt',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Primary Password Field
          _buildTextField(
            context: context,
            controller: passwordController,
            hintText: isProtect ? 'Enter new password' : 'Enter document password',
            isObscured: isPasswordObscured,
            onToggleVisibility: onTogglePasswordVisibility,
            onChanged: onPasswordChanged,
            isDark: isDark,
          ),

          if (isProtect) ...[
            const SizedBox(height: 10),

            // Password Strength Indicator Bar & Label
            if (passwordController.text.isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(3, (index) {
                        final isFilled = index < strength.score;
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
                            decoration: BoxDecoration(
                              color: isFilled
                                  ? strength.color
                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    strength.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: strength.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            // Confirm Password Label
            Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 6),

            // Confirm Password Field
            _buildTextField(
              context: context,
              controller: confirmPasswordController,
              hintText: 'Re-enter your password',
              isObscured: isConfirmPasswordObscured,
              onToggleVisibility: onToggleConfirmPasswordVisibility,
              onChanged: onConfirmPasswordChanged,
              isDark: isDark,
            ),

            // Matching indicator badge
            if (confirmPasswordController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    passwordsMatch ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: 15,
                    color: passwordsMatch ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    passwordsMatch ? 'Passwords match' : 'Passwords do not match',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: passwordsMatch
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
    required Function(String) onChanged,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscured,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 13,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.lock_rounded,
            size: 18,
            color: Color(0xFF94A3B8),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              size: 20,
              color: const Color(0xFF94A3B8),
            ),
            onPressed: onToggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}
