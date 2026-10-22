import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'belgium_colors.dart';

/// One ink on one field, framed in the ink. Rim 4 mm and corner ~5 mm on the
/// 110 mm plate, read off the flats.
abstract final class BelgiumThemes {
  static PlateTheme _field(
    Color field,
    Color ink, {
    Color inactive = BelgiumColors.inactiveOnLight,
  }) => PlateTheme(
    plateBackground: field,
    plateBorder: ink,
    ink: ink,
    dividerColor: ink,
    borderWidthRatio: 0.036,
    plateRadiusRatio: 0.045,
    activeColor: ink,
    inactiveColor: inactive,
    alertColor: const Color(0xFFD32F2F),
  );

  /// Red on white: private, trailer, vintage, diplomatic, royal, motorcycle.
  static final PlateTheme private = _field(BelgiumColors.white, BelgiumColors.red);

  /// Green on white: dealers.
  static final PlateTheme dealer = _field(BelgiumColors.white, BelgiumColors.dealerGreen);

  /// White on red: temporary and export.
  static final PlateTheme temporary = _field(
    BelgiumColors.temporaryRed,
    BelgiumColors.temporaryInk,
    inactive: BelgiumColors.inactiveOnDark,
  );

  /// Black on white: military.
  static final PlateTheme military = _field(BelgiumColors.white, BelgiumColors.militaryBlack);
}
