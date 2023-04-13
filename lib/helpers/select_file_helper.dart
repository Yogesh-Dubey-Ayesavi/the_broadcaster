import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/helpers/parser_file_helper.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:the_broadcaster/utils.dart';

import '../widgets/add_parser_page.dart';
// import '../widgets/parser_properties.dart';

class FileHelper {
  FileHelper() {
    init();
  }

  final ValueNotifier<bool> loader = ValueNotifier(false);

  init() {}

  Future<bool> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result != null && kIsWeb == false) {
        File file = File(result.files.single.path!);

        loader.value = true;
        // print('fileName ${lookupMimeType(await getFilePath(file.name))}');
        file.copy(await getFilePath(file.name)).then((value) {
          // value.rename()
          serviceLocator.get<GlobalFileHelper>().updateFiles(file);
//         serviceLocator
//             .get<GlobalFileHelper>()
//             .loadCSV(file)
//             .then((value) => loader.value = false);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddParserFilePage(
                        fileName: file.name,
                      )));
        });
        // ParserFileHelper newParser = ParserFileHelper(file.name, )

      } else {}
      return true;
    } catch (e) {
      print(e);
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
      // return null;
    }).toList();
    res.removeWhere((element) => element == null);
    return res;
  }
}
