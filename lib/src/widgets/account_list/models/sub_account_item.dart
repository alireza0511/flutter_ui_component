import 'package:flutter/material.dart';

class SubAccountItem {
  const SubAccountItem({
    required this.id,
    required this.displayName,
    required this.balance,
    this.icon,
  });

  final String id;
  final String displayName;
  final double balance;
  final IconData? icon;
}
