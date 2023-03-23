import 'dart:convert';

import 'package:flutter/widgets.dart';

class ParserFileHelper {
  ParserFileHelper(this.fileName, this.fieldMap) {
    init();
  }

  final String fileName;

  final Map<String, dynamic> fieldMap;

  void init() {}

  final TextEditingController phoneNumberController = TextEditingController();

  Map<String, String> toJson() {
   return {
    'fileName':fileName,
    'fieldMap':jsonEncode(fieldMap)
   };

  }

  // final Map<String, String> fieldMap = {};
}
