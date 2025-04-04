import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/core/theme/colors.dart';

class ProfilePictureSelectorDialog extends StatelessWidget {
  const ProfilePictureSelectorDialog({super.key});

  static const List<String> assets = [
    'assets/animations/blue_hang.json',
    'assets/animations/blue_lappy.json',
    'assets/animations/blue_moc.json',
    'assets/animations/blue_nyan.json',
    'assets/animations/blue_pix.json',
    'assets/animations/blue_pump.json',
    'assets/animations/blue_sat.json',
    'assets/animations/blue_stare.json'
  ];

  @override
  Widget build(BuildContext context) {
    final int itemCount = assets.length;
    final int rowCount = (itemCount / 2).ceil();
    final double dialogHeight = (rowCount * 100) + 90;

    return Container(
      height: dialogHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  return ProfilePictureOption(
                    asset: assets[index],
                    onTap: () => Navigator.of(context).pop(assets[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePictureOption extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;

  const ProfilePictureOption({
    super.key,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(40),
            splashColor: AppColors.primary.withOpacity(0.1),
            highlightColor: AppColors.primary.withOpacity(0.2),
            child: CircleAvatar(
              radius: 30,
              child: ClipOval(
                child: Lottie.asset(
                  asset,
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
