import 'package:flutter/cupertino.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/models/broadcast.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:the_broadcaster/utils.dart';
import '../default_colors.dart';
import '../models/contact.dart';
import 'package:uuid/uuid.dart';

import '../widgets/text_widgets.dart';

class BroadCastHelper {
  BroadCastHelper() {
    selectedContactsFileMap.addListener(() {});
  }

  ValueNotifier<Map<String, List<Contact>>> selectedContactsFileMap =
      ValueNotifier({});

  TextEditingController textEditingController = TextEditingController();

  Map<String, List<Contact>> fileMap =
      serviceLocator.get<GlobalFileHelper>().fileMap;

  addContact(Contact contact, String fileName) {
    selectedContactsFileMap.value[fileName]?.add(contact);
    updateMap();
  }

  removeContact(Contact contact, String fileName) {
    selectedContactsFileMap.value[fileName]?.remove(contact);
    updateMap();
  }

  addFile(String fileName) {
    selectedContactsFileMap.value.putIfAbsent(fileName, () => []);
  }

  updateMap() {
    loadData();
    Map<String, List<Contact>> newMap = Map.from(selectedContactsFileMap.value);
    selectedContactsFileMap.value = newMap;
  }

  loadData() {
    Map<String, List<Contact>> resultMap = {};
    for (var entry in fileMap.entries) {
      List<Contact> selectedContacts = entry.value
          .where((contact) => contact.isSelected.value == true)
          .toList();
      if (selectedContacts.isNotEmpty) {
        resultMap.putIfAbsent(entry.key, () => selectedContacts);
      }
      selectedContactsFileMap.value = resultMap;
    }
  }

  dipose() {
    selectedContactsFileMap.value = {};
    textEditingController.clear();
  }

  Future<bool> sendMessage(BuildContext context) async {
    if (textEditingController.text.isNotEmpty && _getContacts().isNotEmpty) {
      List<String> recipients = [];
      // SmsSender sender = new SmsSender();
      for (var entry in selectedContactsFileMap.value.entries) {
        recipients
            .addAll(entry.value.map((e) => e.phoneNumber.toString()).toList());
      }
      final permission = Permission.sms.request();
      if (await permission.isGranted) {
        final res = await sendSMS(
          message: textEditingController.text,
          recipients: recipients,
          sendDirect: true,
        );
        if (res != null) {
          return createBroadCast(BroadCast(
            textEditingController.text,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: "u${removeSpecialCharacters(const Uuid().v4())}",
            recipients: _getContacts(),
            mappedContacts: selectedContactsFileMap.value,
          ));
        }
      }
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
              'Message is empty, either contact list. Please add a message and atleast one contact to broadcast',
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
      return false;
    }

    return false;
  }

  List<Contact> _getContacts() {
    List<Contact> contactList = [];
    for (var entry in selectedContactsFileMap.value.entries) {
      contactList.addAll(entry.value);
    }
    return contactList;
  }

  bool createBroadCast(BroadCast broadCast) {
    try {
      serviceLocator.get<LocalDatabase>().addBroadCast(broadCast);
      return true;
    } catch (e) {
      return false;
    }
  }
}
