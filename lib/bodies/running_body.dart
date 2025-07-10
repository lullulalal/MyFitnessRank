import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../footer/privacy_policy.dart';
import '../footer/terms_of_use.dart';
import '../footer/cookie_preferences.dart';

class RunningContentsBody extends StatefulWidget {
  final void Function(Widget) onFooterPageSelected;
  final Color appColor;

  const RunningContentsBody({
    super.key,
    required this.onFooterPageSelected,
    required this.appColor,
  });

  @override
  State<RunningContentsBody> createState() => _RunningContentsBodyState();
}

class _RunningContentsBodyState extends State<RunningContentsBody> {
  String selectedGender = 'Male';
  String selectedDistance = '5';

  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final List<String> allMarathons = [
    'London Marathon',
    'Boston Marathon',
    'Berlin Marathon',
    'Chicago Marathon',
    'NYC Marathon',
    'Tokyo Marathon',
  ];

  List<String> selectedMarathons = []; // default: all selected

  @override
  void initState() {
    super.initState();
    selectedMarathons = List.from(allMarathons); // all selected by default
  }

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
                color: Colors.white70,
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
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Image.asset(
                  'assets/images/main.jpg',
                  height: MediaQuery.of(context).size.height * 0.45,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Section 2
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
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
                        // Time Input
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: hourController,
                                decoration: InputDecoration(
                                  labelText: 'Hour',
                                  labelStyle: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: minuteController,
                                decoration: InputDecoration(
                                  labelText: 'Min',
                                  labelStyle: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: secondController,
                                decoration: InputDecoration(
                                  labelText: 'Sec',
                                  labelStyle: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Distance dropdown
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Distance:',
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            DropdownButton<String>(
                              value: selectedDistance,
                              onChanged: (value) {
                                setState(() {
                                  selectedDistance = value!;
                                });
                              },
                              items: [
                                DropdownMenuItem(
                                  value: '5',
                                  child: Text(
                                    '5 km',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: '10',
                                  child: Text(
                                    '10 km',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Half',
                                  child: Text(
                                    '21.1 km(Half)',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Full',
                                  child: Text(
                                    '42.2 km(Full)',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Gender selection
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Gender:',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Radio(
                                  value: 'Male',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                Text(
                                  'Male',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 'Female',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                Text(
                                  'Female',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Age input
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: ageController,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              labelStyle: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Marathon multi-select button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final result = await showDialog<List<String>>(
                              context: context,
                              builder: (context) {
                                List<String> tempSelection = List.from(
                                  selectedMarathons,
                                );

                                return StatefulBuilder(
                                  // 🛠 wraps dialog in its own state
                                  builder: (context, setLocalState) {
                                    return AlertDialog(
                                      title: Text(
                                        'Select Marathon(s) for Comparison',
                                        style: GoogleFonts.inter(
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: allMarathons.map((
                                            marathon,
                                          ) {
                                            return CheckboxListTile(
                                              value: tempSelection.contains(
                                                marathon,
                                              ),
                                              title: Text(marathon),
                                              onChanged: (checked) {
                                                setLocalState(() {
                                                  if (checked == true) {
                                                    tempSelection.add(marathon);
                                                  } else {
                                                    tempSelection.remove(
                                                      marathon,
                                                    );
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, null),
                                          child: Text(
                                            'Cancel',
                                            style: GoogleFonts.inter(
                                              textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(
                                            context,
                                            tempSelection,
                                          ),
                                          child: Text(
                                            'OK',
                                            style: GoogleFonts.inter(
                                              textStyle: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );

                            if (result != null) {
                              setState(() {
                                selectedMarathons = result;
                              });
                            }
                          },
                          child: Text(
                            selectedMarathons.isEmpty
                                ? 'Select Reference Marathon(s)'
                                : 'Reference Marathon(s): ${selectedMarathons.length}',
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Submit button
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Colors.grey[900]!;
                                  }
                                  return Colors.black;
                                }),
                            foregroundColor: WidgetStateProperty.all<Color>(
                              Colors.white,
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 18,
                              ),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      6,
                                    ),
                                  ),
                                ),
                          ),
                          onPressed: () {
                            final int hour =
                                int.tryParse(hourController.text) ?? 0;
                            final int minute =
                                int.tryParse(minuteController.text) ?? 0;
                            final int second =
                                int.tryParse(secondController.text) ?? 0;
                            final int age =
                                int.tryParse(ageController.text) ?? 0;
                            final int totalSeconds =
                                hour * 3600 + minute * 60 + second;

                            // TODO: Replace with GraphQL mutation logic
                            print('Submitting:');
                            print('Time: $totalSeconds seconds');
                            print('Gender: $selectedGender');
                            print('Age: $age');
                            print('Distance: $selectedDistance');
                          },
                          child: Text(
                            'Show My Running Rank!',
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Section 3
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ),
                ),
              ),
            ),

            // Section 3
            Container(
              width: double.infinity,
              color: widget.appColor,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.language,
                        size: 20,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<Locale>(
                        value: context.locale,
                        underline: const SizedBox(),
                        focusColor: Colors.transparent,
                        dropdownColor: Colors.black54,
                        items: const [
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text(
                              'English',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          DropdownMenuItem(
                            value: Locale('ko'),
                            child: Text(
                              '한국어',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                        onChanged: (locale) {
                          if (locale != null) {
                            context.setLocale(locale);
                          }
                        },
                      ),
                    ],
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.linkedin),
                        color: Colors.white,
                        iconSize: 20,
                        tooltip: 'LinkedIn',
                        onPressed: () async {
                          const url =
                              'https://www.linkedin.com/in/minsu-seo-6b77a3112/';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication,
                            );
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
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 24,
                    children: [
                      footerLink('privacy_policy_header'.tr(), () {
                        widget.onFooterPageSelected(const PrivacyPolicyBody());
                      }),
                      footerLink('terms_of_use_header'.tr(), () {
                        widget.onFooterPageSelected(const TermsOfUseBody());
                      }),
                      footerLink('cookie_preferences_header'.tr(), () {
                        widget.onFooterPageSelected(
                          const CookiePreferencesBody(),
                        );
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
