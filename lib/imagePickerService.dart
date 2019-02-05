import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService extends StatefulWidget {
  @override
  _ImagePickerServiceState createState() => _ImagePickerServiceState();
}

class _ImagePickerServiceState extends State<ImagePickerService> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('相册'),
      ),
      body: Center(
        child: _image == null
            ? Text('没有图片')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}