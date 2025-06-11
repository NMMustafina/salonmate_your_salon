import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

void showCupertinoMonthYearPicker({
  required BuildContext context,
  required Map<int, Set<int>> yearToMonths,
  required DateTime initialDate,
  required void Function(DateTime selected) onSelected,
}) {
  List<int> years = yearToMonths.keys.toList()..sort();
  int selectedYear = initialDate.year;
  int selectedMonth = initialDate.month;

  List<int> getMonthsForYear(int year) =>
      (yearToMonths[year]?.toList() ?? [])..sort();

  List<int> months = getMonthsForYear(selectedYear);
  int selectedMonthIndex = months.indexOf(selectedMonth);
  FixedExtentScrollController monthController = FixedExtentScrollController(
    initialItem: selectedMonthIndex >= 0 ? selectedMonthIndex : 0,
  );
  FixedExtentScrollController yearController = FixedExtentScrollController(
    initialItem: years.indexOf(selectedYear),
  );

  showCupertinoModalPopup(
    context: context,
    builder: (_) => Center(
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 150.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: monthController,
                              itemExtent: 32.h,
                              onSelectedItemChanged: (i) {
                                final newMonth = months[i];
                                final validYears = years
                                    .where((y) =>
                                        yearToMonths[y]!.contains(newMonth))
                                    .toList();
                                final updatedYear =
                                    validYears.contains(selectedYear)
                                        ? selectedYear
                                        : validYears.isNotEmpty
                                            ? validYears.first
                                            : selectedYear;

                                setState(() {
                                  selectedMonth = newMonth;
                                  selectedYear = updatedYear;
                                  yearController
                                      .jumpToItem(years.indexOf(updatedYear));
                                });
                              },
                              selectionOverlay: Container(),
                              children: months
                                  .map((m) => Center(
                                        child: Text(
                                          DateFormat.MMMM()
                                              .format(DateTime(0, m)),
                                          style: TextStyle(fontSize: 20.sp),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: yearController,
                              itemExtent: 32.h,
                              onSelectedItemChanged: (i) {
                                final newYear = years[i];
                                final newMonths = getMonthsForYear(newYear);

                                setState(() {
                                  selectedYear = newYear;
                                  months = newMonths;
                                  selectedMonth = months.first;
                                  monthController.jumpToItem(0);
                                });
                              },
                              selectionOverlay: Container(),
                              children: years
                                  .map((y) => Center(
                                        child: Text(
                                          '$y',
                                          style: TextStyle(fontSize: 20.sp),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: (150.h - 32.h) / 2,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Container(
                          height: 32.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF5166FD),
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10.r,
                                offset: Offset(0, 2.r),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onSelected(DateTime(selectedYear, selectedMonth));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3CC5EE), Color(0xFF5166FD)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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
    ),
  );
}
