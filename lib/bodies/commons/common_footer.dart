import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonFooterBase extends StatelessWidget {
  final Color backgroundColor;

  const CommonFooterBase({
    super.key,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.linkedin),
                color: Colors.white,
                iconSize: 20,
                tooltip: 'LinkedIn',
                onPressed: () async {
                  const url = 'https://www.linkedin.com/in/minsu-seo-6b77a3112/';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  }
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
                color: Colors.white,
                iconSize: 20,
                tooltip: 'Email',
                onPressed: () async {
                  const email = 'mailto:lullulalal@gmail.com';
                  if (await canLaunchUrl(Uri.parse(email))) {
                    await launchUrl(Uri.parse(email));
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '© 2025 MyFitnessRank. All rights reserved.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              textStyle: const TextStyle(fontSize: 14, color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }
}
