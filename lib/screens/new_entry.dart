import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wasteagram/models/photo_entry_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class NewEntry extends StatefulWidget {
  const NewEntry({super.key});

  static const routeName = 'newEntry';

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  LocationData? locationData;
  final picker = ImagePicker();
  final photoEntryFields = PhotoEntryFields();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Scaffold(
          appBar: AppBar(title: const Center(child: Text('New Post'))),
          body: const Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        appBar: AppBar(title: const Center(child: Text('New Post'))),
        body: photoForm(),
        resizeToAvoidBottomInset: false,
        floatingActionButton:
            Semantics(label: "Upload post button", child: uploadPhotoButton()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    }
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    saveLocationData(locationData!);
    setState(() {});
  }

  void saveLocationData(LocationData locationData) {
    photoEntryFields.longitude = locationData.longitude;
    photoEntryFields.latitude = locationData.latitude;
  }

  // STORES IMAGE ON CLOUD STORAGE
  void getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    image = File(pickedFile!.path);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('${DateTime.now()}.jpg');
    UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    photoEntryFields.url = await storageReference.getDownloadURL();
    setState(() {});
  }

  // STORES PHOTO ENTRY ON CLOUD FIRESTORE
  void uploadData() async {
    // photoEntryFields.date = DateFormat.yMMMMEEEEd().format(DateTime.now());
    photoEntryFields.date = DateTime.now().toString();
    var data = {
      'date': photoEntryFields.date,
      'num_wasted': photoEntryFields.numWasted,
      'latitude': photoEntryFields.latitude,
      'longitude': photoEntryFields.longitude,
      'url': photoEntryFields.url
    };
    FirebaseFirestore.instance.collection('wasteagram').add(data);
  }

  Widget photoForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(image!, height: 350),
            spacer(),
            numWastedFormField(),
          ],
        ),
      ),
    );
  }

  Widget spacer() {
    return const SizedBox(
      height: 40,
    );
  }

  Widget uploadPhotoButton() {
    return FractionallySizedBox(
        widthFactor: 1.1,
        heightFactor: 0.1,
        child: ElevatedButton(
          onPressed: (() async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState?.save();
              uploadData();
              if (!mounted) return;
              Navigator.of(context).restorablePushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            }
          }),
          child: const Icon(size: 50, Icons.cloud_upload),
        ));
  }

  Widget locationDataDisplay() {
    return Text(
        'Location: (${photoEntryFields.latitude}, ${photoEntryFields.longitude})');
  }

  Widget numWastedFormField() {
    return Semantics(
      label: "Number of wasted items form field",
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextFormField(
          decoration:
              const InputDecoration(labelText: "Number of Wasted Items"),
          onSaved: (value) {
            photoEntryFields.numWasted = int.parse(value!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a number';
            }
            return null;
          },
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
