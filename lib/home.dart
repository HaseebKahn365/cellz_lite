// ignore_for_file: prefer_const_constructors

// import 'package:animations/animations.dart';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cellz_lite/Profile_Section/current_level_clipper.dart';
import 'package:cellz_lite/Profile_Section/profile.dart';
import 'package:cellz_lite/Tabs/journey_tab.dart';
import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/audio_service.dart';
import 'package:cellz_lite/providers/theme_provider.dart';
import 'package:cellz_lite/sections/bottom_sheet_widget.dart';
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
    AudioPlayer().play(
        AssetSource(
          'audio/quit.wav',
        ),
        volume: 0.4);

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

                //a huge shut down icoon
                Icon(
                  Icons.cancel_outlined,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton(
                      child: Text('Yes', textAlign: TextAlign.center),
                      //change ooutline color
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black.withOpacity(0)),
                      ),
                      onPressed: () {
                        audioService.playSfx(MyComponent.BUTTON);
                        exit(0);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      child: Text('No'),
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        //make the surface color primary
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        audioService.playSfx(MyComponent.BUTTON);

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
      // final nextLevel = (userProvider.currentLevelIndex < 64) ? levels[userProvider.currentLevelIndex + 1] : levels[64];

      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentLevelContainer(),
            SizedBox(height: 10),
            Center(
              child: AnimatedRadialDial(
                currentLevel: userProvider.currentLevelIndex + 1,
                totalLevels: 65,
                diameter: 230,
                progressColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                centerColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                labels: [
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

class AnimatedRadialDial extends StatefulWidget {
  final int currentLevel;
  final int totalLevels;
  final double diameter;
  final Color progressColor;
  final Color backgroundColor;
  final Color centerColor;
  final List<LabelData> labels;
  final TextStyle levelTextStyle;
  final TextStyle subtitleTextStyle;
  final TextStyle labelTextStyle;
  final double progressWidth;
  final double backgroundWidth;
  final double labelOffset;

  const AnimatedRadialDial({
    Key? key,
    required this.currentLevel,
    required this.totalLevels,
    required this.diameter,
    required this.progressColor,
    required this.backgroundColor,
    required this.centerColor,
    required this.labels,
    required this.levelTextStyle,
    required this.subtitleTextStyle,
    required this.labelTextStyle,
    required this.progressWidth,
    required this.backgroundWidth,
    required this.labelOffset,
  }) : super(key: key);

  @override
  _AnimatedRadialDialState createState() => _AnimatedRadialDialState();
}

class _AnimatedRadialDialState extends State<AnimatedRadialDial> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  var buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (buttonPressed) return;
        _handleTap();
        buttonPressed = true;
        await Future.delayed(Duration(milliseconds: 400));
        AudioPlayer().play(
            AssetSource(
              'audio/openRadial.wav',
            ),
            volume: 0.1);

        //showing a model bottom sheet to view the procedure of getting reward
        showGlobalModelBottomSheet(context: context, showCarousel: true);

        Future.delayed(Duration(seconds: 1), () {
          buttonPressed = false;
        });
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FunkyLevelsRadial(
              currentLevel: widget.currentLevel,
              totalLevels: widget.totalLevels,
              diameter: widget.diameter,
              progressColor: widget.progressColor,
              backgroundColor: widget.backgroundColor,
              centerColor: widget.centerColor,
              labels: widget.labels,
              levelTextStyle: widget.levelTextStyle,
              subtitleTextStyle: widget.subtitleTextStyle,
              labelTextStyle: widget.labelTextStyle,
              progressWidth: widget.progressWidth,
              backgroundWidth: widget.backgroundWidth,
              labelOffset: widget.labelOffset,
            ),
          );
        },
      ),
    );
  }
}

/*
Following is the content of the AwardWidget:
a central large text that says "Criteria"
then we will have two bullets:
first bullet:
- You must get 3 stars in all levels
  then there should be a progress indicator showing your gained stars against totals stars

second bullet:
- Here is criteria for stars
  a table showing crtieria for stars:
  2 colums : Level, Win %
    if (levelObject.id == 60) return 0.80 * totalScore;
    if (levelObject.id == 61) return 0.82 * totalScore;
    if (levelObject.id == 62) return 0.85 * totalScore;
    if (levelObject.id == 63) return 0.87 * totalScore;
    if (levelObject.id == 64) return 0.9 * totalScore;
    if (levelObject.id == 65) return 0.95 * totalScore;

  At the bottom should be a huge central cirlcle with content '100$'
  it should be beautifully decorate using a doted outlined with loop animmation to make it rotate using flutter animate.
 */

