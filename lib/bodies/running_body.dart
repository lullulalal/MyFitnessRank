import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import 'footers/privacy_policy.dart';
import 'footers/terms_of_use.dart';
import 'footers/cookie_preferences.dart';
import './commons/histogram_chart.dart';

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
  String selectedGender = 'male';
  String displayedGender = 'male';
  String selectedDistance = '5';

  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Don't use right now, but keep it for future use
  final Map<String, List<Map<String, String>>> marathonOptions = {
    '5': [
      {'name': 'Gold Coast Marathon 5km', 'key': 'GCM5'},
    ],
    '10': [
      {'name': 'Gold Coast Marathon 10km', 'key': 'GCM10'},
    ],
    'half': [
      {'name': 'Gold Coast Half Marathon', 'key': 'GCHM'},
    ],
    'full': [
      {'name': 'Gold Coast Full Marathon', 'key': 'GCFM'},
    ],
  };

  List<String> selectedMarathonKeys = [];

  Map<String, dynamic>? responseData;

  @override
  void initState() {
    super.initState();

    final initialMarathons = marathonOptions[selectedDistance] ?? [];
    selectedMarathonKeys = initialMarathons.map((e) => e['key']!).toList();
  }

  @override
  Widget build(BuildContext context) {
    void showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'error_dialog_title'.tr(),
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.inter(
              textStyle: const TextStyle(fontSize: 17, color: Colors.black87),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ok'.tr(),
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    void handleSubmit() async {
      final int hour = int.tryParse(hourController.text) ?? 0;
      final int minute = int.tryParse(minuteController.text) ?? 0;
      final int second = int.tryParse(secondController.text) ?? 0;
      final int age = int.tryParse(ageController.text) ?? -1;
      final int totalSeconds = hour * 3600 + minute * 60 + second;

      if (totalSeconds == 0) {
        showErrorDialog('running_time_err_msg'.tr());
        return;
      }

      if (age < 0 || age > 100) {
        showErrorDialog('age_err_msg'.tr());
        return;
      }

      if (selectedMarathonKeys.isEmpty) {
        showErrorDialog('marathons_err_msg'.tr());
        return;
      }

      final Map<String, dynamic> requestBody = {
        'record_seconds': totalSeconds.toDouble(),
        'age': age,
        'gender': selectedGender, // 'male' or 'female'
        'distance': selectedDistance,
        'target_races': selectedMarathonKeys, // List<String>
      };

      try {
        final response = await http.post(
          Uri.parse(ApiConstants.running),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            responseData = data;
            displayedGender = selectedGender;
          });
        } else {
          print('Error: ${response.statusCode}');
          showErrorDialog('server_err_msg'.tr());
        }
      } catch (e) {
        print('Exception: $e');
        showErrorDialog('network_err_msg'.tr());
      }
    }

    Widget buildTitleWidget(String resultType) {
      final result = responseData![resultType];
      final double userPercentile = result['user_percentile'];
      final int ageStart = result['age_range_start'];
      final int ageEnd = result['age_range_end'];
      final rounded = userPercentile.round();

      final percentText = TextSpan(
        text: ' $rounded% ',
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.amber,
          ),
        ),
      );

      TextSpan fullText;
      if (resultType == 'overall') {
        fullText = TextSpan(
          children: [
            TextSpan(
              text: 'title_overall_left'.tr(),
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            percentText,
            TextSpan(
              text: 'title_overall_right'.tr(),
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      } else if (resultType == 'by_gender') {
        fullText = TextSpan(
          children: [
            TextSpan(
              text: 'title_by_gender_left'.tr(),
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            percentText,
            TextSpan(
              text:
                  '${'title_by_gender_middle'.tr()} ${displayedGender.tr()}${'title_by_gender_right'.tr()}',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      } else {
        fullText = TextSpan(
          children: [
            TextSpan(
              text: 'title_by_gender_age_left'.tr(),
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            percentText,
            TextSpan(
              text:
                  '${'title_by_gender_age_middle'.tr()} ${displayedGender.tr()}${'title_by_gender_age_middle2'.tr()} $ageStart–$ageEnd${'title_by_gender_age_right'.tr()}',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      }

      return RichText(text: fullText);
    }

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
              color: widget.appColor,
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
                                  labelText: 'hour'.tr(),
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
                                  labelText: 'minute'.tr(),
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
                                  labelText: 'second'.tr(),
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
                              'distance'.tr(),
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

                                  final newMarathons =
                                      marathonOptions[selectedDistance] ?? [];
                                  selectedMarathonKeys = newMarathons
                                      .map((e) => e['key']!)
                                      .toList();
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
                                  value: 'half',
                                  child: Text(
                                    'Half (21.098 km)',
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
                                  value: 'full',
                                  child: Text(
                                    'Full (42.195 km)',
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
                              'gender'.tr(),
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
                                  value: 'male',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                Text(
                                  'male'.tr(),
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
                                  value: 'female',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                Text(
                                  'female'.tr(),
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
                              labelText: 'age'.tr(),
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

                        // Don't use right now, but keep it for future use
                        // const SizedBox(height: 15),
                        // // Marathon multi-select button
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.white,
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 24,
                        //       vertical: 14,
                        //     ),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //   ),
                        //   onPressed: () async {
                        //     final List<Map<String, String>> availableMarathons =
                        //         marathonOptions[selectedDistance] ?? [];

                        //     final result = await showDialog<List<String>>(
                        //       context: context,
                        //       builder: (context) {
                        //         List<String> tempSelection = List.from(
                        //           selectedMarathonKeys,
                        //         );

                        //         return StatefulBuilder(
                        //           builder: (context, setLocalState) {
                        //             return AlertDialog(
                        //               title: Text(
                        //                 'marathons_selection_title'.tr(),
                        //                 style: GoogleFonts.inter(
                        //                   textStyle: const TextStyle(
                        //                     fontSize: 20,
                        //                     color: Colors.black87,
                        //                     fontWeight: FontWeight.w700,
                        //                   ),
                        //                 ),
                        //               ),
                        //               content: SingleChildScrollView(
                        //                 child: Column(
                        //                   children: availableMarathons.map((
                        //                     marathon,
                        //                   ) {
                        //                     final name = marathon['name']!;
                        //                     final key = marathon['key']!;
                        //                     return CheckboxListTile(
                        //                       value: tempSelection.contains(
                        //                         key,
                        //                       ),
                        //                       title: Text(
                        //                         name,
                        //                         style: GoogleFonts.inter(
                        //                           textStyle: const TextStyle(
                        //                             fontSize: 17,
                        //                             color: Colors.black87,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       onChanged: (checked) {
                        //                         setLocalState(() {
                        //                           if (checked == true) {
                        //                             tempSelection.add(key);
                        //                           } else {
                        //                             tempSelection.remove(key);
                        //                           }
                        //                         });
                        //                       },
                        //                     );
                        //                   }).toList(),
                        //                 ),
                        //               ),
                        //               actionsAlignment:
                        //                   MainAxisAlignment.center,
                        //               actions: [
                        //                 TextButton(
                        //                   onPressed: () =>
                        //                       Navigator.pop(context, null),
                        //                   child: Text(
                        //                     'cancel'.tr(),
                        //                     style: GoogleFonts.inter(
                        //                       textStyle: const TextStyle(
                        //                         fontSize: 17,
                        //                         color: Colors.black87,
                        //                         fontWeight: FontWeight.w600,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 ElevatedButton(
                        //                   onPressed: () => Navigator.pop(
                        //                     context,
                        //                     tempSelection,
                        //                   ),
                        //                   child: Text(
                        //                     'ok'.tr(),
                        //                     style: GoogleFonts.inter(
                        //                       textStyle: const TextStyle(
                        //                         fontSize: 17,
                        //                         color: Colors.black87,
                        //                         fontWeight: FontWeight.w600,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             );
                        //           },
                        //         );
                        //       },
                        //     );

                        //     if (result != null) {
                        //       setState(() {
                        //         selectedMarathonKeys = result;
                        //       });
                        //     }
                        //   },

                        //   child: Text(
                        //     'marathons_selection_button'.tr(),
                        //     style: GoogleFonts.inter(
                        //       textStyle: const TextStyle(
                        //         fontSize: 17,
                        //         color: Colors.black87,
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                          ),
                          onPressed: handleSubmit,
                          child: Text(
                            'submit_button'.tr(),
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
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: responseData == null
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HistogramChart(
                                title: buildTitleWidget('overall'),
                                bins: (responseData!['overall']['bins'] as List)
                                    .map((e) => HistogramBin.fromJson(e))
                                    .toList(),
                                width: 600,
                                height: 300,
                              ),
                              const SizedBox(height: 30),
                              HistogramChart(
                                title: buildTitleWidget('by_gender'),
                                bins:
                                    (responseData!['by_gender']['bins'] as List)
                                        .map((e) => HistogramBin.fromJson(e))
                                        .toList(),
                                width: 600,
                                height: 300,
                              ),
                              const SizedBox(height: 30),
                              HistogramChart(
                                title: buildTitleWidget('by_gender_age'),
                                bins:
                                    (responseData!['by_gender_age']['bins']
                                            as List)
                                        .map((e) => HistogramBin.fromJson(e))
                                        .toList(),
                                width: 600,
                                height: 300,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'results_description'.tr(),
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(fontSize: 14),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            // Section 4
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
                        dropdownColor: Colors.black87,
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
                          DropdownMenuItem(
                            value: Locale('ja'),
                            child: Text(
                              '日本語',
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
                        widget.onFooterPageSelected(
                          PrivacyPolicyBody(backgroundColor: widget.appColor),
                        );
                      }),
                      footerLink('terms_of_use_header'.tr(), () {
                        widget.onFooterPageSelected(
                          TermsOfUseBody(backgroundColor: widget.appColor),
                        );
                      }),
                      footerLink('cookie_preferences_header'.tr(), () {
                        widget.onFooterPageSelected(
                          CookiePreferencesBody(
                            backgroundColor: widget.appColor,
                          ),
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
