import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../infrastructure/theme/theme.dart';

class AudioButton extends StatelessWidget {
  final RxBool isPlaying;
  final VoidCallback onTap;
  final String label;

  const AudioButton({
    Key? key,
    required this.isPlaying,
    required this.onTap,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            width: 79,
            height: 58,
            decoration: BoxDecoration(
              color:
                  isPlaying.value ? Colors.blue : Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
              child: Column(
                children: [
                  const Icon(
                    EvaIcons.volumeUp,
                    color: white,
                  ),
                  Text(
                    label,
                    style: whiteTextStyle.copyWith(fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
