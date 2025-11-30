import '../consr.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  static final CloudinaryPublic _cloudinary = CloudinaryPublic(
    kCloudinaryCloudName,
    kCloudinaryUploadPreset,
    cache: false,
  );

  static Future<String?> uploadImage(XFile imageFile) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  static Future<String?> uploadImageFromPath(String imagePath) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
}
