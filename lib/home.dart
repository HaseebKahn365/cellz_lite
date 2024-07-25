// ignore_for_file: prefer_const_constructors

import 'package:animations/animations.dart';
import 'package:cellz_lite/Profile_Section/current_level_clipper.dart';
import 'package:cellz_lite/Profile_Section/profile.dart';
import 'package:cellz_lite/Tabs/journey_tab.dart';
import 'package:cellz_lite/providers/theme_provider.dart';
import 'package:cellz_lite/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                //   image: NetworkImage(
                //     themeProvider.imageSelected.url,
                //   ),
                //   fit: BoxFit.cover,
                //   opacity,: themeProvider.bgOpacity,
                image: AssetImage(ThemeProvider.colorImageProviders[themeProvider.imageSelected].assetPath),
                fit: BoxFit.cover,
                opacity: themeProvider.bgOpacity,
              )),
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
                      children: [
                        const ProfileWidget(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: OpenContainer(
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedBuilder: (context, action) {
                              return IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: action,
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondaryContainer),
                                ),
                              );
                            },
                            openBuilder: (context, action) {
                              return SettingsContainer();
                            },
                            transitionDuration: const Duration(milliseconds: 300),
                            openColor: Theme.of(context).colorScheme.secondaryContainer,
                            closedColor: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Here we are gonna create 3 tabs for Overview, Journey, Special

                Expanded(
                  flex: 2,
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: const [
                            Tab(
                              text: 'Overview',
                            ),
                            Tab(
                              text: 'Journey',
                            ),
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
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //creating a funky container for the current level that has smooth zig zag border line.

          CurrentLevelContainer(),
          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Level',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '2',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),

                  //create a text for showing the grid of the level ie.3x3
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grid 3x3',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        //showing the number of attempts made
                        'Locked',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Grade - Adrenaline Rush',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
