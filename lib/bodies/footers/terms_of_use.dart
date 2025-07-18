import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../commons/common_footer.dart';

class TermsOfUseBody extends StatelessWidget {
  final Color backgroundColor;

  const TermsOfUseBody({super.key, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'terms_of_use_header'.tr(),
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'terms_of_use_contents'.tr(),
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CommonFooterBase(backgroundColor: backgroundColor),
            ],
          ),
        ),
      ),
    );
  }
}
