import 'package:flutter/material.dart';
import 'package:test_packages_ci_cd_20022026/src/painter/psychedelic_painter.dart';

class CustomLoader extends StatelessWidget {
  final List<Color> colorVariations;

  const CustomLoader({
    super.key,
    this.colorVariations = const [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple],
  });

  @override
  Widget build(BuildContext context) {
    //return mainAnimation();
    return mainAnimation();
  }

  Widget mainAnimation() {
    return RepeatingAnimationBuilder<double>(
      animatable: Tween(
        begin: 0,
        end: 1,
      ),
      duration: const Duration(seconds: 1),
      repeatMode: RepeatMode.reverse,
      builder: (context, factor, child) {
        return CustomPaint(
          painter: PsychedelicPainter(
            deformation: factor,
            colors: colorVariations,
          ),
          child: child,
        );
      },
      child: SizedBox.square(dimension: 200),
    );
  }
}
