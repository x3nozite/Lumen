import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';



class InputImageScreen extends StatefulWidget {
  const InputImageScreen({super.key});

  @override
  _ImagePickerState createState() => _ImagePickerState();

}

class _ImagePickerState extends State<InputImageScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitImage() {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first')),
      );
    } else {
      // Do something with the image (e.g., upload, print path)
      print('Selected image path: ${_selectedImage!.path}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image submitted!')),
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(title: Text('Scan Image'), centerTitle: true),
    
      body: _imageField(context)
    );
  }

  Padding _imageField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _titleText(context),
          SizedBox(height: 24),
          _selectedImage != null ? _imageUploaded(context) : _noImageUploaded(context),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text('Pick Image'),
          ),
          SizedBox(height: 20),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _submitImage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1982C4),
                foregroundColor: Colors.white,
              ),
              child: Text('Scan Now'),
            ),
          ),
        ],
      ),
    );
  }

  Container _noImageUploaded(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: Center(child: Text('No image selected')),            
    );
  }

  Image _imageUploaded(BuildContext context) {
    return Image.file(
      _selectedImage!,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  RichText _titleText(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(
          fontFamily: 'Poppins',
          color: Colors.black,
          decoration: TextDecoration.none,
          height: 2,
        ),
        children: [
          TextSpan(
            text: 'Upload image to scan\n',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                'Upload image to check for fraud, hoaxes, or misinformation in seconds.',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
