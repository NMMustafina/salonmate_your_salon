import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:salonmate_your_salon_240_a/asd/color_ev.dart';
import 'package:salonmate_your_salon_240_a/asd/mast_tol_prd.dart';
import 'package:salonmate_your_salon_240_a/asd/moti_ev.dart';
import 'package:salonmate_your_salon_240_a/pages/add_edit_master_modal.dart';
import 'package:salonmate_your_salon_240_a/pages/masste_page_detail.dart';

class Masterd extends StatefulWidget {
  const Masterd({super.key});

  @override
  State<Masterd> createState() => _MasterdState();
}

class _MasterdState extends State<Masterd> {
  @override
  Widget build(BuildContext context) {
    final masttePrvdr = context.watch<MasttePrvdr>();
    return Scaffold(
      appBar: AppBar(
        leading: EvMotiBut(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/icons/arr.png',
            width: 120.w,
            height: 120.w,
            fit: BoxFit.cover,
          ),
        ),
        leadingWidth: 70.w,
        title: Text(
          'Masters Overview',
          style: TextStyle(
            fontSize: 20.sp,
            color: const Color(0xFF39393B),
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          EvMotiBut(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                builder: (context) => const AddEditMasterModal(),
              );
            },
            child: Container(
              height: 44.h,
              margin: EdgeInsets.only(right: 16.w),
              width: 44.h,
              decoration: BoxDecoration(
                color: ColorEv.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorEv.black.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, 2.r),
                  ),
                ],
              ),
              child: Icon(
                Icons.add,
                color: const Color.fromARGB(255, 90, 84, 84),
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0.r),
              child: Column(
                children: [
                  if (masttePrvdr.mastteList.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 150.w),
                      child: Center(
                        child: Image.asset('assets/images/maem.png'),
                      ),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: masttePrvdr.mastteList.length,
                    itemBuilder: (context, index) {
                      final mastte = masttePrvdr.mastteList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MasstePageDetail(mastte: mastte),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0.r, vertical: 12.0.r),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 251, 251, 251),
                            boxShadow: [
                              BoxShadow(
                                color: ColorEv.black.withOpacity(0.1),
                                blurRadius: 10.r,
                                offset: Offset(0, 2.r),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 90.h,
                                    width: 90.w,
                                    decoration: BoxDecoration(
                                      color: ColorEv.white,
                                      borderRadius:
                                          BorderRadius.circular(18.0.r),
                                    ),
                                    child: mastte.maassttePhoto != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18.0.r),
                                            child: Image.memory(
                                              mastte.maassttePhoto!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(
                                            Icons.person,
                                            color:
                                                ColorEv.black.withOpacity(0.3),
                                          ),
                                  ),
                                  SizedBox(width: 10.w),
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
                                            color: ColorEv.lightBlack,
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        Text(
                                          mastte.maasstteSpecial,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorEv.blue,
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        Text(
                                          mastte.maasstteExperi,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w300,
                                            color: ColorEv.lightBlack
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                mastte.maasstteDesc,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                  color: ColorEv.lightBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
