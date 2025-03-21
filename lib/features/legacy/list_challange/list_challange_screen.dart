import 'package:flutter/material.dart';
import 'package:mb/features/legacy/list_challange/data/list_challange.dart';
import 'package:mb/features/legacy/list_challange/widgets/list_challange_card.dart';
import 'package:mb/widgets/drawer/main_drawer.dart';

class ListChallengeScreen extends StatefulWidget {
  @override
  _ListChallengeScreenState createState() => _ListChallengeScreenState();
}

class _ListChallengeScreenState extends State<ListChallengeScreen> {
  @override
  void initState() {
    super.initState();
    challenges = List.from(challenges);
  }

  void deleteChallenge(int index) {
    setState(() {
      challenges.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Challenge',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              challenges.length,
              (index) => ListChallangeCard(
                challenge: challenges[index],
                onDelete: () => deleteChallenge(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
