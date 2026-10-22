import 'package:plate_core/plate_core.dart';

/// One field's rule: letters or digits, between [min] and [max] of them.
class _Rule {
  const _Rule(this.key, {required this.digits, required this.min, int? max}) : max = max ?? min;

  final String key;
  final bool digits;
  final int min;
  final int max;
}

/// Judges a Belgian plate field by field. Reports, never bars a keystroke.
///
/// A plate is judged once any field holds a character; every field must then
/// be of its kind and within its length. Standard plates are `1-ABC-123`;
/// dealers' start with Z and a second letter A to Y (ZZ is reserved).
class BelgiumValidator extends PlateValidator {
  const BelgiumValidator();

  static const String reasonLength = 'A field has the wrong number of symbols.';
  static const String reasonKind = 'A field mixes letters and digits.';
  static const String reasonDealer =
      'A dealer plate starts with Z and a second letter from A to Y.';

  static const List<_Rule> _threeFields = <_Rule>[
    _Rule('series', digits: true, min: 1),
    _Rule('letters', digits: false, min: 3),
    _Rule('serial', digits: true, min: 3),
  ];

  static const Map<String, List<_Rule>> _rules = <String, List<_Rule>>{
    'be.private': _threeFields,
    'be.dealer': _threeFields,
    'be.trailer': _threeFields,
    'be.motorcycle': <_Rule>[
      _Rule('series', digits: false, min: 1),
      _Rule('letters', digits: false, min: 3),
      _Rule('serial', digits: true, min: 3),
    ],
    'be.temporary': <_Rule>[
      _Rule('kind', digits: false, min: 2),
      _Rule('number', digits: true, min: 2),
      _Rule('letters', digits: false, min: 3),
    ],
    'be.vintage': <_Rule>[
      _Rule('series', digits: true, min: 3),
      _Rule('serial', digits: true, min: 3),
    ],
    'be.diplomatic': <_Rule>[
      _Rule('letters', digits: false, min: 2),
      _Rule('serial', digits: true, min: 3),
    ],
    'be.royal': <_Rule>[_Rule('number', digits: true, min: 1, max: 2)],
    'be.military': <_Rule>[_Rule('serial', digits: true, min: 5)],
  };

  @override
  PlateValidation validate(PlateEntry entry) {
    final PlateValidation? refused = restrictionVerdict(entry);
    if (refused != null) return refused;
    final List<_Rule> rules = _rules[entry.spec.id] ?? const <_Rule>[];
    if (rules.every((r) => entry.group(r.key).isEmpty)) {
      return const PlateValidation.valid();
    }
    for (final _Rule r in rules) {
      final String v = entry.group(r.key);
      if (v.length < r.min || v.length > r.max) {
        return const PlateValidation.invalid(reasonLength);
      }
      final bool allDigits = isDigits(v);
      final bool noDigits = !v.codeUnits.any((u) => u >= 0x30 && u <= 0x39);
      if (r.digits ? !allDigits : !noDigits) {
        return const PlateValidation.invalid(reasonKind);
      }
    }
    if (entry.spec.id == 'be.dealer') {
      final String l = entry.group('letters');
      if (l[0] != 'Z' || l[1] == 'Z') {
        return const PlateValidation.invalid(reasonDealer);
      }
    }
    return const PlateValidation.valid();
  }
}
