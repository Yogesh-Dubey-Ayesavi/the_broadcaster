import 'package:flutter/widgets.dart';

class ParserFileHelper {
  ParserFileHelper(this.fileName) {
    init();
  }

  final String fileName;

  void init() {}

  final TextEditingController phoneNumberController = TextEditingController();

  final Map<String, String> fieldMap = {};
  
}
