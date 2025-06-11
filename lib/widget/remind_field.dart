import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salonmate_your_salon_240_a/asd/color_ev.dart';

class RemindField extends StatelessWidget {
  final String? placeholder;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final Widget? suffix;
  final bool useGradient;
  final TextInputType? keyboardType;

  const RemindField({
    super.key,
    this.placeholder,
    required this.controller,
    this.onTap,
    this.suffix,
    this.useGradient = true,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Color(0xFF3CC5EE), Color(0xFF5166FD)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    final shader = gradient.createShader(Rect.fromLTWH(0, 0, 200, 70));

    TextStyle buildStyle(Color fallback) => TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w300,
          foreground: useGradient ? (Paint()..shader = shader) : Paint()
            ..color = fallback,
        );

    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: onTap != null,
        child: CupertinoTextField(
          placeholder: placeholder,
          placeholderStyle: buildStyle(ColorEv.lightBlack),
          controller: controller,
          onTap: onTap,
          keyboardType: keyboardType,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          style: buildStyle(ColorEv.lightBlack),
          suffix: suffix != null
              ? Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: suffix,
                )
              : null,
        ),
      ),
    );
  }
}
