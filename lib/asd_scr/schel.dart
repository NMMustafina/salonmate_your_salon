import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salonmate_your_salon_240_a/asd/color_ev.dart';
import 'package:salonmate_your_salon_240_a/asd/mast_tol_prd.dart';
import 'package:salonmate_your_salon_240_a/asd/moti_ev.dart';
import 'package:salonmate_your_salon_240_a/widget/remind_field.dart';

class Schel extends StatefulWidget {
  const Schel({super.key});

  @override
  State<Schel> createState() => _SchelState();
}

class _SchelState extends State<Schel> {
  DateTime _displayedMonth = DateTime.now();
  DateTime? _selectedDate;
  DateTime _selectedDateTime = DateTime.now();

  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  void _showMasterModal() {
    final masttePrvdr = context.read<MasttePrvdr>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 753.h,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height - 753.h,
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(ctx),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Click on the master to select',
              style: TextStyle(
                  color: const Color(0xFF434242).withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: const Color(0xFF434242).withOpacity(0.6),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Text(
                    'Select Master',
                    style: TextStyle(
                        color: ColorEv.lightBlack,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(width: 64.w),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CupertinoTextField(
                placeholder: 'Search Master',
                placeholderStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16.sp,
                  color: const Color.fromRGBO(61, 61, 61, 0.3),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x1A000000),
                        blurRadius: 30.r,
                        offset: Offset(0, 0.r))
                  ],
                ),
                suffix: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: const Icon(CupertinoIcons.search, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: masttePrvdr.mastteList.isEmpty
                    ? Center(
                        child: Image.asset('assets/images/maem.png'),
                      )
                    : ListView.builder(
                        itemCount: masttePrvdr.mastteList.length,
                        itemBuilder: (context, index) {
                          final mastte = masttePrvdr.mastteList[index];
                          return GestureDetector(
                            onTap: () {
                              _categoryController.text = mastte.maasstteName;
                              Navigator.pop(ctx);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0x1A000000),
                                      blurRadius: 30.r,
                                      offset: Offset(0, 0.r))
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 90.h,
                                    width: 90.w,
                                    decoration: BoxDecoration(
                                      color: ColorEv.white,
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    child: mastte.maassttePhoto != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18.r),
                                            child: Image.memory(
                                                mastte.maassttePhoto!,
                                                fit: BoxFit.cover),
                                          )
                                        : Icon(Icons.person,
                                            color:
                                                ColorEv.black.withOpacity(0.3)),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mastte.maasstteName,
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          mastte.maasstteSpecial,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            foreground: Paint()
                                              ..shader = const LinearGradient(
                                                colors: [
                                                  Color(0xFF3CC5EE),
                                                  Color(0xFF5166FD)
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ).createShader(
                                                  const Rect.fromLTWH(
                                                      0, 0, 200, 0)),
                                          ),
                                        ),
                                        Text(
                                          '${mastte.maasstteExperi}+ years of experience',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xFF43424299)
                                                  .withOpacity(0.6)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCupertinoDatePicker() {
    DateTime tempPicked = _selectedDateTime;

    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: 350.h,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(ctx),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text("Cancel",
                          style:
                              TextStyle(color: Colors.blue, fontSize: 16.sp)),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text("Save",
                          style:
                              TextStyle(color: Colors.blue, fontSize: 16.sp)),
                      onPressed: () {
                        setState(() {
                          _selectedDateTime = tempPicked;
                          _timeController.text =
                              DateFormat('HH:mm').format(_selectedDateTime);
                        });
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: _selectedDateTime,
                  onDateTimeChanged: (dt) => tempPicked = dt,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddReminderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          _timeController.addListener(() => setModalState(() {}));
          _categoryController.addListener(() => setModalState(() {}));
          _serviceController.addListener(() => setModalState(() {}));

          final isValid = _timeController.text.isNotEmpty &&
              _categoryController.text.isNotEmpty &&
              _serviceController.text.isNotEmpty;

          return DraggableScrollableSheet(
            maxChildSize: 0.9,
            minChildSize: 0.4,
            expand: false,
            builder: (_, controller) => Container(
              padding: EdgeInsets.only(
                top: 12.h,
                left: 24.w,
                right: 24.w,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D3D3D4D).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add Reminder',
                          style: TextStyle(
                              color: const Color(0xFF39393B),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w300)),
                      EvMotiBut(
                        child: Container(
                          height: 32.h,
                          width: 32.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: ColorEv.black.withOpacity(0.1),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 2.r))
                            ],
                          ),
                          child: Icon(CupertinoIcons.xmark, size: 20.r),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                      )
                    ],
                  ),
                  SizedBox(height: 24.h),
                  RemindField(
                    controller: _timeController,
                    placeholder: 'Select Time',
                    onTap: _showCupertinoDatePicker,
                    suffix: SvgPicture.asset('assets/icons/alarm.svg'),
                  ),
                  SizedBox(height: 16.h),
                  RemindField(
                    controller: _categoryController,
                    placeholder: 'Select Master',
                    onTap: _showMasterModal,
                    suffix: SvgPicture.asset('assets/icons/share.svg'),
                  ),
                  SizedBox(height: 16.h),
                  RemindField(
                    controller: _serviceController,
                    placeholder: 'Service Type',
                    useGradient: false,
                  ),
                  SizedBox(height: 24.h),
                  EvMotiBut(
                    onPressed: isValid
                        ? () {
                            final parts =
                                _timeController.text.split(RegExp(r'[:\s]'));
                            final t = TimeOfDay(
                                hour: int.parse(parts[0]),
                                minute: int.parse(parts[1]));
                            context.read<AppointmentPrvdr>().addAppointment(
                                  Appointment(
                                    master: _categoryController.text,
                                    service: _serviceController.text,
                                    time: t,
                                  ),
                                );
                            Navigator.pop(ctx);
                          }
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        gradient: isValid
                            ? const LinearGradient(
                                colors: [Color(0xFF3CC5EE), Color(0xFF5166FD)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : LinearGradient(
                                colors: [
                                  const Color(0xFF3CC5EE).withOpacity(0.3),
                                  const Color(0xFF5166FD).withOpacity(0.3),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: isValid ? Colors.white : Colors.white54,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    final firstOfMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysInMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday % 7;

    final dayTiles = <Widget>[];
    for (var i = 0; i < startWeekday; i++) {
      dayTiles.add(const SizedBox());
    }
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(_displayedMonth.year, _displayedMonth.month, d);
      final isSelected = _selectedDate != null &&
          _selectedDate!.year == date.year &&
          _selectedDate!.month == date.month &&
          _selectedDate!.day == date.day;

      dayTiles.add(
        GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            alignment: Alignment.center,
            decoration: isSelected
                ? const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF3CC5EE), Color(0xFF5166FD)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                    shape: BoxShape.circle,
                  )
                : null,
            child: Text(
              '$d',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  color: isSelected ? Colors.white : Colors.black),
            ),
          ),
        ),
      );
    }

    const Gradient timeTextGradient = LinearGradient(
      colors: [Color(0xFF3CC5EE), Color(0xFF5166FD)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: EvMotiBut(
          onPressed: () => Navigator.pop(context),
          child: Image.asset('assets/icons/arr.png',
              width: 120.w, height: 120.w, fit: BoxFit.cover),
        ),
        leadingWidth: 70.w,
        title: Text('Appointment Reminders',
            style: TextStyle(
                fontSize: 20.sp,
                color: const Color(0xFF39393B),
                fontWeight: FontWeight.w300)),
        centerTitle: true,
        actions: [
          EvMotiBut(
            onPressed: _showAddReminderSheet,
            child: Container(
              height: 35.h,
              margin: EdgeInsets.only(right: 16.w),
              width: 35.h,
              decoration: BoxDecoration(
                color: ColorEv.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: ColorEv.black.withOpacity(0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, 2.r))
                ],
              ),
              child: Icon(
                Icons.add,
                color: const Color(0xFF5A5454),
                size: 20.r,
              ),
            ),
          )
        ],
      ),
      body: Stack(children: [
        Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover)),
        SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w)
                      .copyWith(top: 12.h),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                            color: ColorEv.black.withOpacity(0.1),
                            blurRadius: 10.r,
                            offset: Offset(0, 2.r))
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${_monthName(_displayedMonth.month)} ${_displayedMonth.year}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _prevMonth,
                              child: Icon(
                                CupertinoIcons.left_chevron,
                                size: 28.r,
                                color: const Color(
                                  0xFF4A90E2,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            GestureDetector(
                              onTap: _nextMonth,
                              child: Icon(
                                CupertinoIcons.right_chevron,
                                size: 28.r,
                                color: const Color(
                                  0xFF4A90E2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: weekdays
                              .map((w) => Text(w,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey)))
                              .toList(),
                        ),
                        SizedBox(height: 8.h),
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 7,
                          mainAxisSpacing: 8.h,
                          crossAxisSpacing: 8.w,
                          children: dayTiles,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Consumer<AppointmentPrvdr>(
                    builder: (_, ap, __) {
                      final list = ap.appointments;
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final a = list[i];
                          return Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                    color: ColorEv.black.withOpacity(0.1),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 2.r))
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            a.master,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xFF39393B),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => ap.toggleEnabled(i),
                                            child: Container(
                                              width: 51.r,
                                              height: 31.r,
                                              padding: EdgeInsets.all(2.r),
                                              decoration: BoxDecoration(
                                                gradient: a.enabled
                                                    ? const LinearGradient(
                                                        colors: [
                                                            Color(0xFF3CC5EE),
                                                            Color(0xFF5166FD)
                                                          ])
                                                    : LinearGradient(colors: [
                                                        const Color(0xFF3CC5EE)
                                                            .withOpacity(0.2),
                                                        const Color(0xFF5166FD)
                                                            .withOpacity(0.2)
                                                      ]),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.r),
                                              ),
                                              child: Align(
                                                alignment: a.enabled
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Container(
                                                  padding: EdgeInsets.all(5.r),
                                                  decoration: BoxDecoration(
                                                    color: a.enabled
                                                        ? Colors.white
                                                        : Colors.blue,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    a.enabled
                                                        ? 'assets/icons/frame_2.svg'
                                                        : 'assets/icons/frame_1.svg',
                                                    width: 16.w,
                                                    height: 16.h,
                                                    color: a.enabled
                                                        ? Colors.blue
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        a.service,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w300,
                                          color: const Color(0xFF434242)
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/alarm.svg',
                                            width: 16.w,
                                            height: 16.h,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            a.time.format(context),
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              foreground: Paint()
                                                ..shader = timeTextGradient
                                                    .createShader(
                                                  const Rect.fromLTWH(
                                                      0, 0, 100, 20),
                                                ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  String _monthName(int m) {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return names[m];
  }
}
