import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/helpers/parser_file_helper.dart';
import 'package:the_broadcaster/helpers/parser_helper.dart';
import 'package:the_broadcaster/revision/revision_helpers.dart/broadcast_helper.dart';
import 'package:the_broadcaster/serviceLocator.dart';

import '../default_colors.dart';
import '../widgets/text_widgets.dart';

// \$(\w)+  regexp

class AddParserHelper {
  AddParserHelper({this.isRevision = false});

  final bool isRevision;

  init() {}

  final ValueNotifier<Map<String, dynamic>> fieldMap = ValueNotifier({});

  final ValueNotifier<String?> fileName = ValueNotifier(null);

  final TextEditingController newFieldController = TextEditingController();

  final TextEditingController newFieldValueController = TextEditingController();

  final TextEditingController phoneNumberController =
      TextEditingController(text: "phone");

  final ValueNotifier<bool> loader = ValueNotifier(false);

  void updateMap() {
    final newMap = Map.of(fieldMap.value);
    fieldMap.value = newMap;
  }

  newFieldAdded() {
    if (newFieldController.text.isNotEmpty &&
        newFieldValueController.text.isNotEmpty) {
      fieldMap.value.putIfAbsent(
          newFieldController.text, () => newFieldValueController.text);
      updateMap();
      newFieldController.clear();
      newFieldValueController.clear();
    }
  }

  removeKey(String key) {
    fieldMap.value.remove(key);
    updateMap();
  }

  void onAddParser(BuildContext context, {ParserFileHelper? helper}) async {
    loader.value = true;
    if (fileName.value != null) {
      if (newFieldController.text.isNotEmpty &&
          newFieldValueController.text.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: ApplicationColorsDark.secondaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              title: const Subtitle(
                'Do you want to add the key values you have written ?',
              ),
              actions: [
                TextButton(
                  child: const Subtitle("Yes"),
                  onPressed: () {
                    newFieldAdded();
                    onSuccessPressUpdateParser(context, helper);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Subtitle("No"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      } else {
        onSuccessPressUpdateParser(context, helper);
      }

      /// TODO: Add parser instance to db too
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ApplicationColorsDark.secondaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            title: const Subtitle(
              'FileName is not selected',
            ),
            actions: [
              TextButton(
                child: const Subtitle("Yes"),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Subtitle("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }

  onSuccessPressUpdateParser(
      BuildContext context, ParserFileHelper? helper) async {
    fieldMap.value.putIfAbsent(
        'phoneNumber', () => phoneNumberController.text.toString());
    final parser = ParserFileHelper(fileName.value!, fieldMap.value);
    !isRevision
        ? serviceLocator.get<ParserHelper>().parsers.value.add(parser)
        : null;
    await serviceLocator.get<GlobalFileHelper>().onAddedParser(parser);
    !isRevision
        ? serviceLocator.get<LocalDatabase>().insertParserFileHelper(parser)
        : helper != null
            ? serviceLocator.get<LocalDatabase>().updateParser(helper)
            : null;

    loader.value = false;
    Navigator.pop(context);
  }
}
