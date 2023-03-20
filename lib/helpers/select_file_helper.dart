import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:the_broadcaster/utils.dart';

class FileHelper {
  FileHelper() {
    init();
  }

  final ValueNotifier<bool> loader = ValueNotifier(false);

  init() {}

  Future<bool> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && kIsWeb == false) {
        File file = File(result.files.single.path!);
        await file.copy(await getFilePath(file.name));
        loader.value = true;
        serviceLocator.get<GlobalFileHelper>().updateFiles(file);
        serviceLocator
            .get<GlobalFileHelper>()
            .loadCSV(file)
            .then((value) => loader.value = false);
      } else {}
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<File?>> getFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/';
    final myDir = Directory(pdfDirectory);
    List<FileSystemEntity> result =
        myDir.listSync(recursive: true, followLinks: false);
    List<File?> res = result.map((e) {
      if (getFileExtension(e.path) == '.csv') {
        File file = File(e.path);
        return file;
      }
      return null;
    }).toList();
    res.removeWhere((element) => element == null);
    return res;
  }
}
