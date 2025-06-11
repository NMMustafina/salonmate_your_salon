import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonmate_your_salon_240_a/asd/dok_ev.dart';
import 'package:salonmate_your_salon_240_a/asd/moti_ev.dart';
import 'package:salonmate_your_salon_240_a/asd/pro_ev.dart';

class Setdas extends StatelessWidget {
  const Setdas({super.key});
  @override
  Widget build(BuildContext context) {
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
          'Settings',
          style: TextStyle(
            fontSize: 20.sp,
            color: const Color(0xFF39393B),
            fontWeight: FontWeight.w300,
          ),
        ),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              EvMotiBut(
                onPressed: () {
                  lauchUrl(context, DokEv.suprF);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icons/s1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              EvMotiBut(
                onPressed: () {
                  lauchUrl(context, DokEv.terOfUse);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icons/s2.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              EvMotiBut(
                onPressed: () {
                  lauchUrl(context, DokEv.priPoli);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icons/s3.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
