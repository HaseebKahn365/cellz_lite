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
import 'package:cellz_lite/providers/theme_provider.dart';
import 'package:cellz_lite/sections/dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        showModalBottomSheet(
          //make bg black
          barrierColor: Colors.black.withOpacity(0.95),
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: AwardWidget(widget: widget),
            );
          },
        );
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

class AwardWidget extends StatelessWidget {
  const AwardWidget({
    super.key,
    required this.widget,
  });

  final AnimatedRadialDial widget;

  @override
  Widget build(BuildContext context) {
    int sum = 0;
    for (int i = 0; i < levelStars.length; i++) {
      sum += levelStars[i].stars;
    }
    int total = 65 * 3;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                (widget.currentLevel == 65) ? 'Wow! final level!' : 'You still have ${65 - widget.currentLevel} levels to go!',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'Rules',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

// First Bullet: 3 stars in all levels with Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 10.0),
                //   child: Icon(
                //     Icons.circle,
                //     size: 8,
                //     color: Theme.of(context).colorScheme.primary,
                //   ),
                // ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'You must get 3 stars in all levels',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text('My Stars', style: TextStyle(fontSize: 8)),
                              Text('$sum', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(10),
                                value: sum / total,
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text('Total Stars', style: TextStyle(fontSize: 8)),
                              Text('$total', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

// Second Bullet: Criteria for Stars Table
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 10.0),
                //   child: Icon(
                //     Icons.circle,
                //     size: 8,
                //     color: Theme.of(context).colorScheme.primary,
                //   ),
                // ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Here is the criteria for stars:',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Table(
                            border: TableBorder.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            columnWidths: const {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(1),
                            },
                            children: [
                              _buildTableRow('Level', 'For 3 Stars', context, isHeader: true),
                              _buildTableRow('<60', '70%', context),
                              _buildTableRow('60', '80%', context),
                              _buildTableRow('61', '82%', context),
                              _buildTableRow('62', '85%', context),
                              _buildTableRow('63', '87%', context),
                              _buildTableRow('64', '90%', context),
                              _buildTableRow('65', '95%', context),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Rotating Dotted Circle with "$100"
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform(
                  alignment: Alignment.center,
                  //flip it
                  transform: Matrix4.rotationY(3.14),
                  child: Animate(
                    effects: [RotateEffect(duration: 200.seconds, end: 12)],
                    child: Image.asset(
                      color: Theme.of(context).colorScheme.primary,
                      'assets/images/circ.png',
                      width: 160,
                      height: 160,
                    ),
                  ),
                ),
                Animate(
                  effects: [
                    RotateEffect(
                      duration: 200.seconds,
                      end: 10,
                      alignment: Alignment.center,
                    ),
                  ],
                  child: Image.asset(
                    color: Theme.of(context).colorScheme.primary,
                    'assets/images/dotcirc.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AudioPlayer().play(
                        AssetSource(
                          'audio/next.wav',
                        ),
                        volume: 0.09);

                    //Displaying an alert dialogue box that has the following content:
                    /*
                    first we have to identify wether the user has completed all levels with 3 stars using sum == total
                    if he has then we will display the codeShare content
                    else we will display the steps to get the reward which are as follows:
                    - Gain 195 stars
                    - Copy the generated code and send it to the admin
                    - You will get the reward in 24 hours
                     */

                    // sum = total;
                    showDialog(
                        context: context,
                        builder: (context) {
                          String code = '';
                          if (sum == total) {
                            //user provider and current date of month + 365
                            code = '${userProvider.name}${DateTime.now().day + 365}';
                          }
                          return AlertDialog(
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
                                      (sum == total) ? 'CodeShare' : 'Reward Steps',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
                                    if (sum != total) ...[
                                      // Text('Step 1.'),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Gain 195 stars', style: TextStyle(fontSize: 15)),
                                          const SizedBox(width: 10),
                                          Icon(
                                            Icons.star_border_rounded,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      // Text('Step 2.'),
                                      // Text('Copy the generated code', style: TextStyle(fontSize: 15)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Copy the generated code', style: TextStyle(fontSize: 15)),
                                          const SizedBox(width: 10),
                                          Icon(Icons.copy, color: Theme.of(context).colorScheme.primary, size: 15),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      // Text('Step 3.'),
                                      // Text('Send it to the admin', style: TextStyle(fontSize: 15)),
                                      const SizedBox(height: 10),
                                      // Text('You will get the reward in 24 hours', style: TextStyle(fontSize: 15)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Send it to the admin', style: TextStyle(fontSize: 15)),
                                          const SizedBox(width: 10),
                                          Icon(Icons.send, color: Theme.of(context).colorScheme.primary, size: 15),
                                        ],
                                      ),
                                    ] else ...[
                                      Text('Code: $code', style: TextStyle(fontSize: 15)),
                                      const SizedBox(height: 10),
                                      Text('Send this code to admin', style: TextStyle(fontSize: 15)),
                                    ],
                                    const SizedBox(height: 20),
                                    (sum == total)
                                        ? Center(
                                            child: ElevatedButton(
                                              child: Text('Share Code'),
                                              style: ElevatedButton.styleFrom(
                                                elevation: 10,
                                                //make the surface color primary
                                                backgroundColor: Theme.of(context).colorScheme.primary,
                                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                              ),
                                              onPressed: () {
                                                //Copy  the code to clipboard
                                                Clipboard.setData(ClipboardData(text: '$code completed the game\nWhatsApp: 03491777261'));
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('Code copied to clipboard'),
                                                  duration: Duration(seconds: 2),
                                                ));
                                              },
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        // style: BorderStyle.dotted
                        width: 3,
                      ),
                      // borderRadius: BorderRadius.circular(75),
                    ),
                    child: Center(
                      child: Text(
                        '\$100',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.inverseSurface),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // !Helper method to build table rows
  TableRow _buildTableRow(String level, String winPercentage, BuildContext context, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.transparent,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              level,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              winPercentage,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
