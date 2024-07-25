import 'package:cellz_lite/providers/constants.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;
  ColorImageProvider imageSelected = ColorImageProvider.leaves;
  ColorScheme? imageColorScheme = const ColorScheme.light();
  ColorSelectionMethod colorSelectionMethod = ColorSelectionMethod.colorSeed;
  double bgOpacity = 0.030;

  bool get useLightMode => themeMode == ThemeMode.light || (themeMode == ThemeMode.system && WidgetsBinding.instance.window.platformBrightness == Brightness.light);

  void handleBrightnessChange(bool useLightMode) {
    themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void handleMaterialVersionChange() {
    useMaterial3 = !useMaterial3;
    notifyListeners();
  }

  void handleColorSelect(int value) {
    colorSelectionMethod = ColorSelectionMethod.colorSeed;
    colorSelected = ColorSeed.values[value];
    notifyListeners();
  }

  void handleImageSelect(int value) {
    final String assetPath = ColorImageProvider.values[value].assetPath;
    ColorScheme.fromImageProvider(provider: AssetImage(assetPath)).then((newScheme) {
      colorSelectionMethod = ColorSelectionMethod.image;
      imageSelected = ColorImageProvider.values[value];
      imageColorScheme = newScheme;
      notifyListeners();
    });
  }

  void handleBackgroundOpacity(double value) {
    bgOpacity = value;
    notifyListeners();
  }
}
