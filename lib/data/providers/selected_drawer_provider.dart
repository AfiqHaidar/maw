import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/enums/drawer_identifier.dart';

final selectedDrawerProvider =
    StateProvider<DrawerIdentifier>((ref) => DrawerIdentifier.home);
