import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_uploader/constant/Constants.dart';
import 'package:image_uploader/resources/components/custom_button.dart';
import 'package:image_uploader/utils/routes/routes_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _images;
  String _imageName = 'No image selected';
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images = File(pickedFile.path);
        _imageName = pickedFile.name ?? 'No image selected';
      });
    }
  }

  Future<void> _uploadImage(File image) async {
    setState(() {
      _isUploading = true;
    });
    final uri = Constants.getUri('api/v1/s3');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Uploaded! File URL: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uploaded!',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),backgroundColor: Colors.green),
        );
      } else {
        print('Failed to upload: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Image Uploader", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          height: _images != null
              ? 400.0
              : 300.0, // Adjusted height to accommodate image preview
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage("assets/upload.webp"),
                  width: 120,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.orangeAccent,
                        ),
                        width: 70,
                        height: 35,
                        child: const Center(
                          child: Text(
                            "browse",
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(_imageName, style: const TextStyle(color: Colors.green)),
                  if(_images!=null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _images = null;
                        _imageName = 'No image selected'; // Reset image name as well
                      });

                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                  text: "upload",
                  onPressed: () {
                    if (_images != null) {
                      _uploadImage(_images!);
                    }
                  },
                ),
              ),
              if (_images != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    _images!,
                    height: 100,
                    width: 100,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.image);
        },
        label: const Text(
          'View Uploads',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.arrow_right_alt_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
