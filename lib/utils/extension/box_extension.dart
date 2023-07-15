import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension BoxExtension on dynamic {
  Widget get heightBox => SizedBox(
        height: this * 1.0.h,
      );

  Widget get widthBox => SizedBox(
        width: this * 1.0.w,
      );
}
