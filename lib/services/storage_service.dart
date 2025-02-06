import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<String?> uploadImage(String path) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(File(image.path));
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}
