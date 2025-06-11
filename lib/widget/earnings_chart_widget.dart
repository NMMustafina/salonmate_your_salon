import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/income_provider.dart';

class EarningsChartWidget extends StatelessWidget {
  final DateTime month;

  const EarningsChartWidget({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<IncomeProvider>().entriesForMonth(month);
    final dailyTotals = <int, double>{};

    for (final e in entries) {
      final day = e.date.day;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + e.amount;
    }

    if (dailyTotals.isEmpty) return const SizedBox();

    final spots = dailyTotals.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final maxYRaw = spots.map((s) => s.y).fold(0.0, (p, e) => e > p ? e : p);
    final interval =
        ((maxYRaw / 4).ceil()).clamp(1, double.infinity).toDouble();
    final maxY = interval * 4;

    final today = DateTime.now();
    final isSameMonth = today.year == month.year && today.month == month.month;
    final currentDay = isSameMonth ? today.day : null;

    final spotForToday = currentDay != null
        ? spots.firstWhere(
            (s) => s.x.toInt() == currentDay,
            orElse: () => const FlSpot(-1, -1),
          )
        : null;

    final singlePoint = spots.length == 1;
    final verticalLine = singlePoint
        ? [
            FlSpot(spots.first.x, 0),
            FlSpot(spots.first.x + 0.0001, spots.first.y),
          ]
        : spots;

    const lineGradient = LinearGradient(
      colors: [Color(0xFF3CC5EE), Color(0xFF5166FD)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    const singlePointLineGradient = LinearGradient(
      colors: [Color(0xFF004CE2), Colors.white],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final chartBarData = LineChartBarData(
      isCurved: false,
      dashArray: singlePoint ? null : [12, 6],
      spots: verticalLine,
      gradient: singlePoint ? singlePointLineGradient : lineGradient,
      barWidth: 3,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            const Color(0xFF419BF2).withOpacity(0.4),
            const Color(0xFFF9FAFD).withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    final controller = ScrollController(
      initialScrollOffset: currentDay != null
          ? (currentDay - 3).clamp(0, daysInMonth) * 40.w
          : 0,
    );

    return SizedBox(
      height: 240.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        child: Stack(
          children: [
            Container(
              width: (daysInMonth + 2) * 40.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.only(bottom: 8.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: SizedBox(
                    height: 200.h,
                    child: LineChart(
                      LineChartData(
                        backgroundColor: Colors.transparent,
                        minX: 0,
                        maxX: daysInMonth + 1,
                        minY: 0,
                        maxY: maxY,
                        gridData: const FlGridData(show: false),
                        showingTooltipIndicators:
                            spotForToday != null && spotForToday.x > 0
                                ? [
                                    ShowingTooltipIndicators([
                                      LineBarSpot(chartBarData, 0, spotForToday)
                                    ])
                                  ]
                                : [],
                        lineTouchData: LineTouchData(
                          enabled: true,
                          getTouchedSpotIndicator: (barData, spotIndexes) {
                            return spotIndexes.map((index) {
                              final spot = barData.spots[index];
                              return TouchedSpotIndicatorData(
                                const FlLine(
                                  strokeWidth: 3,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF004CE2),
                                      Colors.white,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                FlDotData(
                                  show: true,
                                  getDotPainter: (s, p, b, i) {
                                    if (s.y <= 0) {
                                      return FlDotCirclePainter(
                                        radius: 0,
                                        color: Colors.transparent,
                                        strokeColor: Colors.transparent,
                                        strokeWidth: 0,
                                      );
                                    }
                                    return FlDotCirclePainter(
                                      radius: 4.r,
                                      color: Colors.white,
                                      strokeColor: Color(0xFF5166FD),
                                      strokeWidth: 3.r,
                                    );
                                  },
                                ),
                              );
                            }).toList();
                          },
                          touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: const Color(0xFF5166FD),
                              tooltipRoundedRadius: 20.r,
                              tooltipPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              tooltipMargin: 12.h,
                              getTooltipItems:
                                  (List<LineBarSpot> touchedSpots) {
                                return touchedSpots
                                    .where((s) => s.y > 0)
                                    .map((s) {
                                  final value = s.y % 1 == 0
                                      ? s.y.toInt().toString()
                                      : s.y.toStringAsFixed(2);
                                  return LineTooltipItem(
                                    '\$$value',
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                    ),
                                  );
                                }).toList();
                              }),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                final day = value.toInt();
                                if (day < 1 || day > daysInMonth) {
                                  return const SizedBox.shrink();
                                }
                                final date =
                                    DateTime(month.year, month.month, day);
                                final text = DateFormat('d MMM').format(date);
                                final isToday = currentDay == day;

                                if (isToday) {
                                  return ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [
                                        Color(0xFF3CC5EE),
                                        Color(0xFF5166FD)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(bounds),
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [chartBarData],
                        extraLinesData: ExtraLinesData(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
