import 'package:flutter/material.dart';

import '../infrastructure/theme/theme.dart';

class CircularProgressWidget extends StatelessWidget {
  const CircularProgressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: shamrockGreen,
      ),
    );
  }
}
