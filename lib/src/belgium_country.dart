import 'package:plate_core/plate_core.dart';

import 'belgium_colors.dart';

/// Belgium as a `PlateCountry`: the Euroband. The stars are
/// `EuropeanStars.band`; the `B` beneath them is a [PlateLabel] on the spec,
/// so [captionLines] is empty. The national tricolour is printed only on the
/// military plate, as a decal there.
abstract final class BelgiumCountry {
  static const PlateCountry belgium = PlateCountry(
    code: 'be',
    captionLines: <String>[],
    panelColor: BelgiumColors.euroBlue,
    panelTextColor: BelgiumColors.white,
    flagAspectRatio: 46 / 70.4,
    flag: EuropeanStars.band,
  );
}
