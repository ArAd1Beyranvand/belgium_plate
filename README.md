FREE PALESTINE 🇮🇷🇵🇸 پاینده ایران

GO VEGAN 🌱

==================================

From the mighty people of Iran to the diligent people of Belgium to view examples:

https://platexample.ir/#/discover/belgium

# belgium_plate

Belgium's licence plates for the `plate_core` library. nine designs (private, dealer, trailer, temporary, vintage, diplomatic, royal, military, motorcycle) in red, green, white-on-red and black themes, with Latin alphabets and an advisory validator.

## Install

```yaml
dependencies:
  plate_core: ^0.12.0
  belgium_plate: ^0.1.0
```

## Use

```dart
import 'package:plate_core/plate_core.dart';
import 'package:belgium_plate/belgium_plate.dart';

PlateCanvas(
  spec: BelgiumPlates.private,
  theme: BelgiumThemes.private,
  validator: const BelgiumValidator(),
  autoValidate: true,
  onChooseCharacter: noCharacterChooser,
);
```

## Contains

- `BelgiumCountry` — country panel: `belgium`.
- `BelgiumPlates` — 8 plate specs: `private`, `plain`, `temporary`, `vintage`, `diplomatic`, `royal`, `military`, `motorcycle`.
- `BelgiumThemes` — 4 themes: `private`, `dealer`, `temporary`, `military`.
- `BelgiumValidator` — advisory validator; flags the frame, never blocks a keystroke.

## Plates

Belgium's plate geometries. Private, dealer and trailer share the
`series-letters-serial` line, temporary its own `letters-digits-letters`;
colours are the theme's.

Not implemented, all discontinued or historic: the blue EU-institution
(`EUR 2602`) and international-staff (`920911`) plates and their 8-ABC-123
successor, which is the standard design; pre-2010 `ABC-123` and
`123-ABC` plates (valid but no longer issued, same design, no Euroband);
the personalised and parliament plates, which are the standard design with
other content. The article's `CD` plate is green or red by embassy; the
photograph is red.

## Part of plate

Painted by [`plate_core`](https://pub.dev/packages/plate_core); alphabets shared through [`plate_alphabet`](https://pub.dev/packages/plate_alphabet); optional character picker in [`plate_keypad`](https://pub.dev/packages/plate_keypad).

