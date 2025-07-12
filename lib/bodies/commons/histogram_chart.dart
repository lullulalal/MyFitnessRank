import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:easy_localization/easy_localization.dart';

class HistogramBin {
  final int timeRangeStart;
  final int timeRangeEnd;
  final double percent;
  final int count;
  final bool isUserBin;

  HistogramBin({
    required this.timeRangeStart,
    required this.timeRangeEnd,
    required this.percent,
    required this.count,
    required this.isUserBin,
  });

  factory HistogramBin.fromJson(Map<String, dynamic> json) {
    return HistogramBin(
      timeRangeStart: json['time_range_start'],
      timeRangeEnd: json['time_range_end'],
      percent: (json['percent'] as num).toDouble(),
      count: json['count'],
      isUserBin: json['is_user_bin'],
    );
  }
}

class HistogramChart extends StatelessWidget {
  final List<HistogramBin> bins;
  final Widget title;
  final double? width;
  final double? height;

  const HistogramChart({
    super.key,
    required this.bins,
    required this.title,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 12),
        SizedBox(
          width: width ?? double.infinity,
          height: height ?? 260,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: Colors.grey.withAlpha(51), strokeWidth: 1),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= bins.length || index % 3 != 0) {
                        return const SizedBox.shrink();
                      }
                      final bin = bins[index];
                      final avgMinutes =
                          ((bin.timeRangeStart + bin.timeRangeEnd) / 2 / 60)
                              .round();
                      return Text(
                        '$avgMinutes min',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: List.generate(bins.length, (index) {
                final bin = bins[index];
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: bin.percent,
                      color: bin.isUserBin ? Colors.amber : Colors.black,
                      width: 17,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      rodStackItems: [],
                    ),
                  ],
                );
              }),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBorderRadius: BorderRadius.circular(6),
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipMargin: 8,
                  getTooltipColor: (BarChartGroupData group) {
                    return Colors.black87;
                  },
                  getTooltipItem:
                      (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        final bin = bins[group.x.toInt()];
                        final avgMinutes =
                            ((bin.timeRangeStart + bin.timeRangeEnd) / 2 / 60)
                                .round();
                        return BarTooltipItem(
                          '${bin.percent.toStringAsFixed(2)}% ${'bar_tooltip'.tr()} $avgMinutes ${'bar_tooltip_minute'.tr()}',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                ),
              ),
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          ),
        ),
      ],
    );
  }
}
