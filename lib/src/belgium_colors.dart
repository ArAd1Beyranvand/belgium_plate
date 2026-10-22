import 'package:flutter/widgets.dart';

/// The colours a Belgian plate is printed in, the modal colour of a region of
/// the flattened references (`.plateref/be`, 520×110 mm). The photographs are
/// white-balanced by the offline stage, not by eye.
abstract final class BelgiumColors {
  static const Color white = Color(0xFFFFFFFF);

  /// Ink and frame of the standard plate: the printed rim reads 9E0219, the
  /// ink A10A1B on the clean 2010 photo.
  static const Color red = Color(0xFFA10A1B);

  /// Dealer ink, from the 2018 dealer plate.
  static const Color dealerGreen = Color(0xFF137855);

  /// Temporary and export field, from the 2016 export plate.
  static const Color temporaryRed = Color(0xFFC0121E);

  /// Temporary and export ink.
  static const Color temporaryInk = Color(0xFFE0ECEF);

  /// Military ink on its white field.
  static const Color militaryBlack = Color(0xFF302F34);

  /// The Euroband field, sampled off the standard plate.
  static const Color euroBlue = Color(0xFF2F5AB9);

  /// The military plate's tricolour, sampled off its decal.
  static const Color flagBlack = Color(0xFF282327);
  static const Color flagYellow = Color(0xFFBEA11F);
  static const Color flagRed = Color(0xFFB91827);

  static const Color inactiveOnLight = Color(0xFFB0B0B0);
  static const Color inactiveOnDark = Color(0xFF8A8A8A);
}
