// lib/data/providers/selected_drawer_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/enums/drawer_identifier.dart';

final selectedDrawerProvider =
    StateProvider<DrawerIdentifier>((ref) => DrawerIdentifier.home);
