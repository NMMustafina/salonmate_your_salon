import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonmate_your_salon_240_a/asd/moti_ev.dart';
import 'package:salonmate_your_salon_240_a/asd_scr/masterd.dart';
import 'package:salonmate_your_salon_240_a/asd_scr/reve.dart';
import 'package:salonmate_your_salon_240_a/asd_scr/schel.dart';
import 'package:salonmate_your_salon_240_a/asd_scr/setdas.dart';

class MainAsd extends StatelessWidget {
  const MainAsd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'WELCOME BACK',
                  style: TextStyle(
                    color: const Color(0xFF39393B),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Easily manage your artists, appointments,\nand earnings in one place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 40.h),
                Expanded(
                  child: GridView.count(
                    shrinkWrap: false,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.w,
                    crossAxisSpacing: 15.w,
                    children: [
                      _buildCard(
                        '1',
                        'Masters',
                        'Artists, works, reviews',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Masterd(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        '2',
                        'Schedule',
                        'Scheduled Reminders',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Schel(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        '3',
                        'Revenue',
                        'Earnings & stats',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Reve(),
                            ),
                          );
                        },
                      ),
                      _buildCard(
                        '4',
                        'Settings',
                        'Preferences & control',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Setdas(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      String number, String title, String subtitle, Function() onPressed) {
    return EvMotiBut(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/$number.png',
              width: 50.w,
              height: 50.w,
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                color: const Color(0xFF39393B),
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF39393B),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
