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
import 'package:multi_role_flutter_auth/utils/constants/color.dart';
import 'package:multi_role_flutter_auth/utils/constants/text_strings.dart';
import 'package:multi_role_flutter_auth/utils/theme/widget_theme/text_theme.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              colors: [HColors.primary ,  HColors.primary],
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,

            //App Logo
            child: const FlutterLogo(size: 70),
          ),

          const SizedBox(height: 20),

          //App Name
          Text(
            HTexts.appName,
            style: HTextTheme.lightTextTheme.headlineLarge?.copyWith(
             fontWeight: FontWeight.w800,
            ),),

          //App SubTitle
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
  }
}
