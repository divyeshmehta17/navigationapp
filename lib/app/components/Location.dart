import 'package:flutter/material.dart';

class Location {
  final String name;
  final IconData? icon;
  final String? distance;
  final String? description;

  Location({required this.name, this.icon, this.distance, this.description});
}
