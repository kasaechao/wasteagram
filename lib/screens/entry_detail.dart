import 'package:flutter/material.dart';
import 'package:wasteagram/models/photo_entry.dart';

class EntryDetail extends StatelessWidget {
  const EntryDetail({super.key});

  static const routeName = 'entryDetail';

  @override
  Widget build(BuildContext context) {
    final PhotoEntry post =
        ModalRoute.of(context)?.settings.arguments as PhotoEntry;
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('More Detail'))),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Text('${post.date}'),
          const SizedBox(
            height: 50,
          ),
          Image(image: NetworkImage('${post.url}')),
          const SizedBox(
            height: 25,
          ),
          Text('${post.numWasted} items'),
          const SizedBox(
            height: 25,
          ),
          Text('Location: (${post.latitude}, ${post.longitude})')
        ],
      )),
    );
  }
}
