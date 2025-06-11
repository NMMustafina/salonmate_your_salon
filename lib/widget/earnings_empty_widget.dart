import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EarningsEmptyWidget extends StatelessWidget {
  const EarningsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/empty.svg',
        width: 204.w,
        height: 204.w,
      ),
    );
  }
}
