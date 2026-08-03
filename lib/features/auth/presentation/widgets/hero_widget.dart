/*Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 60),
      decoration: const BoxDecoration(
        color: HColors.secondary,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [HColors.primary, HColors.primary],
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: const FlutterLogo(size: 70),
          ),
          const SizedBox(height: HSizes.md),
          const Text(
            HTexts.appName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: HColors.primary,
            ),
          ),
          Text(
            HTexts.loginSubTitle,
            style: TextStyle(
              color: HColors.primary.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }*/

import 'package:flutter/material.dart';
import '../../../../utils/constants/color.dart';
import '../../../../utils/constants/text_strings.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Dark mode inverts the brand palette: an indigo block (a step lighter
    // than the near-black scaffold behind it) with cream/gold text, instead
    // of the light mode's cream block with indigo text.
    final blockColor = isDark ? HColors.primary : HColors.secondary;
    final accentColor = isDark ? HColors.accent : HColors.primary;
    final titleColor = isDark ? HColors.secondary : HColors.primary;
    final subtitleColor = (isDark ? HColors.secondary : HColors.primary)
        .withValues(alpha: 0.6);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 60),
      decoration: BoxDecoration(
        color: blockColor,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(80)),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [accentColor, accentColor],
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,

            //App Logo
            child: const FlutterLogo(size: 70),
          ),

          const SizedBox(height: 20),

          //App Name
          Text(
            HTexts.appName,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),

          //App SubTitle
          Text(
            HTexts.loginSubTitle,
            style: TextStyle(color: subtitleColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
