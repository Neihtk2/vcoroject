import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicket = ImagePicker();
  XFile? _file = await _imagePicket.pickImage(source: source);
  if (_file != null) {
    return _file.readAsBytes();
  }
  print('No image selected');
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
