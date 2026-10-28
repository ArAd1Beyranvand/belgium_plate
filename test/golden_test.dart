import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:belgium_plate/belgium_plate.dart';
import 'package:plate_core/plate_core.dart';

/// One golden per category, drawn with real bold faces so the ink can be
/// measured against the references (`platekit golden-check`).
///
/// Regenerate with `flutter test --update-goldens` after a deliberate change.
void main() {
  setUpAll(() async {
    final FontLoader loader = FontLoader('Roboto');
    for (final String path in const <String>[
      '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
    ]) {
      final File face = File(path);
      if (!face.existsSync()) continue;
      loader.addFont(face.readAsBytes().then((b) => ByteData.view(b.buffer)));
    }
    await loader.load();
  });

  /// category id -> (spec, theme, space-separated sample value)
  final Map<String, (PlateSpec, PlateTheme, String)> cases =
      <String, (PlateSpec, PlateTheme, String)>{
        'private': (BelgiumPlates.private, BelgiumThemes.private, '1 ABC 003'),
        'dealer': (BelgiumPlates.plain, BelgiumThemes.private, '1 ZAV 257'),
        'trailer': (BelgiumPlates.plain, BelgiumThemes.private, '1 QAA 620'),
        'temporary': (
          BelgiumPlates.temporary,
          BelgiumThemes.temporary,
          'XA 16 DRN',
        ),
        'vintage': (BelgiumPlates.vintage, BelgiumThemes.private, '000 200'),
        'diplomatic': (
          BelgiumPlates.diplomatic,
          BelgiumThemes.private,
          'AT 119',
        ),
        'royal': (BelgiumPlates.royal, BelgiumThemes.private, '2'),
        'military': (BelgiumPlates.military, BelgiumThemes.military, '26287'),
        'motorcycle': (
          BelgiumPlates.motorcycle,
          BelgiumThemes.private,
          'M AXJ 464',
        ),
      };

  for (final MapEntry<String, (PlateSpec, PlateTheme, String)> c
      in cases.entries) {
    testWidgets(c.key, (tester) async {
      final (PlateSpec spec, PlateTheme theme, String values) = c.value;
      final PlateController controller = PlateController.fromValues(
        spec,
        values.split(' '),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 680,
                height: 300,
                child: PlateThemeScope(
                  theme: theme,
                  child: PlateView(
                    controller: controller,
                    theme: theme,
                    country: BelgiumCountry.belgium,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(PlateView),
        matchesGoldenFile('goldens/be_${c.key}.png'),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
