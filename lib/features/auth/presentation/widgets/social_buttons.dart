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
              onTap: onGoogleTap
            ),
            const SizedBox(width: HSizes.spaceBtwItems),
            
            _socialIconButton(
              icon: FontAwesomeIcons.facebook, 
              color: const Color(0xFF1877F2), 
              onTap: onFacebookTap
            ),
            const SizedBox(width: HSizes.spaceBtwItems),
            
            _socialIconButton(
              icon: FontAwesomeIcons.github, 
              color: HColors.black, 
              onTap: onGithubTap
            ),
            const SizedBox(width: HSizes.spaceBtwItems),

            _socialIconButton(
              icon: FontAwesomeIcons.solidCircleUser,
              color: HColors.primary, 
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
          border: Border.all(color: HColors.grey.withOpacity(0.5)),
          // Very light background for the guest button to make it pop
          color: isGuest ? HColors.primary.withOpacity(0.05) : Colors.transparent,
        ),
        child: FaIcon(icon, color: color, size: HSizes.iconMd),
      ),
    );
  }
}