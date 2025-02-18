import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomLoader extends StatelessWidget {
  final double? size;

  const CustomLoader({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size ?? 200.w,
        height: size ?? 200.h,
        padding: EdgeInsets.all(16.w),
        child: Lottie.asset(
          'assets/json/loading_stanford.json',
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
}
