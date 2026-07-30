import 'package:flutter/material.dart';

/// This class contains all the BorderRadius constants used in the features folder
/// All border radius values should be referenced from here to maintain consistency
class AppBorders {
  AppBorders._();

  // Common border radius values
  static const BorderRadius radius2 = BorderRadius.all(Radius.circular(2));
  static const BorderRadius radius4 = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radius8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radius10 = BorderRadius.all(Radius.circular(10));
  static const BorderRadius radius12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radius20 = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radius24 = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radius30 = BorderRadius.all(Radius.circular(30));
  
  // Named border radius for specific components
  static const BorderRadius messageBoxRadius = radius10;
  static const BorderRadius messageIconRadius = radius8;
  static const BorderRadius investorBoxRadius = radius10;
  static const BorderRadius buttonRadius = radius4;
  static const BorderRadius cardRadius = radius8;
  static const BorderRadius dialogRadius = BorderRadius.all(Radius.circular(25));
  
  // Individual corner border radius
  static const BorderRadius topRadius10 = BorderRadius.vertical(
    top: Radius.circular(10),
  );
  
  static const BorderRadius bottomRadius10 = BorderRadius.vertical(
    bottom: Radius.circular(10),
  );
}