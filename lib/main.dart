import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

final userProvider = UserProvider();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  await userProvider.loadAllPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: userProvider),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cellz',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            colorSchemeSeed: ThemeProvider.colorSeeds[themeProvider.colorSelected].color,
            useMaterial3: themeProvider.useMaterial3,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: ThemeProvider.colorSeeds[themeProvider.colorSelected].color,
            useMaterial3: themeProvider.useMaterial3,
            brightness: Brightness.dark,
          ),
          home: Home(),
        );
      },
    );
  }
}
