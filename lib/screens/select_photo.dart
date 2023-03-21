import 'package:flutter/material.dart';
import 'package:wasteagram/screens/new_entry.dart';

class SelectPhoto extends StatelessWidget {
  const SelectPhoto({super.key});

  static const routeName = 'selectPhoto';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Photo')),
      floatingActionButton: Semantics(
        label: "Select photo button",
        child: Center(
          child: ElevatedButton(
              onPressed: (() {
                Navigator.of(context).pushNamed(NewEntry.routeName);
              }),
              child: const Text('Select Photo')),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget selectPhotoButton(context) {
    return ElevatedButton(
        onPressed: (() {
          Navigator.of(context).pushNamed(NewEntry.routeName);
        }),
        child: const Text('Select Photo'));
  }
}
