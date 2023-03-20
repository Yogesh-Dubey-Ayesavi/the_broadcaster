import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_broadcaster/models/contact.dart';

import '../utils.dart';

class GlobalFileHelper {
  GlobalFileHelper() {
    init();
  }

  void init() async {
    await getFiles();
  }

  ValueNotifier<List<File>> _files = ValueNotifier([]);

  Map<String, List<Contact>> _fileMap = {};

  Map<String, List<Contact>> get fileMap => getDeepCopy();

  updateFiles(File file) {
    final List<File> newList = List.from(_files.value);
    newList.add(file);
    _files.value = newList;
  }

  Future<List<List<dynamic>>> loadCSV(File file) async {
    final _rawData = await file.readAsString();
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);
    List<Contact> list = await loadContacts(_listData, file.name);
    _fileMap.putIfAbsent(file.name, () => list);
    // print('Done');
    return _listData;
  }

  Future<List<Contact>> loadContacts(
      List<List<dynamic>> param, String fileName) async {
    int phoneNumber = param[0].indexWhere((element) => element == 'phone');
    int name = param[0].indexWhere((element) =>
        ['first_name', 'name', 'Name', 'user_name'].contains(element));
    param.removeAt(0);
    return param.map((e) {
      return Contact('${e[phoneNumber]}', name: e[name], fileName: fileName);
    }).toList();
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
        updateFiles(file);
        loadCSV(file);
        return file;
      }
      return null;
    }).toList();
    res.removeWhere((element) => element == null);
    return res;
  }

  Future<FileSystemEntity> removeFile(File file) async {
    return await file.delete();
  }

  Map<String, List<Contact>> getDeepCopy() {
    final Map<String, List<Contact>> resMap = {};
    _fileMap.forEach((key, value) {
      resMap.putIfAbsent(
          key,
          () => value
              .map((element) => Contact(element.phoneNumber,
                  fileName: element.fileName, name: element.name))
              .toList());
    });
    return resMap;
  }
}
