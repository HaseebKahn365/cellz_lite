import 'package:cellz_lite/dealing_with_data/User.dart';
import 'package:cellz_lite/providers/constants.dart';
import 'package:cellz_lite/providers/theme_provider.dart';
import 'package:cellz_lite/sections/subscription.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsContainer extends StatefulWidget {
  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  // double _sliderValue = 0.2;
  //read the slider value from the provider

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    double _sliderValue = themeProvider.bgOpacity;

    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              'Personalize',
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
                    Column(
                      children: generateColorRows(themeProvider),
                    ),
                    ListTile(
                      title: const Text('Select Image'),
                    ),
                    SizedBox(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ColorImageProvider.values.length,
                        padding: const EdgeInsets.all(0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          final currentImage = ColorImageProvider.values[index];
                          return InkWell(
                            onTap: () {
                              themeProvider.handleImageSelect(index);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: themeProvider.imageSelected == currentImage ? Theme.of(context).colorScheme.secondaryContainer : Colors.transparent,
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
                        //todo when the finger is lifted , we should use SharedPreferences to save the settings
                        // themeProvider.saveSettings();
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
                                  themeProvider.imageSelected.assetPath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 96,
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),

            //subscription section
            SubscriptionSettings(),

            //creating a separate sectiion foor account
            AccountSettings(),
            const SizedBox(
              height: 300,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> generateColorRows(ThemeProvider themeProvider) {
    final colors = Theme.of(context).colorScheme;
    List<Widget> rows = [];
    for (var i = 0; i < ColorSeed.values.length; i += 3) {
      List<Widget> rowChildren = [];
      for (var j = 0; j < 3; j++) {
        if (i + j < ColorSeed.values.length) {
          rowChildren.add(
            InkWell(
              onTap: () {
                themeProvider.handleColorSelect(i + j);
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: themeProvider.colorSelected == ColorSeed.values[i + j] ? ColorSeed.values[i + j].color : ColorSeed.values[i + j].color,
                  border: Border.all(
                    color: themeProvider.colorSelected == ColorSeed.values[i + j] ? colors.surface.withOpacity(0.8) : colors.surface,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        }
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      ));
    }
    return rows;
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
                              userProvider.trackNameChanges(value);
                            }
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('From'),
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
