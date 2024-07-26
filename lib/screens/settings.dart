import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/providers/theme_provider.dart';
import 'package:cellz_lite/sections/subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class SettingsContainer extends StatefulWidget {
  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    double _sliderValue = themeProvider.bgOpacity;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Placeholder for alignment
                  SizedBox(width: 48),

                  // Centered text
                  Text(
                    'Personalize',
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  // Close icon button
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        opticalSize: 23,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
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
                      SwitchListTile(
                        title: const Text('Dark Mode'),
                        value: !themeProvider.useLightMode,
                        onChanged: (value) {
                          themeProvider.handleBrightnessChange(!value);
                        },
                      ),
                      ListTile(
                        title: const Text('Select Color'),
                      ),
                      SizedBox(
                        height: 200,
                        child: generateColorRows(themeProvider),
                      ),
                      ListTile(
                        title: const Text('Select Image'),
                      ),
                      SizedBox(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ThemeProvider.colorImageProviders.length,
                          padding: const EdgeInsets.all(0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                          ),
                          itemBuilder: (context, index) {
                            final currentImage = ThemeProvider.colorImageProviders[index];
                            return InkWell(
                              onTap: () {
                                themeProvider.handleImageSelect(index);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: themeProvider.imageSelected == index ? Theme.of(context).colorScheme.secondaryContainer : Colors.transparent,
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        currentImage.assetPath,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                  if (themeProvider.imageSelected == index)
                                    Center(
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Background Opacity'),
                      ),
                      Slider(
                        thumbColor: Theme.of(context).colorScheme.secondaryContainer,
                        value: _sliderValue,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                          themeProvider.handleBackgroundOpacity(value);
                        },
                        onChangeEnd: (value) {
                          themeProvider.handleBackgroundOpacity(value);
                        },
                        min: 0.01,
                        max: 0.2,
                        label: 'Opacity: ${(_sliderValue * 100).toStringAsFixed(0)}%', // Updated label to show percentage
                      ),
                      Container(
                        height: 100,
                        width: double.infinity,
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: Opacity(
                                opacity: _sliderValue, // Use the slider value for opacity
                                child: Image.asset(
                                  ThemeProvider.colorImageProviders[themeProvider.imageSelected].assetPath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 96,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Subscription section
              SubscriptionSettings(),
              // Creating a separate section for account
              AccountSettings(),
              const SizedBox(
                height: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateColorRows(ThemeProvider themeProvider) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: ThemeProvider.colorSeeds.length,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 8,
        mainAxisExtent: 50,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final bool isSelected = themeProvider.colorSelected == index;

        return InkWell(
          onTap: () {
            themeProvider.handleColorSelect(index);
          },
          child: Stack(
            children: [
              Animate(
                effects: [
                  if (isSelected)
                    const ScaleEffect(
                      duration: Duration(milliseconds: 300),
                      begin: Offset(0.9, 0.9),
                      end: Offset(1, 1),
                      curve: Curves.easeOutBack,
                    )
                ],
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 20, vertical: isSelected ? 0 : 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeProvider.colorSeeds[index].color.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final _formKey = GlobalKey<FormState>();
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Account',
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
                    ListTile(
                      title: const Text('I am'),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          width: 2,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: userProvider.name,
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _isError ? Colors.red : Theme.of(context).colorScheme.secondaryContainer,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                _isError = true;
                              });
                              return 'Name cannot be empty';
                            } else if (value.length <= 3 || value.length >= 18) {
                              setState(() {
                                _isError = true;
                              });
                              return 'Name must be between 3 and 18 characters';
                            }
                            setState(() {
                              _isError = false;
                              FocusScope.of(context).unfocus();
                            });
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              userProvider.changeName(value);
                            }
                          },
                        ),
                      ),

                      //another list tile for selecting profile picture using a gridview
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text('Select Profile Picture'),
                    ),
                    SizedBox(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6,
                        padding: const EdgeInsets.all(0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          bool isSelected = userProvider.avatarIndex == index;

                          return InkWell(
                            onTap: () {
                              userProvider.updateAvatarIndex(index);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(isSelected ? 0 : 15),
                                  child: Animate(
                                    effects: [
                                      if (isSelected)
                                        const ScaleEffect(
                                          duration: Duration(milliseconds: 800),
                                          begin: Offset(0.8, 0.8),
                                          end: Offset(1, 1),
                                          curve: Curves.easeOutCirc,
                                        )
                                    ],
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected ? Theme.of(context).colorScheme.secondaryContainer : Colors.transparent,
                                          width: isSelected ? 5 : 0,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          'assets/images/p${index + 1}.jpg',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
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
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
