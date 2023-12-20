import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageBucketRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Method to list all files in a specific path
  Future<List<firebase_storage.Reference>> listAllFiles(String path) async {
    try {
      var storageRef = storage.ref().child(path);
      var listResult = await storageRef.listAll();

      var files = <firebase_storage.Reference>[];
      for (var item in listResult.items) {
        files.add(item);
      }

      return files;
    } catch (e) {
      // Handle errors
      rethrow;
    }
  }

  // Method to list files with pagination
  Stream<List<firebase_storage.Reference>> listFilesPaginated(
      String path) async* {
    String? pageToken;
    var storageRef = storage.ref().child(path);

    do {
      var listResult = await storageRef.list(firebase_storage.ListOptions(
        maxResults: 100,
        pageToken: pageToken,
      ));

      yield listResult.items;

      pageToken = listResult.nextPageToken;
    } while (pageToken != null);
  }
}
