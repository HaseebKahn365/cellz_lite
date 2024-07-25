import 'dart:developer';

import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/dealing_with_data/db_service.dart';
import 'package:cellz_lite/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cellz_lite/providers/constants.dart';
import 'package:cellz_lite/providers/theme_provider.dart';
import 'package:cellz_lite/screens/play_with_friend.dart';
import 'package:uni_links/uni_links.dart';
import 'package:uuid/uuid.dart';
import 'home.dart';

DatabaseService dbService = DatabaseService();
final userProvider = UserProvider(
  uuid: Uuid().v4().substring(0, 7),
  createdOn: DateTime.now().millisecondsSinceEpoch,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Handle initial deep link
  final initialUri = await getInitialUri();
  String initialRoute = '/';
  if (initialUri != null) {
    log('Received initial URI: $initialUri');
    initialRoute = initialUri.toString();
  } else {
    log('No initial URI received');
  }

  await dbService.open();

  await userProvider.retrieveUser(); // Fetch user data when app starts

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SenderProvider()),
        ChangeNotifierProvider(create: (_) => JoinerProvider()),
        ChangeNotifierProvider.value(value: userProvider),
      ],
      child: App(initialRoute: initialRoute),
    ),
  );
}

class App extends StatelessWidget {
  final String initialRoute;

  const App({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Home(),
        ),
        GoRoute(
          path: '/refer',
          builder: (context, state) {
            final uri = Uri.parse(state.uri.toString());
            final code = uri.queryParameters['code'];
            log('Uri before parsing is : ${state.uri}');
            log('Received referral code from the URI is : $code');
            return PlayWithFriend(referralCode: code);
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.error}'),
        ),
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Material 3',
          routerConfig: router,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            colorSchemeSeed: themeProvider.colorSelectionMethod == ColorSelectionMethod.colorSeed ? themeProvider.colorSelected.color : null,
            colorScheme: themeProvider.colorSelectionMethod == ColorSelectionMethod.image ? themeProvider.imageColorScheme : null,
            useMaterial3: themeProvider.useMaterial3,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: themeProvider.colorSelectionMethod == ColorSelectionMethod.colorSeed ? themeProvider.colorSelected.color : themeProvider.imageColorScheme!.primary,
            useMaterial3: themeProvider.useMaterial3,
            brightness: Brightness.dark,
          ),
        );
      },
    );
  }
}
