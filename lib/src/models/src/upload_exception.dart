class UploadException implements Exception {
  final String message;
  final dynamic innerException;

  UploadException(this.message, [this.innerException]);

  @override
  String toString() {
    return 'UploadException: $message\nInner exception: $innerException';
  }
}
