import 'package:flutter/cupertino.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/helpers/parser_file_helper.dart';
import 'package:the_broadcaster/serviceLocator.dart';

class ParserHelper {
  ParserHelper() {
    init();
  }

  void init() async {
    // parsers.value = await serviceLocator.get<LocalDatabase>().fetchParsers();
  }

  final ValueNotifier<List<ParserFileHelper>> parsers = ValueNotifier([]);
}
