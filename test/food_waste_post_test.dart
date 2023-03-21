import 'package:test/test.dart';
import 'package:wasteagram/models/photo_entry.dart';

void main() {
  test('PhotoEntry created is an instance of the PhotoEntry class.', () {
    var date = '2021 March 21';
    var numWasted = 10;
    var longitude = 101.11;
    var latitude = -121.12;
    var url = 'https://www.google.com';

    var photoEntry = PhotoEntry(
        date: date,
        numWasted: numWasted,
        longitude: longitude,
        latitude: latitude,
        url: url);

    expect(photoEntry, isA<PhotoEntry>());
  });
  test('Post created will have appropriate values.', () {
    var date = '2021 March 21';
    var numWasted = 10;
    var longitude = 101.11;
    var latitude = -121.12;
    var url = 'https://www.google.com';

    var photoEntry = PhotoEntry(
        date: date,
        numWasted: numWasted,
        longitude: longitude,
        latitude: latitude,
        url: url);

    expect(photoEntry.date, date);
    expect(photoEntry.numWasted, numWasted);
    expect(photoEntry.longitude, longitude);
    expect(photoEntry.latitude, latitude);
    expect(photoEntry.url, url);
  });

  test('Post created will not have null values.', () {
    var date = '2021 March 21';
    var numWasted = 10;
    var longitude = 101.11;
    var latitude = -121.12;
    var url = 'https://www.google.com';

    var photoEntry = PhotoEntry(
        date: date,
        numWasted: numWasted,
        longitude: longitude,
        latitude: latitude,
        url: url);

    expect(photoEntry.date, isNotNull);
    expect(photoEntry.numWasted, isNotNull);
    expect(photoEntry.longitude, isNotNull);
    expect(photoEntry.latitude, isNotNull);
    expect(photoEntry.url, isNotNull);
  });
}
