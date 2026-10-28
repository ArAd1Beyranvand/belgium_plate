import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

import 'belgium_colors.dart';
import 'belgium_country.dart';
import 'belgium_themes.dart';

/// Where the ink sits, in millimetres.
///
/// Every figure is read off the flattened references in `.plateref/be`, each
/// normalised to the 520×110 mm the article gives (the motorcycle plate to the
/// 210×138 its photograph has, aspect 1.52).
///
/// * Standard (`1-ABC-123`, Euroband 0..51): ink y 21.5..90.8; glyph centres
///   1 at 82; ABC 181 231 281; 123 381 431 481; hyphens x 123.3..139.8 and
///   322.5..339.5, y 55.3..64.5.
/// * Temporary and export (`XA-16-DRN`): letters 79 128; digits 231 285 (a
///   proportional `1`); letters 389 438 486; hyphens 171.5..188.5 and
///   328.5..345.2.
/// * Dealer and trailer, no Euroband: 1 at 88.5; letters 143 199 254; digits
///   367 423 479; ink y 17.5..91.8. The first hyphen sits below the colour
///   threshold and is placed between the 1 and the letters; the second is
///   302..319.
/// * Vintage (`000-200`, no Euroband): ink y 16..93.8; hyphen 274.5..296.
/// * Diplomatic (`CD.AT-119`): CD x 62..150, the dot 171..186.5, AT 227 277,
///   hyphen 319..334.5, 119 across 363..496.
/// * Royal: a single `2` centred on 280, ink y 26..95.5.
/// * Military: flag x 117..148.5, y 21..94.5; five digits at pitch 52.7,
///   ink y 16.2..96.5.
///
/// **Under-height ink, accepted.** The ink is 60–80 mm tall on a 110 mm
/// plate. `glyphStyle` makes a bold digit ~0.55 of its slot, so full height
/// would need slots beyond the canvas; the slots are as tall as the plate
/// allows (106) and `plate_core` is unchanged. DejaVu Bold is also far wider
/// than the plate's face, so runs are width-limited by their pitch.
///
/// **Photo normalisation differs.** The export photo carries a dealer's strip
/// under the plate, so its vertical positions are taken from the rear
/// temporary plate and the standard photo; hyphens keep the standard's height.
///
/// Not modelled: the tiny pink vehicle-type emblem printed above the first
/// hyphen (faint, 15×20 mm), and the sticker on the dealer, temporary and
/// trailer plates.
abstract final class _Layout {
  static const double width = 520;
  static const double height = 110;
  static const double bandEnd = 51;
  static const double slotHeight = 106;
  static const double hyphenHeight = 9.25;
  static const double hyphenTop = 55.25;

  static const double motoWidth = 210;
  static const double motoHeight = 138;
}

/// A field: a run printed and typed as a unit, one slot.
class _Field {
  const _Field(
    this.key,
    this.alphabet, {
    required this.left,
    required this.width,
    required this.count,
    this.minLength,
    this.centre = 56,
    this.height = _Layout.slotHeight,
  });

  final String key;
  final PlateAlphabet alphabet;
  final double left;
  final double width;
  final int count;
  final int? minLength;

  /// Ink centre of the row, in plate y.
  final double centre;
  final double height;

  PlateSlot toSlot() => PlateSlot(
    alphabet: alphabet,
    box: PlateBox(left, centre - height / 2, width, height),
    length: count,
    minLength: minLength,
    spacing: count == 1 ? 0 : max(0, width / count - 0.6 * 0.72 * height),
  );
}

/// Belgium's plate geometries. Private, dealer and trailer share the
/// `series-letters-serial` line, temporary its own `letters-digits-letters`;
/// colours are the theme's.
///
/// Not implemented, all discontinued or historic: the blue EU-institution
/// (`EUR 2602`) and international-staff (`920911`) plates and their 8-ABC-123
/// successor, which is the standard design; pre-2010 `ABC-123` and
/// `123-ABC` plates (valid but no longer issued, same design, no Euroband);
/// the personalised and parliament plates, which are the standard design with
/// other content. The article's `CD` plate is green or red by embassy; the
/// photograph is red.
abstract final class BelgiumPlates {
  static const PlateAlphabet _digits = BelgiumAlphabets.digits;
  static const PlateAlphabet _letters = BelgiumAlphabets.letters;

  static const PlateSection _euroBand = PlateSection.columns(<PlatePart>[
    PlatePart(PlateSection.fill(PlateFill.panel), end: _Layout.bandEnd),
    PlatePart(PlateSection.plain),
  ]);

  static const PlatePanel _euroPanel = PlatePanel(
    box: PlateBox(4.8, 1.3, 41.4, 63.4),
    padding: EdgeInsets.zero,
  );

  static const PlateLabel _euroB = PlateLabel(
    text: 'B',
    box: PlateBox(0, 64, _Layout.bandEnd, 40),
    glyphHeight: 40,
    color: BelgiumColors.white,
  );

  static PlateRule _hyphen(
    double left,
    double width, {
    double top = _Layout.hyphenTop,
    double height = _Layout.hyphenHeight,
  }) => PlateRule(box: PlateBox(left, top, width, height));

  static PlateSpec _line({
    required String id,
    required List<_Field> fields,
    required List<PlateRule> rules,
    bool euroBand = false,
    List<PlateLabel> labels = const <PlateLabel>[],
    List<PlateDecal> decals = const <PlateDecal>[],
    PlateThemeResolver? resolveTheme,
  }) => PlateSpec(
    id: id,
    country: BelgiumCountry.belgium,
    canvasWidth: _Layout.width,
    canvasHeight: _Layout.height,
    noPanel: !euroBand,
    panel: euroBand
        ? _euroPanel
        : const PlatePanel(box: PlateBox(0, 0, 0, _Layout.height)),
    background: euroBand ? _euroBand : PlateSection.plain,
    slots: <PlateSlot>[for (final _Field f in fields) f.toSlot()],
    rules: rules,
    labels: <PlateLabel>[if (euroBand) _euroB, ...labels],
    decals: decals,
    resolveTheme: resolveTheme,
    textGroups: <PlateTextGroup>[
      for (int i = 0; i < fields.length; i++)
        PlateTextGroup(<int>[i], key: fields[i].key),
    ],
  );

  /// `1-ABC-123` on the Euroband: the first digit has been 1 since 2010 and 2
  /// since January 2021.
  static final PlateSpec private = _line(
    id: 'be.private',
    euroBand: true,
    fields: const <_Field>[
      _Field('series', _digits, left: 57, width: 50, count: 1),
      _Field('letters', _letters, left: 156, width: 150, count: 3),
      _Field('serial', _digits, left: 356, width: 150, count: 3),
    ],
    rules: <PlateRule>[_hyphen(123.25, 16.5), _hyphen(322.5, 17)],
  );

  /// `1-ZAV-257` dealer (green, first letter Z) and `1-QAA-620` trailer and
  /// caravan over 750 kg (first letter Q): no Euroband in the photographs. The
  /// article says the dealer plate has one; the picture wins.
  static final PlateSpec plain = _line(
    id: 'be.plain',
    resolveTheme: BelgiumThemes.byLetters,
    fields: const <_Field>[
      _Field('series', _digits, left: 63.5, width: 50, count: 1, centre: 54.7),
      _Field(
        'letters',
        _letters,
        left: 115.5,
        width: 166.5,
        count: 3,
        centre: 54.7,
      ),
      _Field('serial', _digits, left: 339, width: 168, count: 3, centre: 54.7),
    ],
    rules: <PlateRule>[_hyphen(100, 17), _hyphen(302, 17)],
  );

  /// `XA-16-DRN`, white on red: temporary registration for export. The
  /// article's first character is X (export within 30 days) or Z.
  static final PlateSpec temporary = _line(
    id: 'be.temporary',
    euroBand: true,
    fields: const <_Field>[
      _Field('kind', _letters, left: 55, width: 98, count: 2, centre: 57),
      _Field('number', _digits, left: 208, width: 100, count: 2, centre: 57),
      _Field('letters', _letters, left: 357, width: 148, count: 3, centre: 57),
    ],
    rules: <PlateRule>[
      _hyphen(171.5, 17, top: 53),
      _hyphen(328.5, 16.7, top: 53),
    ],
  );

  /// `000-200`, vintage (oldtimer): two runs of three digits, no Euroband.
  /// The pitches differ (75 and 66) as photographed.
  static final PlateSpec vintage = _line(
    id: 'be.vintage',
    fields: const <_Field>[
      _Field('series', _digits, left: 33, width: 226, count: 3, centre: 55),
      _Field('serial', _digits, left: 313, width: 198, count: 3, centre: 55),
    ],
    rules: <PlateRule>[_hyphen(274.5, 21.5, top: 51, height: 9)],
  );

  /// `CD.AT-119`: CD, a dot, two letters and three digits (the article's
  /// 2010 format) on the Euroband.
  static final PlateSpec diplomatic = _line(
    id: 'be.diplomatic',
    euroBand: true,
    fields: const <_Field>[
      _Field('letters', _letters, left: 202.6, width: 98.8, count: 2),
      _Field('serial', _digits, left: 354.5, width: 150, count: 3),
    ],
    rules: <PlateRule>[_hyphen(171, 15.5), _hyphen(319.25, 15.25)],
    labels: const <PlateLabel>[
      PlateLabel(
        text: 'CD',
        box: PlateBox(62, 3, 88, _Layout.slotHeight),
        glyphHeight: _Layout.slotHeight,
      ),
    ],
  );

  /// The Royal Household: only a number, 1 to 9 for the king and queen, two
  /// digits for the rest of the family.
  static final PlateSpec royal = _line(
    id: 'be.royal',
    euroBand: true,
    fields: const <_Field>[
      _Field(
        'number',
        _digits,
        left: 205,
        width: 150,
        count: 2,
        minLength: 1,
        centre: 61,
        // The row sits 5 units low, so the slot is trimmed to stay on the canvas.
        height: 98,
      ),
    ],
    rules: const <PlateRule>[],
  );

  /// The Land Component: the tricolour then five digits, black on white.
  static final PlateSpec military = _line(
    id: 'be.military',
    fields: const <_Field>[
      _Field(
        'serial',
        _digits,
        left: 172.7,
        width: 263.5,
        count: 5,
        centre: 56.3,
      ),
    ],
    rules: const <PlateRule>[],
    decals: const <PlateDecal>[
      PlateDecal(
        drawing: PlateDrawing(31.5, 73.5, <PlateShape>[
          PlateRectShape(0, 0, 10.5, 73.5, BelgiumColors.flagBlack),
          PlateRectShape(10.5, 0, 10.5, 73.5, BelgiumColors.flagYellow),
          PlateRectShape(21, 0, 10.5, 73.5, BelgiumColors.flagRed),
        ]),
        box: PlateBox(117, 21, 31.5, 73.5),
      ),
    ],
  );

  /// `M-AXJ` over `464`, 210×138. The Euroband is the lower-left block only
  /// (x 0..33.6, from y 70.3); the rows are 68 tall, the most their centres
  /// (34.4 and 101) leave inside the canvas, for ink of ~37 against the
  /// photograph's 43.7. Rows normalised from the 520×110 flat by 0.404 in x
  /// and 1.2545 in y.
  static final PlateSpec motorcycle = () {
    const double h = 68;
    const double row1 = 34.4;
    const double row2 = 101;
    return PlateSpec(
      id: 'be.motorcycle',
      country: BelgiumCountry.belgium,
      canvasWidth: _Layout.motoWidth,
      canvasHeight: _Layout.motoHeight,
      borderWidthRatioOverride: 4 / _Layout.motoHeight,
      panel: const PlatePanel(
        box: PlateBox(2.3, 66, 29.4, 45),
        padding: EdgeInsets.zero,
      ),
      background: const PlateSection.columns(<PlatePart>[
        PlatePart(
          PlateSection.rows(<PlatePart>[
            PlatePart(PlateSection.plain, end: 70.3),
            PlatePart(PlateSection.fill(PlateFill.panel)),
          ]),
          end: 33.6,
        ),
        PlatePart(PlateSection.plain),
      ]),
      slots: <PlateSlot>[
        const _Field(
          'series',
          BelgiumAlphabets.alphanumeric,
          left: 4,
          width: 40,
          count: 1,
          centre: row1,
          height: h,
        ).toSlot(),
        const _Field(
          'letters',
          _letters,
          left: 84.3,
          width: 121.8,
          count: 3,
          centre: row1,
          height: h,
        ).toSlot(),
        const _Field(
          'serial',
          _digits,
          left: 84.3,
          width: 121.8,
          count: 3,
          centre: row2,
          height: h,
        ).toSlot(),
      ],
      rules: const <PlateRule>[PlateRule(box: PlateBox(58.8, 35.2, 11.8, 7.8))],
      labels: const <PlateLabel>[
        PlateLabel(
          text: 'B',
          box: PlateBox(0, 101, 33.6, 36),
          glyphHeight: 36,
          color: BelgiumColors.white,
        ),
      ],
      textGroups: const <PlateTextGroup>[
        PlateTextGroup(<int>[0], key: 'series'),
        PlateTextGroup(<int>[1], key: 'letters'),
        PlateTextGroup(<int>[2], key: 'serial'),
      ],
    );
  }();

  static List<PlateSpec> get all => <PlateSpec>[
    private,
    plain,
    temporary,
    vintage,
    diplomatic,
    royal,
    military,
    motorcycle,
  ];
}
