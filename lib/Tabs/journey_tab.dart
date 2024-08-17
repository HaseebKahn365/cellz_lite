import 'dart:developer';

import 'package:cellz_lite/Tabs/all_unlocked_levels.dart';
import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/game_play_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

// ignore: must_be_immutable
class JourneyTab extends StatelessWidget {
  JourneyTab({
    super.key,
  }) {}

  int frontIndex = 0, backIndex = 0;
  void findRange() {
    //there are levels in the list of levels from 0 to 64. we need to find 5 levels near the current level and display them in the timeline.
    final currentLevel = userProvider.currentLevelIndex;

    frontIndex = backIndex = userProvider.currentLevelIndex;
    for (int i = 1; i <= 1; i++) {
      if (backIndex > 0) {
        backIndex--;
      } else {
        frontIndex++;
      }

      if (frontIndex < 64) {
        frontIndex++;
      } else {
        backIndex--;
      }
    }
    log('backIndex: $backIndex, frontIndex: $frontIndex');
    for (int i = backIndex; i <= frontIndex; i++) {
      timelineTiles.add(
        MyTimeLineTile(
          isFirst: i == backIndex,
          isLast: i == frontIndex,
          isCurrent: i == currentLevel,
          isPassed: i < currentLevel,
          isExpanded: i == currentLevel,
          currentLevel: i,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      timelineTiles = [];
      findRange();

      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...timelineTiles,
              //an elevated button to show all levels.
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      //Navigate to the levels screen ..it will have details of each level. all levels that the user has unlocked will be shown.
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          fullscreenDialog: true,
                          pageBuilder: (context, animation, secondaryAnimation) => AllUnlockedLevels(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.easeOutQuint;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(position: offsetAnimation, child: child);
                          },
                          transitionDuration: Duration(milliseconds: 1000),
                        ),
                      );
                    },
                    child: Text('Show All Levels'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> timelineTiles = [];
}

class MyTimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPassed;
  final bool isCurrent;
  final bool isExpanded;
  final int currentLevel;

  const MyTimeLineTile({
    super.key,
    this.isFirst = false,
    this.isLast = false,
    this.isPassed = false,
    this.isCurrent = false,
    this.isExpanded = false,
    required this.currentLevel,
  });

  Widget? getExpansionIcon() {
    if (!(isCurrent || isPassed)) {
      return SizedBox.shrink();
    } else {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 30,
        height: 30,
        color: Colors.transparent,
        indicator: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: Center(
            child: isCurrent
                ? Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 15,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  )
                : isPassed
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        size: 20,
                      )
                    : Icon(
                        size: 15,
                        Icons.lock_outline_rounded,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
          ),
        ),
      ),
      endChild: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12), // Adjust this value for more or less rounding
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Should match the above borderRadius
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Should match the above borderRadius
            ),
            trailing: getExpansionIcon(),
            enabled: (isCurrent || isPassed),
            initiallyExpanded: isExpanded,
            childrenPadding: const EdgeInsets.all(0),
            title: Text(
              'Level ${levels[currentLevel].id}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(children: [
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Grid ${levels[currentLevel].xPoints}x${levels[currentLevel].yPoints}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            isPassed ? '' : 'Locked',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Grade - ${levels[currentLevel].grade}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
