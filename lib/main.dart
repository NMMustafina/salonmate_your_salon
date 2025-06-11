import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:salonmate_your_salon_240_a/asd/color_ev.dart';
import 'package:salonmate_your_salon_240_a/asd/mast_tol_prd.dart';
import 'package:salonmate_your_salon_240_a/asd_scr/main_asd.dart';
import 'package:salonmate_your_salon_240_a/provider/income_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MasttePrvdr()),
          ChangeNotifierProvider(create: (_) => AppointmentPrvdr()),
          ChangeNotifierProvider(create: (_) => IncomeProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SalonMate',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: ColorEv.white,
            ),
            scaffoldBackgroundColor: ColorEv.white,

            // fontFamily: '-_- ??',
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          home: const MainAsd(),
        ),
      ),
    );
  }
}
