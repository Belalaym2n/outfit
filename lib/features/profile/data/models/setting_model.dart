
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../presentation/widgets/settings/setting_widget.dart';

class  SettingItem {
  const SettingItem({
    required this.icon,
    required this.title,
    this.isLogout  = false,
    this.trailing,
  });
  final IconData icon;
  final String   title;
  final bool     isLogout;
  final Widget?  trailing;
}

final  settingItems = <SettingItem>[

  const SettingItem(icon: Icons.shield_outlined,          title: 'Privacy Settings'),
  const SettingItem(
    icon:      Icons.logout_rounded,
    title:     'Sign Out',
    isLogout:  true,
  ),
];