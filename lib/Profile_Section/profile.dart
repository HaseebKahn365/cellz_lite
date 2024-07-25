// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

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
                  Container(
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
                      child: (userProvider.imageUrl.isNotEmpty)
                          ? Container(
                              child: Stack(children: [
                                CachedNetworkImage(
                                  imageUrl: userProvider.imageUrl,
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),

                                //display the country flag at the bottom right corner
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: (userProvider.countryCode.isEmpty)
                                        ? const SizedBox.shrink()
                                        : CachedNetworkImage(
                                            imageUrl: 'https://flagcdn.com/h60/${userProvider.countryCode.toLowerCase()}.png',
                                            height: 25,
                                            width: 35,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                  ),
                                ),
                              ]),
                            )
                          : Icon(
                              Icons.person,
                              size: 80,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
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
                          Text(
                            userProvider.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 19),
                          BuildRow("Score", userProvider.score.toString()),
                          BuildRow("Wins", userProvider.wins.toString()),
                          BuildRow("Losses", userProvider.losses.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                    child: Text('Lives: ${userProvider.hearts}'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: BuildLives(userProvider.hearts),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Implement get life functionality
                            // You might want to call a method in UserProvider here
                            userProvider.incrementLives();
                          },
                          label: Text('Get Life'),
                          icon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
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
        (index) => Icon(
          index < lives ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

// class BuildRow extends StatelessWidget {
//   final String left;
//   final String right;
//   const BuildRow(
//     this.left,
//     this.right, {
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           left,
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//         Text(
//           right,
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//       ],
//     );
//   }
// }

// class BuildLives extends StatelessWidget {
//   final int lives;
//   const BuildLives(
//     this.lives, {
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(
//         5,
//         (index) => Icon(
//           index < lives ? Icons.favorite : Icons.favorite_border,
//           color: index < lives ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondary.withOpacity(0.3),
//         ),
//       ),
//     );
//   }
// }
