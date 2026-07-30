import 'dart:convert';

import 'package:file_picker/file_picker.dart';

/// Desktop / mobile image pick via file_picker.
Future<String?> pickImageAsDataUrl() async {
  final result = await FilePicker.pickFiles(
    type: FileType.image,
    allowMultiple: false,
    withData: true,
  );
  if (result == null || result.files.isEmpty) return null;

  final file = result.files.first;
  final bytes = file.bytes;
  if (bytes == null || bytes.isEmpty) return null;

  final ext = (file.extension ?? 'jpeg').toLowerCase();
  final mime = switch (ext) {
    'png' => 'image/png',
    'gif' => 'image/gif',
    'webp' => 'image/webp',
    'jpg' || 'jpeg' => 'image/jpeg',
    _ => 'image/jpeg',
  };
  return 'data:$mime;base64,${base64Encode(bytes)}';
}
