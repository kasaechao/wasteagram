import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/screens/entry_detail.dart';
import 'package:wasteagram/screens/select_photo.dart';
import 'package:wasteagram/models/photo_entry.dart';
import 'package:wasteagram/models/photo_entries.dart';

class EntriesList extends StatefulWidget {
  final FirebaseAnalytics analytics;

  final FirebaseAnalyticsObserver observer;
  const EntriesList(
      {super.key, required this.analytics, required this.observer});

  static const routeName = '/';

  @override
  State<EntriesList> createState() => EntriesListState();
}

class EntriesListState extends State<EntriesList> {
  PhotoEntries? photoEntries;

  Future<void> _sendEntryDetailPressed(PhotoEntry post) async {
    await widget.analytics
        .logEvent(name: 'press_event_for_extra_credit', parameters: {
      'date': post.date,
      'num_wasted': post.numWasted,
      'longitude': post.longitude,
      'latitude': post.latitude
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: wasteagramAppBar('Wasteagram'),
      body: entriesListDisplay(),
      floatingActionButton:
          Semantics(label: "Add new entry button", child: addEntryButton()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget addEntryButton() {
    return FloatingActionButton(
      child: const Icon(Icons.camera_alt),
      onPressed: () {
        Navigator.of(context).pushNamed(SelectPhoto.routeName);
      },
    );
  }

  AppBar wasteagramAppBar(String title) {
    return AppBar(
        title: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('wasteagram').snapshots(),
            builder: ((context, snapshot) {
              var totalItemsWasted = 0;
              if (snapshot.hasData) {
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  totalItemsWasted +=
                      snapshot.data!.docs[i]['num_wasted'] as int;
                }
                return Center(child: Text('$title - $totalItemsWasted'));
              } else {
                return Center(child: Text(title));
              }
            })));
  }

  Widget entriesListDisplay() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('wasteagram').snapshots(),
        builder: ((context, snapshot) {
          return entriesListBuilder(context, snapshot);
        }));
  }

  void loadEntries(snapshot) {
    List entries = snapshot.data!.docs.map((entry) {
      return PhotoEntry(
          date: entry["date"],
          numWasted: entry["num_wasted"],
          longitude: entry["longitude"],
          latitude: entry["latitude"],
          url: entry["url"]);
    }).toList();
    entries.sort(
        (b, a) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    photoEntries = PhotoEntries(entries: entries);
    formatEntryDates();
  }

  void formatEntryDates() {
    for (int i = 0; i < photoEntries!.entries!.length; i++) {
      photoEntries!.entries![i].date = DateFormat.yMMMMEEEEd()
          .format(DateTime.parse(photoEntries!.entries![i].date));
    }
  }

  Widget entriesListBuilder(context, snapshot) {
    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
      loadEntries(snapshot);
      return entriesFromDB(photoEntries!.entries);
    } else {
      return circularIndicator();
    }
  }

  Widget circularIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget entriesFromDB(entries) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: ((context, index) {
                var photoEntry = entries[index];
                return entriesFromDBBuilder(context, photoEntry);
              })),
        ),
      ],
    );
  }

  Widget entriesFromDBBuilder(context, PhotoEntry post) {
    return Semantics(
      label: "More Detail Tile",
      child: Card(
        child: ListTile(
          leading: Image(image: NetworkImage('${post.url}')),
          title: Text(post.date!, style: const TextStyle(fontSize: 20)),
          subtitle: Text(' Items Wasted: ${post.numWasted.toString()}',
              style: const TextStyle(fontSize: 20)),
          onTap: () {
            _sendEntryDetailPressed(post);
            Navigator.of(context)
                .pushNamed(EntryDetail.routeName, arguments: post);
          },
        ),
      ),
    );
  }

  PhotoEntry buildEntry(post) {
    return PhotoEntry(
        date: post['date'],
        numWasted: post['num_wasted'],
        longitude: post['longitude'],
        latitude: post['latitude'],
        url: post['url']);
  }
}
