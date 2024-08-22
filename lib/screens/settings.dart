import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/main.dart';
import 'package:cellz_lite/providers/audio_service.dart';
import 'package:cellz_lite/providers/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as riv;

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
              const SizedBox(height: 60),
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
                        audioService.playSfx(MyComponent.BUTTON);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
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
                          audioService.playSfx(MyComponent.DARKSWITCH);
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
                                audioService.playSfx(MyComponent.BGPICSELECTOR);

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
                      Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Opacity(
                                  opacity: _sliderValue, // Use the slider value for opacity
                                  child: Image.asset(
                                    ThemeProvider.colorImageProviders[themeProvider.imageSelected].assetPath,
                                    fit: BoxFit.fill,
                                    width: 150,
                                    height: 146,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Subscription section
              // SubscriptionSettings(),
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
            audioService.playSfx(MyComponent.COLORCHANGE);

            themeProvider.handleColorSelect(index);
          },
          child: Stack(
            children: [
              Animate(
                effects: [
                  if (isSelected)
                    const ScaleEffect(
                      duration: Duration(milliseconds: 1200),
                      begin: Offset(0.6, 0.3),
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
  bool shouldRender = false;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        shouldRender = true;
      });
    });
  }

  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    nameControlla.dispose();
    super.dispose();
  }

  TextEditingController nameControlla = TextEditingController();

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
                          controller: nameControlla,
                          focusNode: _focusNode,
                          onTap: () {
                            setState(() {
                              //set focus to true
                              _focusNode.requestFocus();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: _focusNode.hasFocus ? "" : userProvider.name,
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _isError ? Colors.red : Theme.of(context).colorScheme.onSecondaryContainer,
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
                            } else if (value.length < 3 || value.length > 18) {
                              setState(() {
                                _isError = true;
                              });
                              return 'Valid name length: 3-18';
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
                          //on canceling editing unfocus
                          onTapOutside: (_) {
                            nameControlla.clear();
                            FocusScope.of(context).unfocus();
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
                              audioService.playSfx(MyComponent.USERPICSELECTOR);
                              userProvider.updateAvatarIndex(index);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(isSelected ? 0 : 17),
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
            (shouldRender) ? BuySection() : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}

class BuySection extends StatelessWidget {
  const BuySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Center(
                child: const Text(
                  '  Buy  lives',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.5,
                  ),
                ),
              ),
            ),

            //offering a 400 lives pack for 10 dollars
            //lets have a container with rive animation as a child and on the right description about the package
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: riv.RiveAnimation.asset(
                      'assets/images/heartgrad.riv',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 35),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get 400 Lives',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'For 10 \$',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                // an incredibly captivative button for buying the package
                // lets have a container with a gradient and a text
              ],
            ),
            const SizedBox(height: 50),

            Container(
                    width: 200,
                    height: 50,
                    //same as the button
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 40,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        )
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        audioService.playSfx(MyComponent.BUYBUTTON);

                        //buying the package
                        //lets have a dialog box to confirm the purchase
                      },
                      icon: Icon(Icons.shopping_cart),
                      label: Text('Buy'),
                    ))
                .animate(
                  onPlay: (controller) => controller.repeat(
                    reverse: true,
                  ), // This makes it loop indefinitely
                )
                .shimmer(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 600),
                  color: Theme.of(context).colorScheme.primary,
                  angle: 45,
                  size: 1.5,
                )
                .then()
                .shake(
                  hz: 1,
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 1000),
                )
                .then()
                .scale(
                  duration: const Duration(milliseconds: 1000),
                  begin: Offset(1, 1),
                  end: Offset(1.1, 1.1),
                ),
            // .then()
            // .scale(
            //   duration: const Duration(milliseconds: 300),
            //   begin: Offset(1, 1),
            //   end: Offset(1.1, 1.1),
            // )
            // .then()
            // .rotate(duration: const Duration(milliseconds: 1000), end: 0.3),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
