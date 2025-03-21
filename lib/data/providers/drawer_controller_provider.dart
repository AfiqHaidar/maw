import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerControllerNotifier extends StateNotifier<AdvancedDrawerController> {
  DrawerControllerNotifier() : super(AdvancedDrawerController());
}

final drawerControllerProvider =
    StateNotifierProvider<DrawerControllerNotifier, AdvancedDrawerController>(
  (ref) => DrawerControllerNotifier(),
);
