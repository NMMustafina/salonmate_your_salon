import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../asd/color_ev.dart';
import '../asd/mast_tol_prd.dart';

class MasterPickerModal extends StatefulWidget {
  final void Function(String name) onSelected;

  const MasterPickerModal({super.key, required this.onSelected});

  @override
  State<MasterPickerModal> createState() => _MasterPickerModalState();
}

class _MasterPickerModalState extends State<MasterPickerModal> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final masttePrvdr = context.watch<MasttePrvdr>();
    final masters = masttePrvdr.mastteList
        .where(
            (m) => m.maasstteName.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Container(
      height: 753.h,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height - 753.h,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
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
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: const Color(0xFF434242).withOpacity(0.6),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Text(
                  'Select Master',
                  style: TextStyle(
                    color: ColorEv.lightBlack,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w300,
                  ),
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
                    offset: Offset(0, 0.r),
                  ),
                ],
              ),
              suffix: Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: const Icon(CupertinoIcons.search, color: Colors.grey),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: masters.isEmpty
                  ? Center(child: Image.asset('assets/images/maem.png'))
                  : ListView.builder(
                      itemCount: masters.length,
                      itemBuilder: (context, index) {
                        final mastte = masters[index];
                        return GestureDetector(
                          onTap: () {
                            widget.onSelected(mastte.maasstteName);
                            Navigator.pop(context);
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
                                  offset: Offset(0, 0.r),
                                ),
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
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          color: ColorEv.black.withOpacity(0.3),
                                        ),
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
                                          fontWeight: FontWeight.w300,
                                        ),
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
                                                Color(0xFF5166FD),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ).createShader(
                                              const Rect.fromLTWH(0, 0, 200, 0),
                                            ),
                                        ),
                                      ),
                                      Text(
                                        '${mastte.maasstteExperi}+ years of experience',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w300,
                                          color: const Color(0xFF43424299)
                                              .withOpacity(0.6),
                                        ),
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
    );
  }
}
