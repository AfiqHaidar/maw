import 'package:flutter/material.dart';
import 'package:mb/features/scaffold/widgets/main_drawer.dart';
import 'package:mb/features/vertical/data/vertical_images.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class VerticalScreen extends StatefulWidget {
  const VerticalScreen({super.key});

  @override
  _VerticalScreenState createState() => _VerticalScreenState();
}

class _VerticalScreenState extends State<VerticalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
      drawer: MainDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: VerticalCardPager(
                images: VerticalImagesProperty().images,
                titles: VerticalImagesProperty().titles,
                onPageChanged: (page) {},
                onSelectedItem: (index) {
                  print(index);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
