import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  int colorSelected = 0;
  int imageSelected = 0;
  ColorScheme? imageColorScheme = const ColorScheme.light();
  bool useColorSeed = true;
  double bgOpacity = 0.030;
  int wallpaperIndex = 0;
  int colorIndex = 0;

  SharedPreferences? _prefs;

  ThemeProvider() {
    _loadPreferences();
  }

  bool get useLightMode {
    if (themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.window.platformBrightness == Brightness.light;
    }
    return themeMode == ThemeMode.light;
  }

  static const List<ColorSeed> colorSeeds = [
    ColorSeed('M3 Baseline', Color(0xff6750a4)),
    ColorSeed('Indigo', Colors.indigo),
    ColorSeed('Blue', Colors.blue),
    ColorSeed('Teal', Colors.teal),
    ColorSeed('Green', Colors.green),
    ColorSeed('Yellow', Colors.yellow),
    ColorSeed('Orange', Colors.orange),
    ColorSeed('Deep Orange', Colors.deepOrange),
    ColorSeed('Pink', Colors.pink),
  ];

  static const List<ColorImageProvider> colorImageProviders = [
    ColorImageProvider('Leaves', 'assets/images/leaves.png'),
    ColorImageProvider('Peonies', 'assets/images/peonies.jpg'),
    ColorImageProvider('Bubbles', 'assets/images/bubbles.jpg'),
    ColorImageProvider('Seaweed', 'assets/images/seaweed.jpg'),
    ColorImageProvider('Sea Grapes', 'assets/images/seagrapes.jpg'),
    ColorImageProvider('Petals', 'assets/images/petals.jpg'),
  ];

  static const List<ScreenSelected> screens = [
    ScreenSelected('Component', 0),
    ScreenSelected('Color', 1),
    ScreenSelected('Typography', 2),
    ScreenSelected('Elevation', 3),
  ];

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    useMaterial3 = _prefs?.getBool('useMaterial3') ?? true;
    themeMode = ThemeMode.values[_prefs?.getInt('themeMode') ?? ThemeMode.system.index];
    colorSelected = _prefs?.getInt('colorSelected') ?? 0;
    imageSelected = _prefs?.getInt('imageSelected') ?? 0;
    useColorSeed = _prefs?.getBool('useColorSeed') ?? true;
    bgOpacity = _prefs?.getDouble('bgOpacity') ?? 0.030;
    wallpaperIndex = _prefs?.getInt('wallpaperIndex') ?? 0;
    colorIndex = _prefs?.getInt('colorIndex') ?? 0;
    notifyListeners();
  }

  Future<void> _savePreference(String key, dynamic value) async {
    if (_prefs == null) return;
    if (value is bool) {
      await _prefs!.setBool(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    } else if (value is String) {
      await _prefs!.setString(key, value);
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    _savePreference('themeMode', mode.index);
    notifyListeners();
  }

  void toggleThemeMode() {
    if (themeMode == ThemeMode.system) {
      setThemeMode(useLightMode ? ThemeMode.dark : ThemeMode.light);
    } else {
      setThemeMode(useLightMode ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setThemeMode(useLightMode ? ThemeMode.light : ThemeMode.dark);
  }

  void handleMaterialVersionChange() {
    useMaterial3 = !useMaterial3;
    _savePreference('useMaterial3', useMaterial3);
    notifyListeners();
  }

  void handleColorSelect(int value) {
    useColorSeed = true;
    colorSelected = value;
    _savePreference('useColorSeed', useColorSeed);
    _savePreference('colorSelected', colorSelected);
    notifyListeners();
  }

  void handleImageSelect(int value) {
    final String assetPath = colorImageProviders[value].assetPath;
    ColorScheme.fromImageProvider(provider: AssetImage(assetPath)).then((newScheme) {
      useColorSeed = false;
      imageSelected = value;
      imageColorScheme = newScheme;
      _savePreference('useColorSeed', useColorSeed);
      _savePreference('imageSelected', imageSelected);
      notifyListeners();
    });
  }

  void handleBackgroundOpacity(double value) {
    bgOpacity = value;
    _savePreference('bgOpacity', bgOpacity);
    notifyListeners();
  }

  void updateWallpaperIndex(int index) {
    wallpaperIndex = index;
    _savePreference('wallpaperIndex', wallpaperIndex);
    notifyListeners();
  }

  void updateColorIndex(int index) {
    colorIndex = index;
    _savePreference('colorIndex', colorIndex);
    notifyListeners();
  }
}

class ColorSeed {
  final String label;
  final Color color;

  const ColorSeed(this.label, this.color);
}

class ColorImageProvider {
  final String label;
  final String assetPath;

  const ColorImageProvider(this.label, this.assetPath);
}

class ScreenSelected {
  final String label;
  final int value;

  const ScreenSelected(this.label, this.value);
}
