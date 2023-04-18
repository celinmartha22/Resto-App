import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/provider/preferences_provider.dart';
import 'package:resto_app/data/provider/scheduling_provider.dart';
import 'package:resto_app/widgets/custom_dialog.dart';

import '../common/styles.dart';

class SettingPage extends StatefulWidget {
  static const routeName = '/setting';
  bool statusAlarm;
  SettingPage({super.key, required this.statusAlarm});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String imageFile = '';
  String notif = '';

  @override
  void initState() {
    imageFile = widget.statusAlarm 
        ? 'images/notifications-on.png'
        : 'images/notifications-off.png';
    notif =  widget.statusAlarm 
        ? 'You are receiving notifications for this app.\nTo turn off notifications use the toggle below'
        : 'You turn off notifications for this app. To enable notifications use the toggle below';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return Scaffold(body: Center(child:
            Consumer<SchedulingProvider>(builder: (context, scheduled, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SafeArea(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: secondaryColor,
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Setting",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: primaryColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    imageFile,
                    width: MediaQuery.of(context).size.width,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.contain,
                    key: ValueKey(imageFile),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(notif,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  color: onSecondaryColor,
                                  fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          key: ValueKey(notif)),
                    ),
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: _buildOnOff(context,
                              provider.isDailyRestoActive, scheduled, provider)
                          ),
                    )
                  ],
                ),
              ),
            ],
          );
        })));
      },
    );
  }

  Widget _buildOnOff(
      BuildContext context,
      bool statusOn,
      SchedulingProvider schedulingProvider,
      PreferencesProvider preferencesProvider) {
    return LiteRollingSwitch(
      value: statusOn,
      width: 130,
      textOn: 'Active',
      textOff: 'Inactive',
      colorOn: secondaryColor.withOpacity(.8),
      colorOff: onSecondaryColor,
      iconOn: Icons.notifications_active_sharp,
      iconOff: Icons.notifications_off_sharp,
      animationDuration: const Duration(milliseconds: 300),
      onChanged: (bool value) async {
        setState(() {
          imageFile = value
              ? 'images/notifications-on.png'
              : 'images/notifications-off.png';
          notif = value
              ? 'You are receiving notifications for this app.\nTo turn off notifications use the toggle below'
              : 'You turn off notifications for this app.\nTo enable notifications use the toggle below';
        });
        if (Platform.isIOS) {
          customDialog(context);
        } else {
          schedulingProvider.scheduledNews(value);
          preferencesProvider.enableDailyResto(value);
        }
      },
      onDoubleTap: () {},
      onSwipe: () {},
      onTap: () {},
    );
  }
}
