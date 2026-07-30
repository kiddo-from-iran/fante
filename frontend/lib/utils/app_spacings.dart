import 'package:flutter/material.dart';

/// This class contains all the SizedBox constants used for spacing in the features folder
/// All spacing should be referenced from here to maintain consistency
class AppSpacings {
  AppSpacings._();

  // Vertical spacings
  static const SizedBox height4 = SizedBox(height: 4);
  static const SizedBox height8 = SizedBox(height: 8);
  static const SizedBox height12 = SizedBox(height: 12);
  static const SizedBox height14 = SizedBox(height: 14);
  static const SizedBox height16 = SizedBox(height: 16);
  static const SizedBox height18 = SizedBox(height: 18);
  static const SizedBox height20 = SizedBox(height: 20);
  static const SizedBox height22 = SizedBox(height: 22);
  static const SizedBox height24 = SizedBox(height: 24);
  static const SizedBox height28 = SizedBox(height: 28);
  static const SizedBox height32 = SizedBox(height: 32);
  static const SizedBox height34 = SizedBox(height: 34);
  static const SizedBox height36 = SizedBox(height: 36);
  static const SizedBox height40 = SizedBox(height: 40);
  static const SizedBox height48 = SizedBox(height: 48);
  
  // Horizontal spacings
  static const SizedBox width4 = SizedBox(width: 4);
  static const SizedBox width6 = SizedBox(width: 6);
  static const SizedBox width8 = SizedBox(width: 8);
  static const SizedBox width12 = SizedBox(width: 12);
  static const SizedBox width14 = SizedBox(width: 14);
  static const SizedBox width16 = SizedBox(width: 16);
  static const SizedBox width20 = SizedBox(width: 20);
  static const SizedBox width24 = SizedBox(width: 24);
  static const SizedBox width32 = SizedBox(width: 32);
  static const SizedBox width48 = SizedBox(width: 48);
  
  // Named aliases for better readability
  static const SizedBox smallVerticalGap = height8;
  static const SizedBox mediumVerticalGap = height16;
  static const SizedBox largeVerticalGap = height24;
  
  static const SizedBox smallHorizontalGap = width8;
  static const SizedBox mediumHorizontalGap = width16;
  static const SizedBox largeHorizontalGap = width24;
}