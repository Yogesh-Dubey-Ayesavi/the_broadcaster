import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';

String? getFileExtension(String fileName) {
  try {
    String ex = "." + fileName.split('.').last;
    return ex;
  } catch (e) {
    return null;
  }
}

Future<String> getFilePath(String fileName) async {
  Directory appDocumentsDirectory =
      await getApplicationDocumentsDirectory(); // 1
  String appDocumentsPath = appDocumentsDirectory.path; // 2
  String filePath = '$appDocumentsPath/$fileName'; // 3

  return filePath;
}

extension FileEx on File {
  String get name => path.split(Platform.pathSeparator).last;
}

StreamController<String> rebuiltNeededStream = StreamController.broadcast();

String removeSpecialCharacters(String id) {
  return id.replaceAll(RegExp('[^A-Za-z0-9]'), '');
}
