// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:audioplayers/audioplayers.dart';
import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SettingsContainer(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      AudioPlayer().play(AssetSource('audio/profile.wav'));

                      _navigateToSettings(context);
                    },
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            child: Stack(children: [
                              //add a settings icon button to the top right corner
                              Image.asset(
                                'assets/images/p${userProvider.avatarIndex + 1}.jpg',
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 90,
                                right: 90,
                                child: IconButton(
                                  iconSize: 12,
                                  icon: Icon(Icons.settings),
                                  onPressed: () {
                                    _navigateToSettings(context);
                                  },
                                ),
                              ),
                            ]),
                          )),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            userProvider.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          BuildRow("Score", userProvider.score.toString()),
                          BuildRow("Wins", userProvider.wins.toString()),
                          BuildRow("Losses", userProvider.losses.toString()),
                          BuildRow("Lives", userProvider.lives.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: BuildLives(userProvider.lives),
                      ),
                      (userProvider.lives >= 10)
                          ? const SizedBox.shrink()
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                // Animated blurred background

                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width: 120, // Adjust as needed
                                    height: 40, // Adjust as needed
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ).animate(onPlay: (controller) => controller.repeat(reverse: true)).blurXY(
                                        duration: const Duration(seconds: 1),
                                        begin: 0,
                                        end: 12,
                                      ),
                                ),

                                // Button

                                Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        AudioPlayer().play(AssetSource('audio/tap.wav'), volume: 0.3);

                                        userProvider.incrementLife();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      label: Text('Get Life'),
                                      icon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
                                            duration: const Duration(milliseconds: 1200),
                                            begin: Offset(1, 1),
                                            end: Offset(1.2, 1.2),
                                          ),
                                    )),
                              ],
                            )
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Make sure these widgets are defined or imported
class BuildRow extends StatelessWidget {
  final String label;
  final String value;

  const BuildRow(this.label, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}

class BuildLives extends StatelessWidget {
  final int lives;

  const BuildLives(this.lives, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Animate(
          effects: [
            (index + 1 == lives)
                ? const ScaleEffect(
                    begin: Offset(0.5, 0.5),
                    end: Offset(1.0, 1.0),
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                  )
                : const ScaleEffect(
                    begin: Offset(1.0, 1.0),
                    end: Offset(1.0, 1.0),
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                  ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(
              index < lives ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
              size: index < lives ? 20 : 10,
            ),
          ),
        ),
      ),
    );
  }
}
