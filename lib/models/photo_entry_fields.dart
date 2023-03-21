class PhotoEntryFields {
  String? date;
  int? numWasted;
  double? longitude;
  double? latitude;
  String? url;

  @override
  String toString() {
    return 'date: $date, numWasted: $numWasted, longitude: $longitude, latitude: $latitude, url: $url';
  }
}
