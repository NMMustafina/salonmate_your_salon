import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../asd/moti_ev.dart';
import '../pages/add_edit_income_modal.dart';
import '../provider/income_provider.dart';
import '../widget/earnings_chart_widget.dart';
import '../widget/earnings_empty_widget.dart';
import '../widget/earnings_list_widget.dart';
import '../widget/month_picker.dart';

class Reve extends StatefulWidget {
  const Reve({super.key});

  @override
  State<Reve> createState() => _ReveState();
}

class _ReveState extends State<Reve> {
  DateTime _selectedMonth = DateTime.now();
  bool _hasAnyMonth = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final entries = context.read<IncomeProvider>().entries;
      final Map<int, Set<int>> yearToMonths = {};

      for (final e in entries) {
        yearToMonths.putIfAbsent(e.date.year, () => {}).add(e.date.month);
      }

      setState(() {
        _hasAnyMonth = yearToMonths.isNotEmpty;
      });
    });
  }

  void _openMonthPicker() {
    if (!_hasAnyMonth) return;

    final entries = context.read<IncomeProvider>().entries;
    final Map<int, Set<int>> yearToMonths = {};

    for (final e in entries) {
      yearToMonths.putIfAbsent(e.date.year, () => {}).add(e.date.month);
    }

    showCupertinoMonthYearPicker(
      context: context,
      initialDate: _selectedMonth,
      yearToMonths: yearToMonths,
      onSelected: (picked) {
        setState(() {
          _selectedMonth = picked;
        });
      },
    );
  }

  void _openAddIncome() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => AddEditIncomeModal(
        selectedDate: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries =
        context.watch<IncomeProvider>().entriesForMonth(_selectedMonth);
    final isEmpty = entries.isEmpty;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: EvMotiBut(
          onPressed: () => Navigator.pop(context),
          child: Container(
            height: 44.h,
            margin: EdgeInsets.only(left: 16.w),
            width: 44.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.r,
                  offset: Offset(0, 2.r),
                )
              ],
            ),
            child: Icon(
              CupertinoIcons.back,
              size: 20.r,
              color: const Color(0xFF5A5454),
            ),
          ),
        ),
        title: Text(
          'Earnings Report',
          style: TextStyle(
            fontSize: 20.sp,
            color: const Color(0xFF39393B),
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          EvMotiBut(
            onPressed: _hasAnyMonth ? _openMonthPicker : null,
            child: Container(
              height: 44.h,
              margin: EdgeInsets.only(right: 8.w),
              width: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, 2.r),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: SvgPicture.asset(
                  'assets/icons/calendar.svg',
                  width: 20.r,
                  height: 20.r,
                  color: _hasAnyMonth ? const Color(0xFF5A5454) : Colors.grey,
                ),
              ),
            ),
          ),
          EvMotiBut(
            onPressed: _openAddIncome,
            child: Container(
              height: 44.h,
              margin: EdgeInsets.only(right: 16.w),
              width: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, 2.r),
                  )
                ],
              ),
              child:
                  Icon(Icons.add, color: const Color(0xFF5A5454), size: 20.r),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: isEmpty
                  ? const EarningsEmptyWidget()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EarningsChartWidget(month: _selectedMonth),
                        SizedBox(height: 16.h),
                        Expanded(
                          child: EarningsListWidget(month: _selectedMonth),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
