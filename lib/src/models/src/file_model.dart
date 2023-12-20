import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/pointycastle.dart';

class FileModel {
  final String? bucket;
  final String? generation;
  final String? metageneration;
  final String? metadataGeneration;
  final String? fullPath;
  final String? name;
  final int? size;
  final DateTime? timeCreated;
  final DateTime? updated;
  final String? md5Hash;
  final String? cacheControl;
  final String? contentDisposition;
  final String? contentEncoding;
  final String? contentLanguage;
  final String? contentType;
  final Map<String, String>? customMetadata;
  String? sha512Hash;
  String? sha256Hash;

  FileModel({
    this.bucket,
    this.generation,
    this.metageneration,
    this.metadataGeneration,
    this.fullPath,
    this.name,
    this.size,
    this.timeCreated,
    this.updated,
    this.md5Hash,
    this.cacheControl,
    this.contentDisposition,
    this.contentEncoding,
    this.contentLanguage,
    this.contentType,
    this.customMetadata,
    this.sha256Hash,
    this.sha512Hash,
  });

  String get sha512 => sha512Hash ?? '';
  String get sha256 => sha256Hash ?? '';

  // Function to calculate SHA-512 and SHA-256 hashes
  void generateHashes(String fileContent) {
    var bytes = Uint8List.fromList(utf8.encode(fileContent));
    sha512Hash = _generateDigest('SHA-512', bytes);
    sha256Hash = _generateDigest('SHA-256', bytes);
  }

  String _generateDigest(String algorithm, Uint8List input) {
    var digest = Digest(algorithm);
    return bin2hex(digest.process(input));
  }

  String bin2hex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  // Function to convert FileModel object to Map
  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      bucket: map['bucket'],
      generation: map['generation'],
      metageneration: map['metageneration'],
      metadataGeneration: map['metadataGeneration'],
      fullPath: map['fullPath'],
      name: map['name'],
      size: map['size'],
      timeCreated: DateTime.parse(map['timeCreated']),
      updated: DateTime.parse(map['updated']),
      md5Hash: map['md5Hash'],
      cacheControl: map['cacheControl'],
      contentDisposition: map['contentDisposition'],
      contentEncoding: map['contentEncoding'],
      contentLanguage: map['contentLanguage'],
      contentType: map['contentType'],
      customMetadata: Map<String, String>.from(map['customMetadata']),
      sha256Hash: map['sha256Hash'],
      sha512Hash: map['sha512Hash'],
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'bucket': bucket,
      'generation': generation,
      'metageneration': metageneration,
      'metadataGeneration': metadataGeneration,
      'fullPath': fullPath,
      'name': name,
      'size': size,
      'timeCreated': timeCreated!.toIso8601String(),
      'updated': updated!.toIso8601String(),
      'md5Hash': md5Hash,
      'cacheControl': cacheControl,
      'contentDisposition': contentDisposition,
      'contentEncoding': contentEncoding,
      'contentLanguage': contentLanguage,
      'contentType': contentType,
      'customMetadata': customMetadata,
      'sha256Hash': sha256Hash,
      'sha512Hash': sha512Hash,
    };
  }

  // copyWith
  FileModel copyWith({
    String? bucket,
    String? generation,
    String? metageneration,
    String? metadataGeneration,
    String? fullPath,
    String? name,
    int? size,
    DateTime? timeCreated,
    DateTime? updated,
    String? md5Hash,
    String? cacheControl,
    String? contentDisposition,
    String? contentEncoding,
    String? contentLanguage,
    String? contentType,
    Map<String, String>? customMetadata,
    String? sha256Hash,
    String? sha512Hash,
  }) {
    return FileModel(
      bucket: bucket ?? this.bucket,
      generation: generation ?? this.generation,
      metageneration: metageneration ?? this.metageneration,
      metadataGeneration: metadataGeneration ?? this.metadataGeneration,
      fullPath: fullPath ?? this.fullPath,
      name: name ?? this.name,
      size: size ?? this.size,
      timeCreated: timeCreated ?? this.timeCreated,
      updated: updated ?? this.updated,
      md5Hash: md5Hash ?? this.md5Hash,
      cacheControl: cacheControl ?? this.cacheControl,
      contentDisposition: contentDisposition ?? this.contentDisposition,
      contentEncoding: contentEncoding ?? this.contentEncoding,
      contentLanguage: contentLanguage ?? this.contentLanguage,
      contentType: contentType ?? this.contentType,
      customMetadata: customMetadata ?? this.customMetadata,
      sha256Hash: sha256Hash ?? this.sha256Hash,
      sha512Hash: sha512Hash ?? this.sha512Hash,
    );
  }
}
