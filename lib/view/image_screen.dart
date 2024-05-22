import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_uploader/constant/Constants.dart'; // Assuming this is your constants file

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    // Fetch image URLs when the screen is initialized
    _fetchImageUrls();
  }

  Future<void> _fetchImageUrls() async {
    try {
      final uri = Constants.getUri('api/v1/s3');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<String> urls = [];

        for (var item in data) {
          // Assuming data is a list of strings (verified earlier)
          final String imageUrl = item as String;
          urls.add(imageUrl);
        }

        setState(() {
          _imageUrls = urls;
        });
      } else {
        throw Exception('Failed to load image URLs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching image URLs: $e');
      // Handle error (e.g., show error message to the user)
    }
  }

  Future<void> _refreshImageUrls() async {
    await _fetchImageUrls(); // Refresh by re-fetching image URLs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: const Text('Image Gallery',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshImageUrls,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1.0, // Aspect ratio of each item
            ),
            itemCount: _imageUrls.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: _imageUrls[index],
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }
}
