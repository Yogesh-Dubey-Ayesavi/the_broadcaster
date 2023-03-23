import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/helpers/parser_file_helper.dart';
import 'package:the_broadcaster/helpers/parser_helper.dart';
import 'package:the_broadcaster/models/contact.dart';
import 'package:the_broadcaster/serviceLocator.dart';

import '../utils.dart';

class GlobalFileHelper {
  GlobalFileHelper() {
    print('initiazlizing');
    init();
  }

  void init() async {
    await getFiles();
  }

  ValueNotifier<List<File>> _files = ValueNotifier([]);

  Map<String, List<Contact>> _fileMap = {};

  Map<String, List<Contact>> get fileMap => getDeepCopy();

  List<String> get files => _files.value.map((e) => e.name).toList();

  final ValueNotifier<bool> loader = ValueNotifier(false);

  updateFiles(File file) {
    final List<File> newList = List.from(_files.value);
    newList.add(file);
    _files.value = newList;
  }

  Future<List<List<dynamic>>> loadCSV(File file) async {
    final _rawData = await file.readAsString();
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData, shouldParseNumbers: true);
    // print(_listData[0].length);
    // ?  var i = 0;

    List<Contact> list = await loadContacts(_listData, file.name);
    _fileMap.putIfAbsent(file.name, () => list);
    // print('Done');
    return _listData;
  }

  Future<List<Contact>> loadContacts(
      List<List<dynamic>> param, String fileName) async {
    final res = getParser(fileName);

    // print('$fileName , $param');

    if (res != null) {
      param.removeWhere((element) => element.length != param[0].length);

      int phoneNumber = param[0].indexWhere((element) =>
          ['phone', res.fieldMap['phoneNumber']].contains(element));

      int name = param[0].indexWhere((element) => [
            'first_name',
            'name',
            'Name',
            'user_name',
            res.fieldMap['name']
          ].contains(element));

      // print('$name');

      Map<String, int> resMap = {};

      res.fieldMap.forEach((key, value) {
        int index = param[0].indexWhere((element) => value == element);
        resMap.putIfAbsent(key, () => index);
      });

      param.removeAt(0);
      // print(param.length);
      return param.map((e) {
        final Map<String, String> fieldMap = {};
        resMap.forEach((key, value) {
          // print('$e $value');
          fieldMap.putIfAbsent(key, () => e[value].toString());
        });
        // print('$fileName   ${e[phoneNumber]}');
//
        // print('');

        return Contact('${e[phoneNumber]}',
            name: e[name], fileName: fileName, fieldMap: fieldMap);
      }).toList();
    } else {
      return [];
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
        updateFiles(file);
        loadCSV(file);
        return file;
      }
      return null;
    }).toList();
    res.removeWhere((element) => element == null);
    return res;
  }

  ParserFileHelper? getParser(String fileName) {
    try {
      return serviceLocator
          .get<ParserHelper>()
          .parsers
          .value
          .firstWhere((element) => element.fileName == fileName);
    } catch (e) {
      return null;
    }
  }

  Future<FileSystemEntity> removeFile(File file) async {
    _files.value.removeWhere((element) => element.name == file.name);
    _fileMap.remove(file.name);
    serviceLocator.get<LocalDatabase>().removeFileParser(file.name);
    // updateFiles(file);

    return await file.delete();
  }

  Future<List<List<dynamic>>> onAddedParser(ParserFileHelper parser) async {
    _fileMap.remove(parser.fileName);
    final res = await loadCSV(_files.value[
        _files.value.indexWhere((element) => element.name == parser.fileName)]);
    serviceLocator.get<GlobalFileHelper>().loader.value = false;
    return res;
  }

  Map<String, List<Contact>> getDeepCopy() {
    final Map<String, List<Contact>> resMap = {};
    _fileMap.forEach((key, value) {
      resMap.putIfAbsent(
          key,
          () => value
              .map((element) => Contact(element.phoneNumber,
                  fileName: element.fileName,
                  name: element.name,
                  fieldMap: element.fieldMap))
              .toList());
    });
    return resMap;
  }
}
