

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class  FeatureData {
  const FeatureData({
    required this.icon,
    required this.title,
    required this.body,
    required this.tag,
  });

  final IconData icon;
  final String title;
  final String body;
  final String tag;
}

const List<FeatureData>  featuresData= [
  FeatureData(
    icon: Icons.remove_red_eye_outlined,
    title: 'Vision Analysis',
    body:
    'Reads color harmony, garment fit, layering quality, and overall style coherence.',
    tag: '01',
  ),
  FeatureData(
    icon: Icons.analytics_outlined,
    title: 'Precision Score',
    body:
    'A 0–100 style rating backed by fashion data and real trend intelligence.',
    tag: '02',
  ),
  FeatureData(
    icon: Icons.tips_and_updates_outlined,
    title: 'Smart Feedback',
    body:
    'Actionable, specific suggestions that improve each element of your look.',
    tag: '03',
  ),
];