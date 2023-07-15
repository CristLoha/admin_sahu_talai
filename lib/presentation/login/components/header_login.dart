import 'package:admin_sahu_talai/utils/extension/box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../infrastructure/theme/theme.dart';
import '../../../utils/extension/img_string.dart';

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            ImgString.logoSahu,
            width: 154.w,
            height: 60.h,
          ),
        ),
        70.heightBox,
        Text(
          'Silakan masukkan\nEmail dan Kata Sandi',
          style: darkBlueTextStyle.copyWith(
            fontSize: 20.sp,
            fontWeight: semiBold,
          ),
        ),
      ],
    );
  }
}
