import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../footer/privacy_policy.dart';
import '../footer/terms_of_use.dart';
import '../footer/cookie_preferences.dart';

class RunningContentsBody extends StatelessWidget {
  final void Function(Widget) onFooterPageSelected;

  const RunningContentsBody({
    super.key,
    required this.onFooterPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    Widget footerLink(String label, VoidCallback onTap) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            label,
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            // Section 1
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'introduce_header'.tr(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'introduce_contents'.tr(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Section 2
            const SizedBox(height: 35),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 32,
                        children: [
                          Text(
                            'explain_header'.tr(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Section 3
            Container(
              width: double.infinity,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language, size: 20, color: Colors.black54),
                      const SizedBox(width: 8),
                      DropdownButton<Locale>(
                        value: context.locale,
                        underline: const SizedBox(),
                        focusColor: Colors.transparent,
                        items: const [
                          DropdownMenuItem(value: Locale('en'), child: Text('English')),
                          DropdownMenuItem(value: Locale('ko'), child: Text('한국어')),
                        ],
                        onChanged: (locale) {
                          if (locale != null) {
                            context.setLocale(locale);
                          }
                        },
                      ),
                    ],
                  ),
                  Text(
                    '© 2025 MyFitnessRank. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 24,
                    children: [
                      footerLink('privacy_policy_header'.tr(), () {
                        onFooterPageSelected(const PrivacyPolicyBody());
                      }),
                      footerLink('terms_of_use_header'.tr(), () {
                        onFooterPageSelected(const TermsOfUseBody());
                      }),
                      footerLink('cookie_preferences_header'.tr(), () {
                        onFooterPageSelected(const CookiePreferencesBody());
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
