import 'dart:developer';

import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

void showGlobalModelBottomSheet({required BuildContext context, required bool showCarousel}) {
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
        child: AwardWidget(showCarousel: showCarousel),
      );
    },
  );
}

class AwardWidget extends StatelessWidget {
  const AwardWidget({
    super.key,
    required this.showCarousel,
  });

  final bool showCarousel;

  String getTimeString(int level) {
    final bestTime = levelStars[level - 1].thresholdSeconds;
    return '${(bestTime ~/ 60).toString().padLeft(2, '')}:${(bestTime % 60).toString().padLeft(2, '0')}';
  }

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
                (userProvider.currentLevelIndex == 64) ? 'Wow! final level!' : 'You still have ${65 - userProvider.currentLevelIndex == 64} levels to go!',
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

          //!Here is the CarouselView:
          SizedBox(
            height: 120,
            child: RawScrollbar(
              // controller: controller,
              thumbColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              radius: Radius.circular(20),
              thickness: 3,
              thumbVisibility: true,
              trackVisibility: true,
              trackRadius: Radius.circular(30),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              // onPrimary
              trackColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: CarouselView(
                itemExtent: MediaQuery.sizeOf(context).width - 210,
                elevation: 1,
                shrinkExtent: 1,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                onTap: (index) {
                  log('listening to taps of $index');
                },
                children: List.generate(
                  levelStars.length,
                  (uIndex) {
                    return Container(
                      //stop recieving taps

                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Level ${uIndex + 1}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //showing stars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => Icon(
                                (levelStars[uIndex].stars) > index ? Icons.star : Icons.star_border_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 10,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          //an outline play button
                          SizedBox(
                            height: 25,
                            child: OutlinedButton(
                              onPressed: () {
                                audioService.playSfx(MyComponent.BUTTON);
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Play',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

// Second Bullet: Criteria for Stars Table
          const SizedBox(
            height: 10,
          ),
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
                              _buildTableRow('<60', '70%', time: 'Respective', context),
                              _buildTableRow('60', '80%', time: getTimeString(60), context),
                              _buildTableRow('61', '82%', time: getTimeString(61), context),
                              _buildTableRow('62', '85%', time: getTimeString(62), context),
                              _buildTableRow('63', '87%', time: getTimeString(63), context),
                              _buildTableRow('64', '90%', time: getTimeString(64), context),
                              _buildTableRow('65', '95%', time: getTimeString(65), context),
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
          if (!showCarousel)
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
                      audioService.playSfx(MyComponent.BUTTON);

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
  //another row to show threshold time for each level
  TableRow _buildTableRow(String level, String winPercentage, BuildContext context, {bool isHeader = false, String time = ''}) {
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
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              (time.isEmpty) ? 'Time Limit' : time,
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
