# test_packages_ci_cd_20022026

A Flutter package used to test CI/CD pipelines with pub.dev before applying the same setup to production libraries.

## Features

- `CustomLoader` widget with a psychedelic, deformable shape painter.
- `PsychedelicPainter` — a `CustomPainter` that renders an organic, irregularly deformed blob that grows and shifts color based on a `deformation` factor.

## Usage

```dart
import 'package:test_packages_ci_cd_20022026/test_packages_ci_cd_20022026.dart';

// Minimal usage with defaults
const CustomLoader();

// Custom colors and size
CustomLoader(
  colorVariations: [Colors.cyan, Colors.deepPurple, Colors.amber],
);
```

Use `PsychedelicPainter` directly if you need more control:

```dart
CustomPaint(
  painter: PsychedelicPainter(
    deformation: 0.6,              // 0 = small plain circle, 1 = fully deformed
    colors: [Colors.red, Colors.blue, Colors.green],
  ),
  child: const SizedBox.square(dimension: 200),
);
```

## Additional information

This package is a CI/CD test bed. It is not intended for production use.
This test is being performed now