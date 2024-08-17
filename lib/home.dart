// ignore_for_file: prefer_const_constructors

// import 'package:animations/animations.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cellz_lite/Profile_Section/current_level_clipper.dart';
import 'package:cellz_lite/Profile_Section/profile.dart';
import 'package:cellz_lite/Tabs/journey_tab.dart';
import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:cellz_lite/providers/theme_provider.dart';
import 'package:cellz_lite/sections/dial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final result = await _showExitDialog(context);
        if (result == true) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ThemeProvider.colorImageProviders[themeProvider.imageSelected].assetPath),
                    fit: BoxFit.cover,
                    opacity: themeProvider.bgOpacity,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                        border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ProfileWidget(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: const [
                              Tab(text: 'Overview'),
                              Tab(text: 'Journey'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                OverviewTab(),
                                JourneyTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      barrierColor: Colors.black.withOpacity(0.8),
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.all(0),
        actionsPadding: EdgeInsets.all(0),
        content: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2.0),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Are you sure you want to quit?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton(
                      child: Text('Quit', textAlign: TextAlign.center),
                      onPressed: () {
                        exit(0);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      child: Text('Stay'),
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        //make the surface color primary
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      final nextLevel = (userProvider.currentLevelIndex < 64) ? levels[userProvider.currentLevelIndex + 1] : levels[64];

      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //creating a funky container for the current level that has smooth zig zag border line.

            CurrentLevelContainer(),
            SizedBox(height: 10),
            Center(
              child: FunkyLevelsRadial(
                currentLevel: userProvider.currentLevelIndex + 1,
                totalLevels: 65,
                diameter: 230,
                progressColor: Theme.of(context).colorScheme.primaryFixedDim,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                centerColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                labels: [
                  //levels from 1 to 65 display only the levels that are multiples of 5
                  for (int i = 1; i <= 65; i++)
                    if (i == 1 || i % 11 == 0 || i == 65) LabelData(i * 180 / 65, '$i'),
                ],
                levelTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                subtitleTextStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onPrimary),
                labelTextStyle: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                progressWidth: 10,
                backgroundWidth: 12,
                labelOffset: 10,
              ),
            ),
          ],
        ),
      );
    });
  }
}
