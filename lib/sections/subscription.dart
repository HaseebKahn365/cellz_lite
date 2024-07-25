import 'package:flutter/material.dart';

class SubscriptionSettings extends StatefulWidget {
  const SubscriptionSettings({Key? key}) : super(key: key);

  @override
  State<SubscriptionSettings> createState() => _SubscriptionSettingsState();
}

class _SubscriptionSettingsState extends State<SubscriptionSettings> {
  int selectedIndex = 0; // 0 for Basic, 1 for Premium

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          'Unlock Premium',
          style: TextStyle(
            fontSize: 30,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondaryContainer,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSubscriptionOption(
                  context,
                  index: 0,
                  title: 'Basic',
                  subtitle: 'Free',
                  icon: Icons.circle_outlined,
                ),
                const Divider(),
                _buildSubscriptionOption(
                  context,
                  index: 1,
                  title: 'Premium',
                  subtitle: '\$5',
                  icon: Icons.diamond_outlined,
                ),
                const SizedBox(height: 20),
                PremiumFeatures(),
              ],
            ),
          ),
        ),
        // Premium features
      ],
    );
  }

  Widget _buildSubscriptionOption(
    BuildContext context, {
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          splashColor: colorScheme.primary.withOpacity(0.12),
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.secondaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
                  ),
                  child: Icon(icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
                        ),
                        child: Text(title),
                      ),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 500),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
                        ),
                        child: Text(subtitle),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Icon(
                    Icons.check,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumFeatures extends StatelessWidget {
  const PremiumFeatures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            'Premium Features',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureButton(context, 'Save Progress'),
              _buildFeatureButton(context, 'Unlimited Lives (No Ads)'),
              _buildFeatureButton(context, 'Account Recovery'),
              _buildFeatureButton(context, 'Premium Themes'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilledButton.tonal(
        onPressed: null, // Disabled for design purposes
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
      ),
    );
  }
}
