import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/providers/user_provider.dart';

class DrawerControllerNotifier extends StateNotifier<AdvancedDrawerController> {
  DrawerControllerNotifier() : super(AdvancedDrawerController());
}

final drawerControllerProvider =
    StateNotifierProvider<DrawerControllerNotifier, AdvancedDrawerController>(
  (ref) => DrawerControllerNotifier(),
);

final usernamesStreamProvider = StreamProvider<List<String>>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return repo.watchAllUsernames();
});
