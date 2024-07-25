import 'package:cellz_lite/providers/theme_provider.dart';
import 'package:cellz_lite/screens/play_with_friend.dart';
import 'package:flutter/material.dart';

class SpecialTab extends StatelessWidget {
  const SpecialTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.secondaryContainer.withOpacity(
          ThemeProvider().bgOpacity,
        );
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Card(
            elevation: 0,
            color: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  //navigator.push to play with friends screen
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayWithFriend()));
                },
                child: ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Play with Friends'),
                  subtitle: Text('Play with your friends'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
