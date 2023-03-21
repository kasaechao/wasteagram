import 'package:flutter/material.dart';
import 'package:wasteagram/screens/entry_detail.dart';
import 'package:wasteagram/screens/new_entry.dart';
import 'package:wasteagram/screens/select_photo.dart';
import 'screens/entries_list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class App extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  const App({super.key});
  static final routes = {
    EntryDetail.routeName: (context) => const EntryDetail(),
    SelectPhoto.routeName: (context) => const SelectPhoto(),
    NewEntry.routeName: (context) => const NewEntry(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: routes,
      title: 'db test',
      navigatorObservers: [observer],
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
          body: EntriesList(
        analytics: analytics,
        observer: observer,
        key: key,
      )),
    );
  }
}
