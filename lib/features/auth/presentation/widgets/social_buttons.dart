import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_role_flutter_auth/utils/constants/color.dart';
import 'package:multi_role_flutter_auth/utils/constants/sizes.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({
    super.key,
    required this.onGoogleTap,
    required this.onFacebookTap,
    required this.onGithubTap,
    required this.onGuestTap,
  });

  final VoidCallback onGoogleTap;
  final VoidCallback onFacebookTap;
  final VoidCallback onGithubTap;
  final VoidCallback onGuestTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? HColors.accent : HColors.primary;
    // GitHub's brand color is black, which disappears against a dark
    // background — flip it to the light color in dark mode.
    final githubColor = isDark ? HColors.light : HColors.black;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.2) : HColors.grey.withValues(alpha: 0.5);

    return Column(
      children: [
        /// Divider
        Row(
          children: [
            const Expanded(child: Divider(thickness: 0.8)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: HSizes.md),
              child: Text(
                "Or join with",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const Expanded(child: Divider(thickness: 0.8)),
          ],
        ),

        const SizedBox(height: HSizes.spaceBtwSections),

        /// Icons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIconButton(
              icon: FontAwesomeIcons.google,
              color: const Color(0xFFDB4437),
              borderColor: borderColor,
              onTap: onGoogleTap,
            ),
            const SizedBox(width: HSizes.spaceBtwItems),

            _socialIconButton(
              icon: FontAwesomeIcons.facebook,
              color: const Color(0xFF1877F2),
              borderColor: borderColor,
              onTap: onFacebookTap,
            ),
            const SizedBox(width: HSizes.spaceBtwItems),

            _socialIconButton(
              icon: FontAwesomeIcons.github,
              color: githubColor,
              borderColor: borderColor,
              onTap: onGithubTap,
            ),
            const SizedBox(width: HSizes.spaceBtwItems),

            _socialIconButton(
              icon: FontAwesomeIcons.solidCircleUser,
              color: accentColor,
              borderColor: borderColor,
              onTap: onGuestTap,
              isGuest: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialIconButton({
    required IconData icon,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
    bool isGuest = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.all(HSizes.md),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
          // Very light background for the guest button to make it pop
          color: isGuest ? color.withValues(alpha: 0.08) : Colors.transparent,
        ),
        child: FaIcon(icon, color: color, size: HSizes.iconMd),
      ),
    );
  }
}